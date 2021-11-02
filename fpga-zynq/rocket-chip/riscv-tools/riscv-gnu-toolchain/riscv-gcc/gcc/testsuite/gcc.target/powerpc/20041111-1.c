/* { dg-do compile { target powerpc*-*-* } } */
/* { dg-skip-if "do not override -mcpu" { powerpc*-*-* } { "-mcpu=*" } { "-mcpu=power4" } } */
/* { dg-options "-mcpu=power4 -O2" } */

extern unsigned long long set_mask[65];
extern  unsigned long long xyzzy(int) __attribute__((pure));

int valid (int x)
{
  return(xyzzy(x) & set_mask[x]);
}
