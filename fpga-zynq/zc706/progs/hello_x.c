#include <stdio.h>
#include <stdlib.h>
#include <machine/syscall.h>
#include <string.h>
#include <stdint.h>

void* alloc_align(int n, int id)
{
  return syscall_errno(223, n, id, 0, 0, 0, 0);
}

int rcc(uintptr_t src, uintptr_t dest, int n)
{
  return syscall_errno(225, src, dest, n, 0, 0, 0);
}

int rci(uintptr_t src, int n)
{
  return syscall_errno(227, src, n, 0, 0, 0, 0);
}

static inline uint64_t read_cycles()
{
  uint64_t __tmp;
  asm volatile ("csrr %0, %1" : "=r"(__tmp) : "n"(0xc00));
  return __tmp;
}

static inline uint64_t read_insts()
{
  uint64_t __tmp;
  asm volatile ("csrr %0, %1" : "=r"(__tmp) : "n"(0xc02));
  return __tmp;
}


int main()
{

  int i = 0;
  //for(i;i < 200;i++)
  printf("Hello\n");

  int size = 64*1024;
  uint64_t begin,cputime;


  int *a = alloc_align(size, 0);
  int *b = alloc_align(size, 0);

  printf("%p, %p - 0x%lx, 0x%lx\n", a, b, (uintptr_t) a, (uintptr_t) b);

  uint64_t total_cpyalign = 0;

  for(int i = 0 ; i < (size)/4 ; i++)
  {
    b[i] = 0xffffffff;
    a[i] = 0xffffffff;
  }

  uint64_t total_rci = 0;
  uint64_t total_rcc = 0;

  for(int i = 0 ; i < 1 ; i++)
  {

    begin = read_cycles();
    rci((uintptr_t)a, (size));
    cputime = read_cycles() - begin;
    total_rci += cputime;
    printf("RCI:%ld\n",cputime);

/*
    begin = read_cycles();
    rcc((uintptr_t)a, (uintptr_t)b, (size));
    cputime = read_cycles() - begin;
    total_rcc += cputime;
    printf("RCC:%ld\n",cputime);
*/
  }

  printf("RCI:%ld RCC:%ld\n",total_rci/100,total_rcc/100);

  int diff = 0;
  for (int i = 0 ; i < size/4 ; i++)
  {
    if (a[i])
      diff++;
  }
  printf("%d\n",diff);
  

  /*
  rci((uintptr_t) a_rowsize_aligned, (size-8192));
  rcc((uintptr_t) a_rowsize_aligned, (uintptr_t) b_rowsize_aligned, (size-8192));

  int problema = 0;
  for(int i = 0 ; i < (size-8192)/4 ; i++)
  {
    if(a_rowsize_aligned[i]){
      printf("%d, 0x%x\n",i, b_rowsize_aligned[i]);
      problema = 1;
      break;
    }
  }
  if (problema)
    printf("A has problems\n");

  int problem = 0;
  for(int i = 0 ; i < (size-8192)/4 ; i++)
  {
    if(b_rowsize_aligned[i]){
      printf("%d, 0x%x\n",i, b_rowsize_aligned[i]);
      problem = 1;
      break;
    }
  }
  if (problem)
    printf("There is a problem\n");
  */
}
