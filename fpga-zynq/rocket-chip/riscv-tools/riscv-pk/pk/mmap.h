#ifndef _MMAP_H
#define _MMAP_H

#include "vm.h"
#include "syscall.h"
#include "encoding.h"
#include "file.h"
#include "mtrap.h"
#include "imolib.h"
#include <stddef.h>

//#define DEBUG_PK

#define SODIMM_SIZE (1024 * 1024 * 1024)

#define PROT_NONE 0
#define PROT_READ 1
#define PROT_WRITE 2
#define PROT_EXEC 4

#define MAP_PRIVATE 0x2
#define MAP_FIXED 0x10
#define MAP_ANONYMOUS 0x20
#define MAP_POPULATE 0x8000
#define MREMAP_FIXED 0x2

// Atb: can we add the subphy (* table that holds mappings
// from subarray ids to physical addresses) table here?
// #define SPT_SUBARRAYS 64 // Total # of subarrays indexed
// #define SPT_RPS 256 // The amount of rows indexed per subarray

// static uintptr_t spt[SPT_SUBARRAYS][SPT_RPS];
// If the corresponding spt address is being used
// static unsigned char spt_mask[SPT_SUBARRAYS][SPT_RPS];
// static unsigned short spt_free_entries[SPT_SUBARRAYS];
// static char found_subarray[1024*1024*1024/ROW_BYTES];


static uintptr_t RC_ROWSIZE = 8192;
#define SODIMM_START 0xc0000000u  // Where the sodimm addresses start in memory
#define ZYNQ_OFFSET  0x10000000u  // the system already increases our addresses by this amount

//static int dummy_run = 0;
static size_t stack_bottom;

// Add these to expose them to pidram.c

pte_t* __walk(uintptr_t addr);
uintptr_t ppn(uintptr_t addr);
size_t pte_ppn(pte_t pte);


extern int demand_paging;
uintptr_t pk_vm_init();
int handle_page_fault(uintptr_t vaddr, int prot);
void populate_mapping(const void* start, size_t size, int prot);
void __map_kernel_range(uintptr_t va, uintptr_t pa, size_t len, int prot);
int __valid_user_range(uintptr_t vaddr, size_t len);
uintptr_t __do_mmap(uintptr_t addr, size_t length, int prot, int flags, file_t* file, off_t offset);
void __pt_map(uintptr_t va, uintptr_t pa);
uintptr_t do_mmap(uintptr_t addr, size_t length, int prot, int flags, int fd, off_t offset);
void do_translate(uintptr_t addr);
int do_munmap(uintptr_t addr, size_t length);
uintptr_t do_mremap(uintptr_t addr, size_t old_size, size_t new_size, int flags);
uintptr_t do_mprotect(uintptr_t addr, size_t length, int prot);
uintptr_t do_brk(uintptr_t addr);

#define va2pa(va) ({ uintptr_t __va = (uintptr_t)(va); \
  extern uintptr_t first_free_paddr; \
  __va >= DRAM_BASE ? __va : __va + first_free_paddr; })

#endif
