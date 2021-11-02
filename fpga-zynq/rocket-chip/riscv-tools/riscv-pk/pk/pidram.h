#ifndef PIDRAM_HH
#define PIDRAM_HH

#include "imolib.h"
#include "encoding.h"
#include "syscall.h"
#include "mmap.h"
#include <errno.h>
#include <stdint.h>

//#define DISABLE_FLUSH
//#define DEBUG_PK

#define BANK_SIZE 8
#define SUBARRAYS_PER_BANK 38 // Total # of subarrays indexed
#define SAMT_ROWS_PER_ENTRY 416 // The amount of rows indexed per subarray
#define BANK_ADDRESS_OFFSET 14 // TODO: double check
#define BANK_ADDRESS_MASK 7 // TODO: double check
#define MAX_ALLOC_ID (16*1024-1)
#define SODIMM_START 0xc0000000u  // Where the sodimm addresses start in memory
#define ZYNQ_OFFSET  0x10000000u  // the system already increases our addresses by this amount

static int dummy_run = 0;
static char found_subarray[1024*1024*1024/ROW_BYTES];

static size_t DRAM_BASE_PPN = (SODIMM_START - ZYNQ_OFFSET) >> 12;

// virtual address range we use
uintptr_t rc_area_min;
uintptr_t rc_area_curr;

// Hold reverse mappings to quickly get which subarray
// a physical page is mapped to
static int PST[BANK_SIZE][SODIMM_SIZE/ROW_BYTES/BANK_SIZE];

// Reverse mapping from allocation id to subarray indices.

static unsigned short AIST[BANK_SIZE][SUBARRAYS_PER_BANK];

typedef struct SAMT_ADDRESS_PAIR{
  uintptr_t a1;
  uintptr_t a2;
} SAMTAP;

typedef struct SAMT_ENTRY{
  SAMTAP pairs[SAMT_ROWS_PER_ENTRY];
  unsigned char used[SAMT_ROWS_PER_ENTRY];
  unsigned short free;
  uintptr_t all_zero_paddr;
  unsigned short alloc_id;
} SAMTE;

static SAMTE SAMT[BANK_SIZE][SUBARRAYS_PER_BANK]; // Subarray <-> Physical Address Table

/**
 * Initialize the subarray <-> physical address mapping table
 */
void samt_initialize_from_header();

/**
 * Initialize the subarray <-> physical address mapping table
 */
void samt_initialize();

/**
 * Copy data from one array to the other via IMOC
 * @param src starting virtual address of the source array
 * @param dest starting virtual address of the destination array
 * @param n bytes to copy
 * @return -1 if could not copy, 0 otherwise
 */
int do_rcc(uintptr_t src, uintptr_t tgt, size_t n);

/**
 * Initialize an array via IMOC
 * @param src starting virtual address of the array
 * @param n bytes to initialize
 * @return -1 if could not initialize, 0 otherwise
 */
int do_rci(uintptr_t src, size_t n);

/**
 * Read a random number from the RN buffer
 * @return the 16-bit random number
 */
uint16_t do_read_rand();

/**
 * Align an array such that it can be operated on via RC
 * @param n bytes to align
 * @param id 
 * @return address to the start of the allocated contiguous
 * virtual address space
 */
uintptr_t do_alloc_align(size_t n, int id);

/**
 * Align an array such that it can be initialized using RCI
 * @param src starting virtual address of the array
 * @param n bytes to align
 * @return -1 if could not align, 0 otherwise
 */
int do_initalign(uintptr_t src, size_t n);

/**
 * Align two arrays such that they can be row-copied.
 * @param src starting virtual address of the source array
 * @param dest starting virtual address of the destination array
 * @param n bytes to align
 * @return -1 if could not align, 0 otherwise
 */
int do_cpyalign(uintptr_t src, uintptr_t dest, size_t n);

/**
 * Find the SAMT entry corresponding to a given virtual address
 * @param addr virtual address pointing to a physical row
 * @return SAMT entry's index
 */ 
int find_samt_entry(uintptr_t addr);
#endif