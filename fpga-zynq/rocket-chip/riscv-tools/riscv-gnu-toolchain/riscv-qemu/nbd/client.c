/*
 *  Copyright (C) 2005  Anthony Liguori <anthony@codemonkey.ws>
 *
 *  Network Block Device Client Side
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

#include "qemu/osdep.h"
#include "qapi/error.h"
#include "nbd-internal.h"

static int nbd_errno_to_system_errno(int err)
{
    switch (err) {
    case NBD_SUCCESS:
        return 0;
    case NBD_EPERM:
        return EPERM;
    case NBD_EIO:
        return EIO;
    case NBD_ENOMEM:
        return ENOMEM;
    case NBD_ENOSPC:
        return ENOSPC;
    default:
        TRACE("Squashing unexpected error %d to EINVAL", err);
        /* fallthrough */
    case NBD_EINVAL:
        return EINVAL;
    }
}

/* Definitions for opaque data types */

static QTAILQ_HEAD(, NBDExport) exports = QTAILQ_HEAD_INITIALIZER(exports);

/* That's all folks */

/* Basic flow for negotiation

   Server         Client
   Negotiate

   or

   Server         Client
   Negotiate #1
                  Option
   Negotiate #2

   ----

   followed by

   Server         Client
                  Request
   Response
                  Request
   Response
                  ...
   ...
                  Request (type == 2)

*/


/* If type represents success, return 1 without further action.
 * If type represents an error reply, consume the rest of the packet on ioc.
 * Then return 0 for unsupported (so the client can fall back to
 * other approaches), or -1 with errp set for other errors.
 */
static int nbd_handle_reply_err(QIOChannel *ioc, uint32_t opt, uint32_t type,
                                Error **errp)
{
    uint32_t len;
    char *msg = NULL;
    int result = -1;

    if (!(type & (1 << 31))) {
        return 1;
    }

    if (read_sync(ioc, &len, sizeof(len)) != sizeof(len)) {
        error_setg(errp, "failed to read option length");
        return -1;
    }
    len = be32_to_cpu(len);
    if (len) {
        if (len > NBD_MAX_BUFFER_SIZE) {
            error_setg(errp, "server's error message is too long");
            goto cleanup;
        }
        msg = g_malloc(len + 1);
        if (read_sync(ioc, msg, len) != len) {
            error_setg(errp, "failed to read option error message");
            goto cleanup;
        }
        msg[len] = '\0';
    }

    switch (type) {
    case NBD_REP_ERR_UNSUP:
        TRACE("server doesn't understand request %" PRIx32
              ", attempting fallback", opt);
        result = 0;
        goto cleanup;

    case NBD_REP_ERR_POLICY:
        error_setg(errp, "Denied by server for option %" PRIx32, opt);
        break;

    case NBD_REP_ERR_INVALID:
        error_setg(errp, "Invalid data length for option %" PRIx32, opt);
        break;

    case NBD_REP_ERR_TLS_REQD:
        error_setg(errp, "TLS negotiation required before option %" PRIx32,
                   opt);
        break;

    default:
        error_setg(errp, "Unknown error code when asking for option %" PRIx32,
                   opt);
        break;
    }

    if (msg) {
        error_append_hint(errp, "%s\n", msg);
    }

 cleanup:
    g_free(msg);
    return result;
}

