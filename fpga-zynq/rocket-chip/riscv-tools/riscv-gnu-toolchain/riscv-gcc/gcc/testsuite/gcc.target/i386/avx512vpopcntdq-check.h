#include <stdlib.h>
#include "cpuid.h"
#include "m512-check.h"
#include "avx512f-os-support.h"

static void avx512vpopcntdq_test (void);

static void __attribute__ ((noinline)) do_test (void)
{
  avx512vpopcntdq_test ();
}

int
main ()
{
  unsigned int eax, ebx, ecx, edx;

  if (!__get_cpuid (1, &eax, &ebx, &ecx, &edx))
    return 0;

  /* Run AVX512_VPOPCNTDQ test only if host has the support.  */
  if ((ecx & bit_OSXSAVE) == (bit_OSXSAVE))
    {
      if (__get_cpuid_max (0, NULL) < 7)
	return 0;

      __cpuid_count (7, 0, eax, ebx, ecx, edx);

      if ((avx512f_os_support ()) && ((ecx & bit_AVX512VPOPCNTDQ) == bit_AVX512VPOPCNTDQ))
	{
	  do_test ();
#ifdef DEBUG
	  printf ("PASSED\n");
#endif
	  return 0;
	}
#ifdef DEBUG
      printf ("SKIPPED\n");
#endif
    }
#ifdef DEBUG
  else
    printf ("SKIPPED\n");
#endif

  return 0;
}
