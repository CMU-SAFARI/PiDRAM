/* { dg-do run } */
/* { dg-require-effective-target nonlocal_goto } */

extern void abort (void);
extern void exit (int);

#ifdef STACK_SIZE
#define DEPTH ((STACK_SIZE) / 512 + 1)
#else
#define DEPTH 1000
#endif

#if ! defined (NO_LABEL_VALUES) && !defined (NO_TRAMPOLINES)
int
x(int a)
{
  __label__ xlab;
  void y(int a)
    {
      if (a==0)
	goto xlab;
      y (a-1);
    }
  y (a);
 xlab:;
  return a;
}
#endif

int
main ()
{
#if ! defined (NO_LABEL_VALUES) && !defined (NO_TRAMPOLINES)
  if (x (DEPTH) != DEPTH)
    abort ();
#endif
  exit (0);
}