static int nbd_receive_list(QIOChannel *ioc, char **name, Error **errp)
{
    uint64_t magic;
    uint32_t opt;
    uint32_t type;
    uint32_t len;
    uint32_t namelen;
    int error;

    *name = NULL;
    if (read_sync(ioc, &magic, sizeof(magic)) != sizeof(magic)) {
        error_setg(errp, "failed to read list option magic");
        return -1;
    }
    magic = be64_to_cpu(magic);
    if (magic != NBD_REP_MAGIC) {
        error_setg(errp, "Unexpected option list magic");
        return -1;
    }
    if (read_sync(ioc, &opt, sizeof(opt)) != sizeof(opt)) {
        error_setg(errp, "failed to read list option");
        return -1;
    }
    opt = be32_to_cpu(opt);
    if (opt != NBD_OPT_LIST) {
        error_setg(errp, "Unexpected option type %" PRIx32 " expected %x",
                   opt, NBD_OPT_LIST);
        return -1;
    }

    if (read_sync(ioc, &type, sizeof(type)) != sizeof(type)) {
        error_setg(errp, "failed to read list option type");
        return -1;
    }
    type = be32_to_cpu(type);
    error = nbd_handle_reply_err(ioc, opt, type, errp);
    if (error <= 0) {
        return error;
    }

    if (read_sync(ioc, &len, sizeof(len)) != sizeof(len)) {
        error_setg(errp, "failed to read option length");
        return -1;
    }
    len = be32_to_cpu(len);

    if (type == NBD_REP_ACK) {
        if (len != 0) {
            error_setg(errp, "length too long for option end");
            return -1;
        }
    } else if (type == NBD_REP_SERVER) {
        if (len < sizeof(namelen) || len > NBD_MAX_BUFFER_SIZE) {
            error_setg(errp, "incorrect option length");
            return -1;
        }
        if (read_sync(ioc, &namelen, sizeof(namelen)) != sizeof(namelen)) {
            error_setg(errp, "failed to read option name length");
            return -1;
        }
        namelen = be32_to_cpu(namelen);
        len -= sizeof(namelen);
        if (len < namelen) {
            error_setg(errp, "incorrect option name length");
            return -1;
        }
        if (namelen > NBD_MAX_NAME_SIZE) {
            error_setg(errp, "export name length too long %" PRIu32, namelen);
            return -1;
        }

        *name = g_new0(char, namelen + 1);
        if (read_sync(ioc, *name, namelen) != namelen) {
            error_setg(errp, "failed to read export name");
            g_free(*name);
            *name = NULL;
            return -1;
        }
        (*name)[namelen] = '\0';
        len -= namelen;
        if (len) {
            char *buf = g_malloc(len + 1);
            if (read_sync(ioc, buf, len) != len) {
                error_setg(errp, "failed to read export description");
                g_free(*name);
                g_free(buf);
                *name = NULL;
                return -1;
            }
            buf[len] = '\0';
            TRACE("Ignoring export description: %s", buf);
            g_free(buf);
        }
    } else {
        error_setg(errp, "Unexpected reply type %" PRIx32 " expected %x",
                   type, NBD_REP_SERVER);
        return -1;
    }
    return 1;
}


static int nbd_receive_query_exports(QIOChannel *ioc,
                                     const char *wantname,
                                     Error **errp)
{
    uint64_t magic = cpu_to_be64(NBD_OPTS_MAGIC);
    uint32_t opt = cpu_to_be32(NBD_OPT_LIST);
    uint32_t length = 0;
    bool foundExport = false;

    TRACE("Querying export list");
    if (write_sync(ioc, &magic, sizeof(magic)) != sizeof(magic)) {
        error_setg(errp, "Failed to send list option magic");
        return -1;
    }

    if (write_sync(ioc, &opt, sizeof(opt)) != sizeof(opt)) {
        error_setg(errp, "Failed to send list option number");
        return -1;
    }

    if (write_sync(ioc, &length, sizeof(length)) != sizeof(length)) {
        error_setg(errp, "Failed to send list option length");
        return -1;
    }

    TRACE("Reading available export names");
    while (1) {
        char *name = NULL;
        int ret = nbd_receive_list(ioc, &name, errp);

        if (ret < 0) {
            g_free(name);
            name = NULL;
            return -1;
        }
        if (ret == 0) {
            /* Server doesn't support export listing, so
             * we will just assume an export with our
             * wanted name exists */
            foundExport = true;
            break;
        }
        if (name == NULL) {
            TRACE("End of export name list");
            break;
        }
        if (g_str_equal(name, wantname)) {
            foundExport = true;
            TRACE("Found desired export name '%s'", name);
        } else {
            TRACE("Ignored export name '%s'", name);
        }
        g_free(name);
    }

    if (!foundExport) {
        error_setg(errp, "No export with name '%s' available", wantname);
        return -1;
    }

    return 0;
}

