#ifndef IMOLIB_H
#define IMOLIB_H

#include <stdint.h>

#define IMOC_INST_LOWER 0x4000008u
#define IMOC_INST_UPPER 0x4000000u
#define IMOC_DATA_OFS   0x4000018u
#define IMOC_LAST_REG   0x4000050u
#define ROW_BYTES       8192
#define NO_ROWS         (16*1024)

#define IMO_OP_OFS      112 - 64

// NOTE: Addressing here is quite decoupled from the
// rest of the system. Address 0 points to bank 0 row 0 
// cache block 0 column 0 in the DRAM device.
// The first 3 bits of the address is unused.
// Bits [12,3] of the address are used to index DRAM columns
// Bits [27,13] are used to address rows
// Bits [30,28] are used to address banks

/**
 * Sets the timing parameters used in IMOs.
 * @param rct1 T1 in copy_row operation, the amount of
 * cycles (10ns period clock) to wait before sending 
 * the first PRE in the command sequence.
 * @param rct2 T2 in copy_row operation, the amount of
 * cycles to wait before sending the second ACT in the 
 * command sequence.
 * @param trcd The tRCD used by activation failure sequences
 * and periodic RNG sequences.
 */
void set_timings(int rct1, int rct2, int trcd);

/**
 * Configure in-DRAM RNG engine.
 * @param period how frequently should the machine 
 * issue RNG requests, period in nanoseconds.
 * @param address the address of the RNG cache block.
 * @param bit1 the offset of the first RNG cell in the
 * 64-byte burst [0,511]
 * @param bit2 the offset of the second RNG cell in the
 * 64-byte burst [0,511]
 */
void rng_configure(int period, char* address, int bit1, int bit2);

/**
 * Induce activation failure on a DRAM cache-block
 * @param addr the address of the block to access
 * with reduced tRCD.
 */
void induce_activation_failure(char *addr);

void flush_row(char *source);
/**
 * Copy a DRAM row to another
 * @param source ideally the pointer to the start of a row
 * @param target ideally the pointer to the start of a row
 */
static inline void copy_row(char *source, char *target)
{
  volatile uint64_t *ptr    = (uint64_t*) IMOC_INST_UPPER;
  uint64_t imo_op           = 0x1;
  uint32_t source_row_addr  = (uint32_t) source;
  uint64_t target_row_addr  = (uint32_t) target;
  uint64_t inst_lower       = source_row_addr | 
                              (target_row_addr << 32);
  uint64_t inst_upper       = imo_op << (IMO_OP_OFS);

  *ptr = inst_upper;
  *(ptr+1) = inst_lower;
  *(ptr+2) = (uint64_t) 0x1;
  while(*(ptr+2) != 0x2);
}

void copy_row_sync(char *source, char *target);

/**
 * Read the number of available random short-words.
 * We store random bits in a 1KB large buffer 
 * in the memory controller.
 * @return the number of available random 
 * short-words in the buffer 
 */
int rng_buf_size();

/**
 * Read one random short-word from the RNG buffer
 * @return a random short-word
 */
int rng_buf_read();

#endif