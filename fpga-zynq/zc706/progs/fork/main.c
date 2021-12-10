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


unsigned long long* old_process;
unsigned long long** old_process_rowclone;

void fork_emulate_cpu(int page_size, int n_pages, int n_random_accesses)
{
    unsigned long long* new_process = (unsigned long long*) malloc(page_size*n_pages);

    // copy n_pages to the newly allocated "process"

    for (int i = 0 ; i < n_pages*page_size/8 ; i++)
    {
        unsigned long long val;
        asm volatile("ld %0, %1(%2)" : "=r" (val) : "i" (0), "r" (&old_process[i]));
        asm volatile("sd %0, %1(%2)" : : "r" (val), "i" (0), "r" (&new_process[i]));
    }
    
    for (int i = 0 ; i < n_random_accesses ; i++)
    {
        unsigned int rand_idx = rand();
        rand_idx = ((rand_idx & 0xffff) << 16) | (rand() & 0xffff);
        rand_idx &= ((n_pages*page_size) >> 3) - 1;
        // touch one cache block
        asm volatile("sd %0, %1(%2)" : : "r" (rand_idx), "i" (0), "r" (&old_process[rand_idx]));
    }
  
    old_process = new_process;
}

void fork_emulate_rowclone(int id, int page_size, int n_pages, int n_random_accesses)
{
    unsigned long long* new_process = (unsigned long long*) alloc_align(page_size*n_pages, id);

    // copy n_pages to the newly allocated "process"
    rcc((uintptr_t) old_process_rowclone[id], (uintptr_t) new_process, page_size * n_pages);
   
    for (int i = 0 ; i < n_random_accesses ; i++)
    {
        unsigned int rand_idx = rand();
        rand_idx = ((rand_idx & 0xffff) << 16) | (rand() & 0xffff);
        rand_idx &= ((n_pages*page_size) >> 3) - 1;
        // touch one cache block
        asm volatile("sd %0, %1(%2)" : : "r" (rand_idx), "i" (0), "r" (&new_process[rand_idx]));
    }
    
}

int main(int argc, char *argv[])
{
    srand(1337);

    int page_size = atoi(argv[1]);
    int n_pages = atoi(argv[2]);
    int n_random_accesses = atoi(argv[3]);

    uint64_t begin = read_cycles();
    uint64_t insts_begin = read_insts();

    for (int i = 0 ; i < 32 ; i++)
        fork_emulate_cpu(page_size, n_pages, n_random_accesses);

    uint64_t cpu_time = read_cycles() - begin;
    uint64_t cpu_insts = read_insts() - insts_begin;

    printf("CPU, Page Size, Number of Pages, Number of Random Accesses, Execution Time, Instructions\n");
    printf("1, %d, %d, %d, %ld, %ld\n", page_size, n_pages, n_random_accesses, cpu_time, cpu_insts);

    free(old_process);

    old_process_rowclone = (unsigned long long**) malloc(sizeof(*old_process_rowclone) * 32);
    for (int i = 0 ; i < 32 ; i++)
        old_process_rowclone[i] = (unsigned long long*) alloc_align(page_size * n_pages, i);

    begin = read_cycles();
    insts_begin = read_insts();

    for (int i = 0 ; i < 32 ; i++)
        fork_emulate_rowclone(i, page_size, n_pages, n_random_accesses);

    uint64_t rcc_time = read_cycles() - begin;
    uint64_t rcc_insts = read_insts() - insts_begin;

    printf("0, %d, %d, %d, %ld, %ld\n", page_size, n_pages, n_random_accesses, rcc_time, rcc_insts);
}