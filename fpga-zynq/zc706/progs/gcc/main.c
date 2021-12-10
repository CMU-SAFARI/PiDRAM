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


//unsigned long long* old_process;
//unsigned long long** old_process_rowclone;

void gcc_emulate_cpu()
{
    int a = 0;

    // Run ~15K instructions first
    // 937 because without any optimizations
    // riscv-gcc compiles this loop into 16 instructions per iter.
    for (int i = 0 ; i < 937 ; i++)
    {
      // mul, add, branch
      a += i*3;
    }

    // zero-allocate four pages
    unsigned long long* emu_calloc = (unsigned long long*) malloc(4096*2);
}

void gcc_emulate_rowclone(int id)
{

    int a;
    unsigned long long* new_process = (unsigned long long*) alloc_align(4096*2, id);

    // Run ~15K instructions first
    // 937 because without any optimizations
    // riscv-gcc compiles this loop into 16 instructions per iter.
    for (int i = 0 ; i < 937 ; i++)
    {
      //mul, add, branch
      a += i*3;
    }

    // zero-allocate four pages
    rci((uintptr_t) new_process, 4096*2);
}

int main(int argc, char *argv[])
{
    srand(1337);

    uint64_t begin = read_cycles();
    uint64_t insts_begin = read_insts();

    for (int i = 0 ; i < 1024 ; i++)
        gcc_emulate_cpu();

    uint64_t cpu_time = read_cycles() - begin;
    uint64_t cpu_insts = read_insts() - insts_begin;

    printf("CPU, Page Size, Number of Pages, Number of Random Accesses, Execution Time, Instructions\n");
    printf("1, %ld, %ld\n", cpu_time, cpu_insts);

    begin = read_cycles();
    insts_begin = read_insts();

    for (int i = 0 ; i < 1024 ; i++)
        gcc_emulate_rowclone(i/64);

    uint64_t rcc_time = read_cycles() - begin;
    uint64_t rcc_insts = read_insts() - insts_begin;

    printf("0, %ld, %ld\n", rcc_time, rcc_insts);
}