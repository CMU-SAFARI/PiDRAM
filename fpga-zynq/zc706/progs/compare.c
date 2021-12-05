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



void init_kernel(uint64_t* cputime, uint64_t* a, int size)
{
  uint64_t val = 0;
  uint64_t begin = read_cycles();
  int j = 0;
  for (j = 0 ; j < size/8 ; j++)
  {
    uint64_t* addr = (a + j);
    asm volatile("sd %0, %1(%2)" : : "r" (val), "i" (0), "r" (addr));
  }
  *cputime = read_cycles();
  *cputime = *cputime - begin;

}

void copy_kernel(uint64_t* cputime, uint64_t* a, uint64_t* b, int size)
{
  uint64_t begin = read_cycles();
  int j = 0;
  for (j = 0 ; j < size/8 ; j++)
  {
    uint64_t* aaddr = (a + j);
    uint64_t* baddr = (b + j);
    uint64_t val;
    asm volatile("sd %0, %1(%2)" : "=r" (val) : "i" (0), "r" (aaddr));
    asm volatile("sd %0, %1(%2)" : : "r" (val), "i" (0), "r" (baddr));
  }
  *cputime = read_cycles();
  *cputime = *cputime - begin;  
}

void compare_copy()
{
  for (int size = 8192, id=0 ; size <= 8*1024*1024 ; size *= 2, id++)
  {
    uint64_t begin,cputime;

    int *a = alloc_align(size, id);
    int *b = alloc_align(size, id);

    uint64_t total_rcc = 0;

    for(int i = 0 ; i < 100 ; i++)
    {
      begin = read_cycles();
      rcc((uintptr_t)a, (uintptr_t) b, (size));
      cputime = read_cycles() - begin;
      total_rcc += cputime;
    }

    uint64_t total_cpu = 0;
    uint64_t* b_dw = (uint64_t*) malloc(size);
    uint64_t* a_dw = (uint64_t*) malloc(size);
    for(int i = 0 ; i < 100 ; i++)
    {
      copy_kernel(&cputime, a_dw, b_dw, size);
      total_cpu += cputime;
    }

    free(b_dw);
    free(a_dw);
    printf("Size: %ld KiB RowClone-Copy Cycles: %ld CPU Copy Cycles: %ld\n", size/1024, total_rcc/100, total_cpu/100);
  } 
}

int main()
{
  compare_copy();
}
