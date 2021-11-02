/*
 * Simple C functions to supplement the C library
 *
 * Copyright (c) 2006 Fabrice Bellard
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
#include "qemu/osdep.h"
#include "qemu-common.h"
#include "qemu/host-utils.h"
#include <math.h>

#include "qemu/sockets.h"
#include "qemu/iov.h"
#include "net/net.h"
#include "qemu/cutils.h"

void strpadcpy(char *buf, int buf_size, const char *str, char pad)
{
    int len = qemu_strnlen(str, buf_size);
    memcpy(buf, str, len);
    memset(buf + len, pad, buf_size - len);
}

void pstrcpy(char *buf, int buf_size, const char *str)
{
    int c;
    char *q = buf;

    if (buf_size <= 0)
        return;

    for(;;) {
        c = *str++;
        if (c == 0 || q >= buf + buf_size - 1)
            break;
        *q++ = c;
    }
    *q = '\0';
}

/* strcat and truncate. */
char *pstrcat(char *buf, int buf_size, const char *s)
{
    int len;
    len = strlen(buf);
    if (len < buf_size)
        pstrcpy(buf + len, buf_size - len, s);
    return buf;
}

int strstart(const char *str, const char *val, const char **ptr)
{
    const char *p, *q;
    p = str;
    q = val;
    while (*q != '\0') {
        if (*p != *q)
            return 0;
        p++;
        q++;
    }
    if (ptr)
        *ptr = p;
    return 1;
}

int stristart(const char *str, const char *val, const char **ptr)
{
    const char *p, *q;
    p = str;
    q = val;
    while (*q != '\0') {
        if (qemu_toupper(*p) != qemu_toupper(*q))
            return 0;
        p++;
        q++;
    }
    if (ptr)
        *ptr = p;
    return 1;
}

/* XXX: use host strnlen if available ? */
int qemu_strnlen(const char *s, int max_len)
{
    int i;

    for(i = 0; i < max_len; i++) {
        if (s[i] == '\0') {
            break;
        }
    }
    return i;
}

char *qemu_strsep(char **input, const char *delim)
{
    char *result = *input;
    if (result != NULL) {
        char *p;

        for (p = result; *p != '\0'; p++) {
            if (strchr(delim, *p)) {
                break;
            }
        }
        if (*p == '\0') {
            *input = NULL;
        } else {
            *p = '\0';
            *input = p + 1;
        }
    }
    return result;
}

time_t mktimegm(struct tm *tm)
{
    time_t t;
    int y = tm->tm_year + 1900, m = tm->tm_mon + 1, d = tm->tm_mday;
    if (m < 3) {
        m += 12;
        y--;
    }
    t = 86400ULL * (d + (153 * m - 457) / 5 + 365 * y + y / 4 - y / 100 + 
                 y / 400 - 719469);
    t += 3600 * tm->tm_hour + 60 * tm->tm_min + tm->tm_sec;
    return t;
}

/*
 * Make sure data goes on disk, but if possible do not bother to
 * write out the inode just for timestamp updates.
 *
 * Unfortunately even in 2009 many operating systems do not support
 * fdatasync and have to fall back to fsync.
 */
int qemu_fdatasync(int fd)
{
#ifdef CONFIG_FDATASYNC
    return fdatasync(fd);
#else
    return fsync(fd);
#endif
}

#ifndef _WIN32
/* Sets a specific flag */
int fcntl_setfl(int fd, int flag)
{
    int flags;

    flags = fcntl(fd, F_GETFL);
    if (flags == -1)
        return -errno;

    if (fcntl(fd, F_SETFL, flags | flag) == -1)
        return -errno;

    return 0;
}
#endif

static int64_t suffix_mul(char suffix, int64_t unit)
{
    switch (qemu_toupper(suffix)) {
    case QEMU_STRTOSZ_DEFSUFFIX_B:
        return 1;
    case QEMU_STRTOSZ_DEFSUFFIX_KB:
        return unit;
    case QEMU_STRTOSZ_DEFSUFFIX_MB:
        return unit * unit;
    case QEMU_STRTOSZ_DEFSUFFIX_GB:
        return unit * unit * unit;
    case QEMU_STRTOSZ_DEFSUFFIX_TB:
        return unit * unit * unit * unit;
    case QEMU_STRTOSZ_DEFSUFFIX_PB:
        return unit * unit * unit * unit * unit;
    case QEMU_STRTOSZ_DEFSUFFIX_EB:
        return unit * unit * unit * unit * unit * unit;
    }
    return -1;
}

/*
 * Convert string to bytes, allowing either B/b for bytes, K/k for KB,
 * M/m for MB, G/g for GB or T/t for TB. End pointer will be returned
 * in *end, if not NULL. Return -ERANGE on overflow, Return -EINVAL on
 * other error.
 */
