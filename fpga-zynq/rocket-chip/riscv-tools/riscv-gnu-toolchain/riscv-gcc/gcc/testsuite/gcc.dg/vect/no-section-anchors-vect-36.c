/* { dg-require-effective-target vect_int } */
/* { dg-add-options bind_pic_locally } */

#include <stdarg.h>
#include "tree-vect.h"

#define N 32
 
struct {
  char ca[N];
  char cb[N];
} s;

__attribute__ ((noinline))
int main1 ()
{  
  int i;

  for (i = 0; i < N; i++)
    {
      s.cb[i] = 3*i;
      __asm__ volatile ("");
    }

  for (i = 0; i < N; i++)
    {
      s.ca[i] = s.cb[i];
    }

  /* check results:  */
  for (i = 0; i < N; i++)
    {
      if (s.ca[i] != s.cb[i])
        abort ();
    }

  return 0;
}

int main (void)
{ 
  check_vect ();
  
  return main1 ();
} 

/* { dg-final { scan-tree-dump-times "vectorized 1 loops" 1 "vect" } } */
/* { dg-final { scan-tree-dump-times "Vectorizing an unaligned access" 0 "vect" } } */
/* { dg-final { scan-tree-dump-times "Alignment of access forced using peeling" 0 "vect" } } */
