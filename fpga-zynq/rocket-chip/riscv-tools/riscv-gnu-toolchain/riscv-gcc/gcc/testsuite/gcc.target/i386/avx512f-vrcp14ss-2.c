/* { dg-do run } */
/* { dg-options "-mavx512f -O2" } */
/* { dg-require-effective-target avx512f } */

#include "avx512f-check.h"

static void
compute_vrcp14ss (float *s1, float *s2, float *r)
{
  r[0] = 1.0 / s2[0];
  r[1] = s1[1];
  r[2] = s1[2];
  r[3] = s1[3];
}

static void
avx512f_test (void)
{
  union128 s1, s2, res1;
  float res_ref[4];

  s1.x = _mm_set_ps (-24.043, 68.346, -43.35, 546.46);
  s2.x = _mm_set_ps (222.222, 333.333, 444.444, -2.0);

  res1.x = _mm_rcp14_ss (s1.x, s2.x);

  compute_vrcp14ss (s1.a, s2.a, res_ref);

  if (checkVf (res1.a, res_ref, 4))
    abort ();
}