static QIOChannel *nbd_receive_starttls(QIOChannel *ioc,
                                        QCryptoTLSCreds *tlscreds,
                                        const char *hostname, Error **errp)
{
    uint64_t magic = cpu_to_be64(NBD_OPTS_MAGIC);
    uint32_t opt = cpu_to_be32(NBD_OPT_STARTTLS);
    uint32_t length = 0;
    uint32_t type;
    QIOChannelTLS *tioc;
    struct NBDTLSHandshakeData data = { 0 };

    TRACE("Requesting TLS from server");
    if (write_sync(ioc, &magic, sizeof(magic)) != sizeof(magic)) {
        error_setg(errp, "Failed to send option magic");
        return NULL;
    }

    if (write_sync(ioc, &opt, sizeof(opt)) != sizeof(opt)) {
        error_setg(errp, "Failed to send option number");
        return NULL;
    }

    if (write_sync(ioc, &length, sizeof(length)) != sizeof(length)) {
        error_setg(errp, "Failed to send option length");
        return NULL;
    }

    TRACE("Getting TLS reply from server1");
    if (read_sync(ioc, &magic, sizeof(magic)) != sizeof(magic)) {
        error_setg(errp, "failed to read option magic");
        return NULL;
    }
    magic = be64_to_cpu(magic);
    if (magic != NBD_REP_MAGIC) {
        error_setg(errp, "Unexpected option magic");
        return NULL;
    }
    TRACE("Getting TLS reply from server2");
    if (read_sync(ioc, &opt, sizeof(opt)) != sizeof(opt)) {
        error_setg(errp, "failed to read option");
        return NULL;
    }
    opt = be32_to_cpu(opt);
    if (opt != NBD_OPT_STARTTLS) {
        error_setg(errp, "Unexpected option type %" PRIx32 " expected %x",
                   opt, NBD_OPT_STARTTLS);
        return NULL;
    }

    TRACE("Getting TLS reply from server");
    if (read_sync(ioc, &type, sizeof(type)) != sizeof(type)) {
        error_setg(errp, "failed to read option type");
        return NULL;
    }
    type = be32_to_cpu(type);
    if (type != NBD_REP_ACK) {
        error_setg(errp, "Server rejected request to start TLS %" PRIx32,
                   type);
        return NULL;
    }

    TRACE("Getting TLS reply from server");
    if (read_sync(ioc, &length, sizeof(length)) != sizeof(length)) {
        error_setg(errp, "failed to read option length");
        return NULL;
    }
    length = be32_to_cpu(length);
    if (length != 0) {
        error_setg(errp, "Start TLS response was not zero %" PRIu32,
                   length);
        return NULL;
    }

    TRACE("TLS request approved, setting up TLS");
    tioc = qio_channel_tls_new_client(ioc, tlscreds, hostname, errp);
    if (!tioc) {
        return NULL;
    }
    data.loop = g_main_loop_new(g_main_context_default(), FALSE);
    TRACE("Starting TLS handshake");
    qio_channel_tls_handshake(tioc,
                              nbd_tls_handshake,
                              &data,
                              NULL);

    if (!data.complete) {
        g_main_loop_run(data.loop);
    }
    g_main_loop_unref(data.loop);
    if (data.error) {
        error_propagate(errp, data.error);
        object_unref(OBJECT(tioc));
        return NULL;
    }

    return QIO_CHANNEL(tioc);
}


