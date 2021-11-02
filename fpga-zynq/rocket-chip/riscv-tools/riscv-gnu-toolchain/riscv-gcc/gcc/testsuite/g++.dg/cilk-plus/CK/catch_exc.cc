/* { dg-options "-fcilkplus" } */
/* { dg-do run } */
/* { dg-require-effective-target cilkplus_runtime } */

#include <assert.h>
#include <unistd.h>
#if HAVE_IO
#include <cstdio>
#include <cilk/cilk_api.h>
#endif
#include <cstdlib>

#ifdef __cplusplus
extern "C" {
#endif

extern int __cilkrts_set_param (const char *, const char *);

#ifdef __cplusplus
}
#endif


void func(int volatile* steal_me) 
{
  while (! (*steal_me)) 
    {
      usleep(2000);
    }
#if HAVE_IO
  printf("Foo executing on %d\n", __cilkrts_get_worker_number());
#endif
  throw 5;
}

void my_test() 
{
  volatile int steal_me = 0;

  try 
    {
      _Cilk_spawn func(&steal_me);
#if HAVE_IO
      printf("Continuation executing on %d\n",
	     __cilkrts_get_worker_number());
#endif
      steal_me = 1;
      _Cilk_sync;
      goto bad;
    }

  catch (int x) 
    {
#if HAVE_IO
      printf("We caught x = %d\n", x);
#endif
      assert(x == 5);
    }
  if (0) 
    {
    bad:
#if HAVE_IO
      printf("We should not be here!\n");
#endif
      __builtin_abort ();
    }
}


int main() 
{
  /* Ensure more than one worker.  */
  if (__cilkrts_set_param("nworkers", "2") != 0)
    __builtin_abort();

  my_test();
#if HAVE_IO
  printf("PASSED\n");
#endif
  return 0;
}
