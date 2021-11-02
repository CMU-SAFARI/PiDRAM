#include <machine/syscall.h>

//------------------------------------------------------------------------
// openat
//------------------------------------------------------------------------
// Open file relative to given directory
int _openat(int dirfd, const char *name, int flags, int mode)
{
  return syscall_errno (SYS_openat, dirfd, name, flags, mode, 0, 0);
}