int nbd_receive_negotiate(QIOChannel *ioc, const char *name, uint16_t *flags,
                          QCryptoTLSCreds *tlscreds, const char *hostname,
                          QIOChannel **outioc,
                          off_t *size, Error **errp)
{
    char buf[256];
    uint64_t magic, s;
    int rc;

    TRACE("Receiving negotiation tlscreds=%p hostname=%s.",
          tlscreds, hostname ? hostname : "<null>");

    rc = -EINVAL;

    if (outioc) {
        *outioc = NULL;
    }
    if (tlscreds && !outioc) {
        error_setg(errp, "Output I/O channel required for TLS");
        goto fail;
    }

    if (read_sync(ioc, buf, 8) != 8) {
        error_setg(errp, "Failed to read data");
        goto fail;
    }

    buf[8] = '\0';
    if (strlen(buf) == 0) {
        error_setg(errp, "Server connection closed unexpectedly");
        goto fail;
    }

    TRACE("Magic is %c%c%c%c%c%c%c%c",
          qemu_isprint(buf[0]) ? buf[0] : '.',
          qemu_isprint(buf[1]) ? buf[1] : '.',
          qemu_isprint(buf[2]) ? buf[2] : '.',
          qemu_isprint(buf[3]) ? buf[3] : '.',
          qemu_isprint(buf[4]) ? buf[4] : '.',
          qemu_isprint(buf[5]) ? buf[5] : '.',
          qemu_isprint(buf[6]) ? buf[6] : '.',
          qemu_isprint(buf[7]) ? buf[7] : '.');

    if (memcmp(buf, "NBDMAGIC", 8) != 0) {
        error_setg(errp, "Invalid magic received");
        goto fail;
    }

    if (read_sync(ioc, &magic, sizeof(magic)) != sizeof(magic)) {
        error_setg(errp, "Failed to read magic");
        goto fail;
    }
    magic = be64_to_cpu(magic);
    TRACE("Magic is 0x%" PRIx64, magic);

    if (magic == NBD_OPTS_MAGIC) {
        uint32_t clientflags = 0;
        uint32_t opt;
        uint32_t namesize;
        uint16_t globalflags;
        bool fixedNewStyle = false;

        if (read_sync(ioc, &globalflags, sizeof(globalflags)) !=
            sizeof(globalflags)) {
            error_setg(errp, "Failed to read server flags");
            goto fail;
        }
        globalflags = be16_to_cpu(globalflags);
        TRACE("Global flags are %" PRIx32, globalflags);
        if (globalflags & NBD_FLAG_FIXED_NEWSTYLE) {
            fixedNewStyle = true;
            TRACE("Server supports fixed new style");
            clientflags |= NBD_FLAG_C_FIXED_NEWSTYLE;
        }
        /* client requested flags */
        clientflags = cpu_to_be32(clientflags);
        if (write_sync(ioc, &clientflags, sizeof(clientflags)) !=
            sizeof(clientflags)) {
            error_setg(errp, "Failed to send clientflags field");
            goto fail;
        }
        if (tlscreds) {
            if (fixedNewStyle) {
                *outioc = nbd_receive_starttls(ioc, tlscreds, hostname, errp);
                if (!*outioc) {
                    goto fail;
                }
                ioc = *outioc;
            } else {
                error_setg(errp, "Server does not support STARTTLS");
                goto fail;
            }
        }
        if (!name) {
            TRACE("Using default NBD export name \"\"");
            name = "";
        }
        if (fixedNewStyle) {
            /* Check our desired export is present in the
             * server export list. Since NBD_OPT_EXPORT_NAME
             * cannot return an error message, running this
             * query gives us good error reporting if the
             * server required TLS
             */
            if (nbd_receive_query_exports(ioc, name, errp) < 0) {
                goto fail;
            }
        }
        /* write the export name */
        magic = cpu_to_be64(magic);
        if (write_sync(ioc, &magic, sizeof(magic)) != sizeof(magic)) {
            error_setg(errp, "Failed to send export name magic");
            goto fail;
        }
        opt = cpu_to_be32(NBD_OPT_EXPORT_NAME);
        if (write_sync(ioc, &opt, sizeof(opt)) != sizeof(opt)) {
            error_setg(errp, "Failed to send export name option number");
            goto fail;
        }
        namesize = cpu_to_be32(strlen(name));
        if (write_sync(ioc, &namesize, sizeof(namesize)) !=
            sizeof(namesize)) {
            error_setg(errp, "Failed to send export name length");
            goto fail;
        }
        if (write_sync(ioc, (char *)name, strlen(name)) != strlen(name)) {
            error_setg(errp, "Failed to send export name");
            goto fail;
        }

        if (read_sync(ioc, &s, sizeof(s)) != sizeof(s)) {
            error_setg(errp, "Failed to read export length");
            goto fail;
        }
        *size = be64_to_cpu(s);

        if (read_sync(ioc, flags, sizeof(*flags)) != sizeof(*flags)) {
            error_setg(errp, "Failed to read export flags");
            goto fail;
        }
        be16_to_cpus(flags);
    } else if (magic == NBD_CLIENT_MAGIC) {
        uint32_t oldflags;

        if (name) {
            error_setg(errp, "Server does not support export names");
            goto fail;
        }
        if (tlscreds) {
            error_setg(errp, "Server does not support STARTTLS");
            goto fail;
        }

        if (read_sync(ioc, &s, sizeof(s)) != sizeof(s)) {
            error_setg(errp, "Failed to read export length");
            goto fail;
        }
        *size = be64_to_cpu(s);
        TRACE("Size is %" PRIu64, *size);

        if (read_sync(ioc, &oldflags, sizeof(oldflags)) != sizeof(oldflags)) {
            error_setg(errp, "Failed to read export flags");
            goto fail;
        }
        be32_to_cpus(&oldflags);
        if (oldflags & ~0xffff) {
            error_setg(errp, "Unexpected export flags %0x" PRIx32, oldflags);
            goto fail;
        }
        *flags = oldflags;
    } else {
        error_setg(errp, "Bad magic received");
        goto fail;
    }

    TRACE("Size is %" PRIu64 ", export flags %" PRIx16, *size, *flags);
    if (read_sync(ioc, &buf, 124) != 124) {
        error_setg(errp, "Failed to read reserved block");
        goto fail;
    }
    rc = 0;

fail:
    return rc;
}

