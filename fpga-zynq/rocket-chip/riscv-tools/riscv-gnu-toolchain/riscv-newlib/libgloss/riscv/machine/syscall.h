#ifndef _MACHINE_SYSCALL_H
#define _MACHINE_SYSCALL_H

#include <sys/stat.h>
#include <sys/times.h>
#include <sys/time.h>
#include <sys/timeb.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <utime.h>

#define SYS_exit 93
#define SYS_exit_group 94
#define SYS_getpid 172
#define SYS_kill 129
#define SYS_read 63
#define SYS_write 64
#define SYS_open 1024
#define SYS_openat 56
#define SYS_close 57
#define SYS_lseek 62
#define SYS_brk 214
#define SYS_link 1025
#define SYS_unlink 1026
#define SYS_mkdir 1030
#define SYS_chdir 49
#define SYS_getcwd 17
#define SYS_stat 1038
#define SYS_fstat 80
#define SYS_lstat 1039
#define SYS_fstatat 79
#define SYS_access 1033
#define SYS_faccessat 48
#define SYS_pread 67
#define SYS_pwrite 68
#define SYS_uname 160
#define SYS_getuid 174
#define SYS_geteuid 175
#define SYS_getgid 176
#define SYS_getegid 177
#define SYS_mmap 222
#define SYS_munmap 215
#define SYS_mremap 216
#define SYS_time 1062
#define SYS_getmainvars 2011
#define SYS_rt_sigaction 134
#define SYS_writev 66
#define SYS_gettimeofday 169
#define SYS_times 153
#define SYS_fcntl 25
#define SYS_getdents 61
#define SYS_dup 23

static inline long
__syscall_error(long a0)
{
  errno = -a0;
  return -1;
}

static inline long
__internal_syscall(long n, long _a0, long _a1, long _a2, long _a3, long _a4, long _a5)
{
  register long a0 asm("a0") = _a0;
  register long a1 asm("a1") = _a1;
  register long a2 asm("a2") = _a2;
  register long a3 asm("a3") = _a3;
  register long a4 asm("a4") = _a4;
  register long a5 asm("a5") = _a5;

#ifdef __riscv_32e
  register long syscall_id asm("t0") = n;
#else
  register long syscall_id asm("a7") = n;
#endif

  asm volatile ("scall"
		: "+r"(a0) : "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5), "r"(syscall_id));

  if (a0 < 0)
    return __syscall_error (a0);
  else
    return a0;
}

struct  kernel_stat
{
  unsigned long long st_dev;
  unsigned long long st_ino;
  unsigned int st_mode;
  unsigned int st_nlink;
  unsigned int st_uid;
  unsigned int st_gid;
  unsigned long long st_rdev;
  unsigned long long __pad1;
  long long st_size;
  int st_blksize;
  int __pad2;
  long long st_blocks;
  struct timespec st_atim;
  struct timespec st_mtim;
  struct timespec st_ctim;
  int __glibc_reserved[2];
};

#define syscall_errno(n, a, b, c, d, e, f) \
        __internal_syscall(n, (long)(a), (long)(b), (long)(c), (long)(d), (long)(e), (long)(f))


void _conv_stat (struct stat *st, struct kernel_stat *kst);

#endif
