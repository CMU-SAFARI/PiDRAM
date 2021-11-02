/*
 * Image streaming
 *
 * Copyright IBM, Corp. 2011
 *
 * Authors:
 *  Stefan Hajnoczi   <stefanha@linux.vnet.ibm.com>
 *
 * This work is licensed under the terms of the GNU LGPL, version 2 or later.
 * See the COPYING.LIB file in the top-level directory.
 *
 */

#include "qemu/osdep.h"
#include "trace.h"
#include "block/block_int.h"
#include "block/blockjob.h"
#include "qapi/error.h"
#include "qapi/qmp/qerror.h"
#include "qemu/ratelimit.h"
#include "sysemu/block-backend.h"

enum {
    /*
     * Size of data buffer for populating the image file.  This should be large
     * enough to process multiple clusters in a single call, so that populating
     * contiguous regions of the image is efficient.
     */
    STREAM_BUFFER_SIZE = 512 * 1024, /* in bytes */
};

#define SLICE_TIME 100000000ULL /* ns */

typedef struct StreamBlockJob {
    BlockJob common;
    RateLimit limit;
    BlockDriverState *base;
    BlockdevOnError on_error;
    char *backing_file_str;
} StreamBlockJob;

static int coroutine_fn stream_populate(BlockBackend *blk,
                                        int64_t sector_num, int nb_sectors,
                                        void *buf)
{
    struct iovec iov = {
        .iov_base = buf,
        .iov_len  = nb_sectors * BDRV_SECTOR_SIZE,
    };
    QEMUIOVector qiov;

    qemu_iovec_init_external(&qiov, &iov, 1);

    /* Copy-on-read the unallocated clusters */
    return blk_co_preadv(blk, sector_num * BDRV_SECTOR_SIZE, qiov.size, &qiov,
                         BDRV_REQ_COPY_ON_READ);
}

typedef struct {
    int ret;
    bool reached_end;
} StreamCompleteData;

static void stream_complete(BlockJob *job, void *opaque)
{
    StreamBlockJob *s = container_of(job, StreamBlockJob, common);
    StreamCompleteData *data = opaque;
    BlockDriverState *bs = blk_bs(job->blk);
    BlockDriverState *base = s->base;

    if (!block_job_is_cancelled(&s->common) && data->reached_end &&
        data->ret == 0) {
        const char *base_id = NULL, *base_fmt = NULL;
        if (base) {
            base_id = s->backing_file_str;
            if (base->drv) {
                base_fmt = base->drv->format_name;
            }
        }
        data->ret = bdrv_change_backing_file(bs, base_id, base_fmt);
        bdrv_set_backing_hd(bs, base);
    }

    g_free(s->backing_file_str);
    block_job_completed(&s->common, data->ret);
    g_free(data);
}

static void coroutine_fn stream_run(void *opaque)
{
    StreamBlockJob *s = opaque;
    StreamCompleteData *data;
    BlockBackend *blk = s->common.blk;
    BlockDriverState *bs = blk_bs(blk);
    BlockDriverState *base = s->base;
    int64_t sector_num = 0;
    int64_t end = -1;
    uint64_t delay_ns = 0;
    int error = 0;
    int ret = 0;
    int n = 0;
    void *buf;

    if (!bs->backing) {
        goto out;
    }

    s->common.len = bdrv_getlength(bs);
    if (s->common.len < 0) {
        ret = s->common.len;
        goto out;
    }

    end = s->common.len >> BDRV_SECTOR_BITS;
    buf = qemu_blockalign(bs, STREAM_BUFFER_SIZE);

    /* Turn on copy-on-read for the whole block device so that guest read
     * requests help us make progress.  Only do this when copying the entire
     * backing chain since the copy-on-read operation does not take base into
     * account.
     */
    if (!base) {
        bdrv_enable_copy_on_read(bs);
    }

    for (sector_num = 0; sector_num < end; sector_num += n) {
        bool copy;

        /* Note that even when no rate limit is applied we need to yield
         * with no pending I/O here so that bdrv_drain_all() returns.
         */
        block_job_sleep_ns(&s->common, QEMU_CLOCK_REALTIME, delay_ns);
        if (block_job_is_cancelled(&s->common)) {
            break;
        }

        copy = false;

        ret = bdrv_is_allocated(bs, sector_num,
                                STREAM_BUFFER_SIZE / BDRV_SECTOR_SIZE, &n);
        if (ret == 1) {
            /* Allocated in the top, no need to copy.  */
        } else if (ret >= 0) {
            /* Copy if allocated in the intermediate images.  Limit to the
             * known-unallocated area [sector_num, sector_num+n).  */
            ret = bdrv_is_allocated_above(backing_bs(bs), base,
                                          sector_num, n, &n);

            /* Finish early if end of backing file has been reached */
            if (ret == 0 && n == 0) {
                n = end - sector_num;
            }

            copy = (ret == 1);
        }
        trace_stream_one_iteration(s, sector_num, n, ret);
        if (copy) {
            ret = stream_populate(blk, sector_num, n, buf);
        }
        if (ret < 0) {
            BlockErrorAction action =
                block_job_error_action(&s->common, s->on_error, true, -ret);
            if (action == BLOCK_ERROR_ACTION_STOP) {
                n = 0;
                continue;
            }
            if (error == 0) {
                error = ret;
            }
            if (action == BLOCK_ERROR_ACTION_REPORT) {
                break;
            }
        }
        ret = 0;

        /* Publish progress */
        s->common.offset += n * BDRV_SECTOR_SIZE;
        if (copy && s->common.speed) {
            delay_ns = ratelimit_calculate_delay(&s->limit, n);
        }
    }

    if (!base) {
        bdrv_disable_copy_on_read(bs);
    }

    /* Do not remove the backing file if an error was there but ignored.  */
    ret = error;

    qemu_vfree(buf);

out:
    /* Modify backing chain and close BDSes in main loop */
    data = g_malloc(sizeof(*data));
    data->ret = ret;
    data->reached_end = sector_num == end;
    block_job_defer_to_main_loop(&s->common, stream_complete, data);
}

static void stream_set_speed(BlockJob *job, int64_t speed, Error **errp)
{
    StreamBlockJob *s = container_of(job, StreamBlockJob, common);

    if (speed < 0) {
        error_setg(errp, QERR_INVALID_PARAMETER, "speed");
        return;
    }
    ratelimit_set_speed(&s->limit, speed / BDRV_SECTOR_SIZE, SLICE_TIME);
}

static const BlockJobDriver stream_job_driver = {
    .instance_size = sizeof(StreamBlockJob),
    .job_type      = BLOCK_JOB_TYPE_STREAM,
    .set_speed     = stream_set_speed,
};

void stream_start(const char *job_id, BlockDriverState *bs,
                  BlockDriverState *base, const char *backing_file_str,
                  int64_t speed, BlockdevOnError on_error,
                  BlockCompletionFunc *cb, void *opaque, Error **errp)
{
    StreamBlockJob *s;

    s = block_job_create(job_id, &stream_job_driver, bs, speed,
                         cb, opaque, errp);
    if (!s) {
        return;
    }

    s->base = base;
    s->backing_file_str = g_strdup(backing_file_str);

    s->on_error = on_error;
    s->common.co = qemu_coroutine_create(stream_run, s);
    trace_stream_start(bs, base, s, s->common.co, opaque);
    qemu_coroutine_enter(s->common.co);
}