#ifdef __linux__
int nbd_init(int fd, QIOChannelSocket *sioc, uint16_t flags, off_t size)
{
    unsigned long sectors = size / BDRV_SECTOR_SIZE;
    if (size / BDRV_SECTOR_SIZE != sectors) {
        LOG("Export size %lld too large for 32-bit kernel", (long long) size);
        return -E2BIG;
    }

    TRACE("Setting NBD socket");

    if (ioctl(fd, NBD_SET_SOCK, (unsigned long) sioc->fd) < 0) {
        int serrno = errno;
        LOG("Failed to set NBD socket");
        return -serrno;
    }

    TRACE("Setting block size to %lu", (unsigned long)BDRV_SECTOR_SIZE);

    if (ioctl(fd, NBD_SET_BLKSIZE, (unsigned long)BDRV_SECTOR_SIZE) < 0) {
        int serrno = errno;
        LOG("Failed setting NBD block size");
        return -serrno;
    }

    TRACE("Setting size to %lu block(s)", sectors);
    if (size % BDRV_SECTOR_SIZE) {
        TRACE("Ignoring trailing %d bytes of export",
              (int) (size % BDRV_SECTOR_SIZE));
    }

    if (ioctl(fd, NBD_SET_SIZE_BLOCKS, sectors) < 0) {
        int serrno = errno;
        LOG("Failed setting size (in blocks)");
        return -serrno;
    }

    if (ioctl(fd, NBD_SET_FLAGS, (unsigned long) flags) < 0) {
        if (errno == ENOTTY) {
            int read_only = (flags & NBD_FLAG_READ_ONLY) != 0;
            TRACE("Setting readonly attribute");

            if (ioctl(fd, BLKROSET, (unsigned long) &read_only) < 0) {
                int serrno = errno;
                LOG("Failed setting read-only attribute");
                return -serrno;
            }
        } else {
            int serrno = errno;
            LOG("Failed setting flags");
            return -serrno;
        }
    }

    TRACE("Negotiation ended");

    return 0;
}

