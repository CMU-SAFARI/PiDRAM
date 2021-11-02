#include <machine/syscall.h>

//------------------------------------------------------------------------
// stat
//------------------------------------------------------------------------
// Status of a file (by name).

int
_stat(const char *file, struct stat *st)
{
  struct kernel_stat kst;
  int rv = syscall_errno (SYS_stat, file, &kst, 0, 0, 0, 0);
  _conv_stat (st, &kst);
  return rv;
}

