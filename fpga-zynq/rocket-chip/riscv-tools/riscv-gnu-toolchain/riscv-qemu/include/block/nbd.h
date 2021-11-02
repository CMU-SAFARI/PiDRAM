/*
 *  Copyright (C) 2005  Anthony Liguori <anthony@codemonkey.ws>
 *
 *  Network Block Device
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; under version 2 of the License.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

#ifndef NBD_H
#define NBD_H


#include "qemu-common.h"
#include "qemu/option.h"
#include "io/channel-socket.h"
#include "crypto/tlscreds.h"

/* Note: these are _NOT_ the same as the network representation of an NBD
 * request and reply!
 */
struct nbd_request {
    uint64_t handle;
    uint64_t from;
    uint32_t len;
    uint32_t type;
};

struct nbd_reply {
    uint64_t handle;
    uint32_t error;
};

#define NBD_FLAG_HAS_FLAGS      (1 << 0)        /* Flags are there */
#define NBD_FLAG_READ_ONLY      (1 << 1)        /* Device is read-only */
#define NBD_FLAG_SEND_FLUSH     (1 << 2)        /* Send FLUSH */
#define NBD_FLAG_SEND_FUA       (1 << 3)        /* Send FUA (Force Unit Access) */
#define NBD_FLAG_ROTATIONAL     (1 << 4)        /* Use elevator algorithm - rotational media */
#define NBD_FLAG_SEND_TRIM      (1 << 5)        /* Send TRIM (discard) */

/* New-style global flags. */
#define NBD_FLAG_FIXED_NEWSTYLE     (1 << 0)    /* Fixed newstyle protocol. */

/* New-style client flags. */
#define NBD_FLAG_C_FIXED_NEWSTYLE   (1 << 0)    /* Fixed newstyle protocol. */

/* Reply types. */
#define NBD_REP_ACK             (1)             /* Data sending finished. */
#define NBD_REP_SERVER          (2)             /* Export description. */
#define NBD_REP_ERR_UNSUP       ((UINT32_C(1) << 31) | 1) /* Unknown option. */
#define NBD_REP_ERR_POLICY      ((UINT32_C(1) << 31) | 2) /* Server denied */
#define NBD_REP_ERR_INVALID     ((UINT32_C(1) << 31) | 3) /* Invalid length. */
#define NBD_REP_ERR_TLS_REQD    ((UINT32_C(1) << 31) | 5) /* TLS required */


#define NBD_CMD_MASK_COMMAND	0x0000ffff
#define NBD_CMD_FLAG_FUA	(1 << 16)

enum {
    NBD_CMD_READ = 0,
    NBD_CMD_WRITE = 1,
    NBD_CMD_DISC = 2,
    NBD_CMD_FLUSH = 3,
    NBD_CMD_TRIM = 4
};

#define NBD_DEFAULT_PORT	10809

/* Maximum size of a single READ/WRITE data buffer */
#define NBD_MAX_BUFFER_SIZE (32 * 1024 * 1024)

/* Maximum size of an export name. The NBD spec requires 256 and
 * suggests that servers support up to 4096, but we stick to only the
 * required size so that we can stack-allocate the names, and because
 * going larger would require an audit of more code to make sure we
 * aren't overflowing some other buffer. */
#define NBD_MAX_NAME_SIZE 256

ssize_t nbd_wr_syncv(QIOChannel *ioc,
                     struct iovec *iov,
                     size_t niov,
                     size_t length,
                     bool do_read);
int nbd_receive_negotiate(QIOChannel *ioc, const char *name, uint16_t *flags,
                          QCryptoTLSCreds *tlscreds, const char *hostname,
                          QIOChannel **outioc,
                          off_t *size, Error **errp);
int nbd_init(int fd, QIOChannelSocket *sioc, uint16_t flags, off_t size);
ssize_t nbd_send_request(QIOChannel *ioc, struct nbd_request *request);
ssize_t nbd_receive_reply(QIOChannel *ioc, struct nbd_reply *reply);
int nbd_client(int fd);
int nbd_disconnect(int fd);

typedef struct NBDExport NBDExport;
typedef struct NBDClient NBDClient;

NBDExport *nbd_export_new(BlockDriverState *bs, off_t dev_offset, off_t size,
                          uint16_t nbdflags, void (*close)(NBDExport *),
                          bool writethrough, BlockBackend *on_eject_blk,
                          Error **errp);
void nbd_export_close(NBDExport *exp);
void nbd_export_get(NBDExport *exp);
void nbd_export_put(NBDExport *exp);

BlockBackend *nbd_export_get_blockdev(NBDExport *exp);

NBDExport *nbd_export_find(const char *name);
void nbd_export_set_name(NBDExport *exp, const char *name);
void nbd_export_close_all(void);

void nbd_client_new(NBDExport *exp,
                    QIOChannelSocket *sioc,
                    QCryptoTLSCreds *tlscreds,
                    const char *tlsaclname,
                    void (*close)(NBDClient *));
void nbd_client_get(NBDClient *client);
void nbd_client_put(NBDClient *client);

#endif