int64_t qemu_strtosz_suffix_unit(const char *nptr, char **end,
                            const char default_suffix, int64_t unit)
{
    int64_t retval = -EINVAL;
    char *endptr;
    unsigned char c;
    int mul_required = 0;
    double val, mul, integral, fraction;

    errno = 0;
    val = strtod(nptr, &endptr);
    if (isnan(val) || endptr == nptr || errno != 0) {
        goto fail;
    }
    fraction = modf(val, &integral);
    if (fraction != 0) {
        mul_required = 1;
    }
    c = *endptr;
    mul = suffix_mul(c, unit);
    if (mul >= 0) {
        endptr++;
    } else {
        mul = suffix_mul(default_suffix, unit);
        assert(mul >= 0);
    }
    if (mul == 1 && mul_required) {
        goto fail;
    }
    if ((val * mul >= INT64_MAX) || val < 0) {
        retval = -ERANGE;
        goto fail;
    }
    retval = val * mul;

fail:
    if (end) {
        *end = endptr;
    }

    return retval;
}

int64_t qemu_strtosz_suffix(const char *nptr, char **end,
                            const char default_suffix)
{
    return qemu_strtosz_suffix_unit(nptr, end, default_suffix, 1024);
}

int64_t qemu_strtosz(const char *nptr, char **end)
{
    return qemu_strtosz_suffix(nptr, end, QEMU_STRTOSZ_DEFSUFFIX_MB);
}

/**
 * Helper function for qemu_strto*l() functions.
 */
static int check_strtox_error(const char *p, char *endptr, const char **next,
                              int err)
{
    /* If no conversion was performed, prefer BSD behavior over glibc
     * behavior.
     */
    if (err == 0 && endptr == p) {
        err = EINVAL;
    }
    if (!next && *endptr) {
        return -EINVAL;
    }
    if (next) {
        *next = endptr;
    }
    return -err;
}

/**
 * QEMU wrappers for strtol(), strtoll(), strtoul(), strotull() C functions.
 *
 * Convert ASCII string @nptr to a long integer value
 * from the given @base. Parameters @nptr, @endptr, @base
 * follows same semantics as strtol() C function.
 *
 * Unlike from strtol() function, if @endptr is not NULL, this
 * function will return -EINVAL whenever it cannot fully convert
 * the string in @nptr with given @base to a long. This function returns
 * the result of the conversion only through the @result parameter.
 *
 * If NULL is passed in @endptr, then the whole string in @ntpr
 * is a number otherwise it returns -EINVAL.
 *
 * RETURN VALUE
 * Unlike from strtol() function, this wrapper returns either
 * -EINVAL or the errno set by strtol() function (e.g -ERANGE).
 * If the conversion overflows, -ERANGE is returned, and @result
 * is set to the max value of the desired type
 * (e.g. LONG_MAX, LLONG_MAX, ULONG_MAX, ULLONG_MAX). If the case
 * of underflow, -ERANGE is returned, and @result is set to the min
 * value of the desired type. For strtol(), strtoll(), @result is set to
 * LONG_MIN, LLONG_MIN, respectively, and for strtoul(), strtoull() it
 * is set to 0.
 */
int qemu_strtol(const char *nptr, const char **endptr, int base,
                long *result)
{
    char *p;
    int err = 0;
    if (!nptr) {
        if (endptr) {
            *endptr = nptr;
        }
        err = -EINVAL;
    } else {
        errno = 0;
        *result = strtol(nptr, &p, base);
        err = check_strtox_error(nptr, p, endptr, errno);
    }
    return err;
}

/**
 * Converts ASCII string to an unsigned long integer.
 *
 * If string contains a negative number, value will be converted to
 * the unsigned representation of the signed value, unless the original
 * (nonnegated) value would overflow, in this case, it will set @result
 * to ULONG_MAX, and return ERANGE.
 *
 * The same behavior holds, for qemu_strtoull() but sets @result to
 * ULLONG_MAX instead of ULONG_MAX.
 *
 * See qemu_strtol() documentation for more info.
 */
int qemu_strtoul(const char *nptr, const char **endptr, int base,
                 unsigned long *result)
{
    char *p;
    int err = 0;
    if (!nptr) {
        if (endptr) {
            *endptr = nptr;
        }
        err = -EINVAL;
    } else {
        errno = 0;
        *result = strtoul(nptr, &p, base);
        /* Windows returns 1 for negative out-of-range values.  */
        if (errno == ERANGE) {
            *result = -1;
        }
        err = check_strtox_error(nptr, p, endptr, errno);
    }
    return err;
}

/**
 * Converts ASCII string to a long long integer.
 *
 * See qemu_strtol() documentation for more info.
 */
int qemu_strtoll(const char *nptr, const char **endptr, int base,
                 int64_t *result)
{
    char *p;
    int err = 0;
    if (!nptr) {
        if (endptr) {
            *endptr = nptr;
        }
        err = -EINVAL;
    } else {
        errno = 0;
        *result = strtoll(nptr, &p, base);
        err = check_strtox_error(nptr, p, endptr, errno);
    }
    return err;
}

/**
 * Converts ASCII string to an unsigned long long integer.
 *
 * See qemu_strtol() documentation for more info.
 */