int nbd_client(int fd)
{
    int ret;
    int serrno;

    TRACE("Doing NBD loop");

    ret = ioctl(fd, NBD_DO_IT);
    if (ret < 0 && errno == EPIPE) {
        /* NBD_DO_IT normally returns EPIPE when someone has disconnected
         * the socket via NBD_DISCONNECT.  We do not want to return 1 in
         * that case.
         */
        ret = 0;
    }
    serrno = errno;

    TRACE("NBD loop returned %d: %s", ret, strerror(serrno));

    TRACE("Clearing NBD queue");
    ioctl(fd, NBD_CLEAR_QUE);

    TRACE("Clearing NBD socket");
    ioctl(fd, NBD_CLEAR_SOCK);

    errno = serrno;
    return ret;
}

int nbd_disconnect(int fd)
{
    ioctl(fd, NBD_CLEAR_QUE);
    ioctl(fd, NBD_DISCONNECT);
    ioctl(fd, NBD_CLEAR_SOCK);
    return 0;
}

#else
int nbd_init(int fd, QIOChannelSocket *ioc, uint16_t flags, off_t size)
{
    return -ENOTSUP;
}

int nbd_client(int fd)
{
    return -ENOTSUP;
}
int nbd_disconnect(int fd)
{
    return -ENOTSUP;
}
#endif

ssize_t nbd_send_request(QIOChannel *ioc, struct nbd_request *request)
{
    uint8_t buf[NBD_REQUEST_SIZE];
    ssize_t ret;

    TRACE("Sending request to server: "
          "{ .from = %" PRIu64", .len = %" PRIu32 ", .handle = %" PRIu64
          ", .type=%" PRIu32 " }",
          request->from, request->len, request->handle, request->type);

    stl_be_p(buf, NBD_REQUEST_MAGIC);
    stl_be_p(buf + 4, request->type);
    stq_be_p(buf + 8, request->handle);
    stq_be_p(buf + 16, request->from);
    stl_be_p(buf + 24, request->len);

    ret = write_sync(ioc, buf, sizeof(buf));
    if (ret < 0) {
        return ret;
    }

    if (ret != sizeof(buf)) {
        LOG("writing to socket failed");
        return -EINVAL;
    }
    return 0;
}

ssize_t nbd_receive_reply(QIOChannel *ioc, struct nbd_reply *reply)
{
    uint8_t buf[NBD_REPLY_SIZE];
    uint32_t magic;
    ssize_t ret;

    ret = read_sync(ioc, buf, sizeof(buf));
    if (ret < 0) {
        return ret;
    }

    if (ret != sizeof(buf)) {
        LOG("read failed");
        return -EINVAL;
    }

    /* Reply
       [ 0 ..  3]    magic   (NBD_REPLY_MAGIC)
       [ 4 ..  7]    error   (0 == no error)
       [ 7 .. 15]    handle
     */

    magic = ldl_be_p(buf);
    reply->error  = ldl_be_p(buf + 4);
    reply->handle = ldq_be_p(buf + 8);

    reply->error = nbd_errno_to_system_errno(reply->error);

    TRACE("Got reply: { magic = 0x%" PRIx32 ", .error = % " PRId32
          ", handle = %" PRIu64" }",
          magic, reply->error, reply->handle);

    if (magic != NBD_REPLY_MAGIC) {
        LOG("invalid magic (got 0x%" PRIx32 ")", magic);
        return -EINVAL;
    }
    return 0;
}

