/* { dg-do compile { target { powerpc*-*-* } } } */
/* { dg-skip-if "" { powerpc*-*-darwin* } { "*" } { "" } } */
/* { dg-skip-if "do not override -mcpu" { powerpc*-*-* } { "-mcpu=*" } { "-mcpu=power6" } } */
/* { dg-options "-O2 -mcpu=power6 -msched-groups" } */
/* { dg-final { scan-assembler "ori 1,1,0" } } */

/* Test generation of group ending nop in load hit store situation.  */
typedef union {
  double val;
  struct {
    unsigned int w1;
    unsigned int w2;
  };
} words;

unsigned int f (double d)
{
  words u;
  u.val = d;
  return u.w2;
}