int qemu_strtoull(const char *nptr, const char **endptr, int base,
                  uint64_t *result)
{
    char *p;
    int err = 0;
    if (!nptr) {
        if (endptr) {
            *endptr = nptr;
        }
        err = -EINVAL;
    } else {
        errno = 0;
        *result = strtoull(nptr, &p, base);
        /* Windows returns 1 for negative out-of-range values.  */
        if (errno == ERANGE) {
            *result = -1;
        }
        err = check_strtox_error(nptr, p, endptr, errno);
    }
    return err;
}

/**
 * parse_uint:
 *
 * @s: String to parse
 * @value: Destination for parsed integer value
 * @endptr: Destination for pointer to first character not consumed
 * @base: integer base, between 2 and 36 inclusive, or 0
 *
 * Parse unsigned integer
 *
 * Parsed syntax is like strtoull()'s: arbitrary whitespace, a single optional
 * '+' or '-', an optional "0x" if @base is 0 or 16, one or more digits.
 *
 * If @s is null, or @base is invalid, or @s doesn't start with an
 * integer in the syntax above, set *@value to 0, *@endptr to @s, and
 * return -EINVAL.
 *
 * Set *@endptr to point right beyond the parsed integer (even if the integer
 * overflows or is negative, all digits will be parsed and *@endptr will
 * point right beyond them).
 *
 * If the integer is negative, set *@value to 0, and return -ERANGE.
 *
 * If the integer overflows unsigned long long, set *@value to
 * ULLONG_MAX, and return -ERANGE.
 *
 * Else, set *@value to the parsed integer, and return 0.
 */
int parse_uint(const char *s, unsigned long long *value, char **endptr,
               int base)
{
    int r = 0;
    char *endp = (char *)s;
    unsigned long long val = 0;

    if (!s) {
        r = -EINVAL;
        goto out;
    }

    errno = 0;
    val = strtoull(s, &endp, base);
    if (errno) {
        r = -errno;
        goto out;
    }

    if (endp == s) {
        r = -EINVAL;
        goto out;
    }

    /* make sure we reject negative numbers: */
    while (isspace((unsigned char)*s)) {
        s++;
    }
    if (*s == '-') {
        val = 0;
        r = -ERANGE;
        goto out;
    }

out:
    *value = val;
    *endptr = endp;
    return r;
}

/**
 * parse_uint_full:
 *
 * @s: String to parse
 * @value: Destination for parsed integer value
 * @base: integer base, between 2 and 36 inclusive, or 0
 *
 * Parse unsigned integer from entire string
 *
 * Have the same behavior of parse_uint(), but with an additional check
 * for additional data after the parsed number. If extra characters are present
 * after the parsed number, the function will return -EINVAL, and *@v will
 * be set to 0.
 */
int parse_uint_full(const char *s, unsigned long long *value, int base)
{
    char *endp;
    int r;

    r = parse_uint(s, value, &endp, base);
    if (r < 0) {
        return r;
    }
    if (*endp) {
        *value = 0;
        return -EINVAL;
    }

    return 0;
}

int qemu_parse_fd(const char *param)
{
    long fd;
    char *endptr;

    errno = 0;
    fd = strtol(param, &endptr, 10);
    if (param == endptr /* no conversion performed */                    ||
        errno != 0      /* not representable as long; possibly others */ ||
        *endptr != '\0' /* final string not empty */                     ||
        fd < 0          /* invalid as file descriptor */                 ||
        fd > INT_MAX    /* not representable as int */) {
        return -1;
    }
    return fd;
}

/*
 * Implementation of  ULEB128 (http://en.wikipedia.org/wiki/LEB128)
 * Input is limited to 14-bit numbers
 */
int uleb128_encode_small(uint8_t *out, uint32_t n)
{
    g_assert(n <= 0x3fff);
    if (n < 0x80) {
        *out++ = n;
        return 1;
    } else {
        *out++ = (n & 0x7f) | 0x80;
        *out++ = n >> 7;
        return 2;
    }
}

int uleb128_decode_small(const uint8_t *in, uint32_t *n)
{
    if (!(*in & 0x80)) {
        *n = *in++;
        return 1;
    } else {
        *n = *in++ & 0x7f;
        /* we exceed 14 bit number */
        if (*in & 0x80) {
            return -1;
        }
        *n |= *in++ << 7;
        return 2;
    }
}

/*
 * helper to parse debug environment variables
 */
int parse_debug_env(const char *name, int max, int initial)
{
    char *debug_env = getenv(name);
    char *inv = NULL;
    long debug;

    if (!debug_env) {
        return initial;
    }
    errno = 0;
    debug = strtol(debug_env, &inv, 10);
    if (inv == debug_env) {
        return initial;
    }
    if (debug < 0 || debug > max || errno != 0) {
        fprintf(stderr, "warning: %s not in [0, %d]", name, max);
        return initial;
    }
    return debug;
}

/*
 * Helper to print ethernet mac address
 */
const char *qemu_ether_ntoa(const MACAddr *mac)
{
    static char ret[18];

    snprintf(ret, sizeof(ret), "%02x:%02x:%02x:%02x:%02x:%02x",
             mac->a[0], mac->a[1], mac->a[2], mac->a[3], mac->a[4], mac->a[5]);

    return ret;
}
