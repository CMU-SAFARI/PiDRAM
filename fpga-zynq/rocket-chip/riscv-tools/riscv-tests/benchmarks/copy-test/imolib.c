#include <stdint.h>
#include "imolib.h"

void set_timings(int rct1, int rct2, int trcd)
{
  volatile uint64_t *ptr    = (uint64_t*) IMOC_INST_UPPER;
  uint64_t imo_op           = 0x10;  // Write to control register
  uint64_t cr_addr          = 0x0;   // 0th CR keeps timings
  uint32_t cr_data          = ((trcd & 0xf) << 8) | ((rct2 & 0xf) << 4) | 
                              (rct1 & 0xf);
  uint64_t inst_lower       = (cr_addr << 32) | cr_data;
  uint64_t inst_upper       = imo_op << (IMO_OP_OFS);

  *ptr = inst_upper;
  *(ptr+1) = inst_lower;
  *(ptr+2) = (uint64_t) 0x1;
  while(*(ptr+2) != 0x2);
}

void rng_configure(int period, char* address, int bit1, int bit2)
{
  volatile uint64_t *ptr    = (uint64_t*) IMOC_INST_UPPER;
  uint64_t imo_op           = 0x10;  // Write to control register
  uint64_t cr_addr          = 0x1;  // 0th CR keeps RNG period
  uint32_t cr_data          = period/10; // divide by fabric clock period
  uint64_t inst_lower       = (cr_addr << 32) | cr_data;
  uint64_t inst_upper       = imo_op << (IMO_OP_OFS);

  *ptr = inst_upper;
  *(ptr+1) = inst_lower;
  *(ptr+2) = (uint64_t) 0x1;
  while(*(ptr+2) != 0x2);

  cr_addr          = 0x2;  // 1st CR keeps RNG address
  cr_data          = (uint32_t) address;
  inst_lower       = (cr_addr << 32) | cr_data;

  *(ptr+1) = inst_lower;
  *(ptr+2) = (uint64_t) 0x1;
  while(*(ptr+2) != 0x2);

  cr_addr          = 0x3;  // 2nd CR keeps RNG bit indices
  cr_data          = (((uint32_t) bit2) << 16) | (uint16_t) bit1;
  inst_lower       = (cr_addr << 32) | cr_data;

  *(ptr+1) = inst_lower;
  *(ptr+2) = (uint64_t) 0x1;
  while(*(ptr+2) != 0x2);
}

void induce_activation_failure(char *addr)
{
  volatile uint64_t *ptr    = (uint64_t*) IMOC_INST_UPPER;
  uint64_t imo_op           = 0x2;
  uint64_t inst_lower       = (uint32_t) addr; 
  uint64_t inst_upper       = imo_op << (IMO_OP_OFS);

  *ptr = inst_upper;
  *(ptr+1) = inst_lower;
  *(ptr+2) = (uint64_t) 0x1;
  while(*(ptr+2) != 0x2);
}

void flush_row(char *source)
{
  //printf("%p\n", source);
  int i = 0;
  asm volatile("fence");
  for (; i < ROW_BYTES/64 ; i++)
  {
    char* ptr = source + i*64; 
    asm volatile("flush %[value]\n\t" :: [value] "r" (ptr) );
    asm volatile("fence");
  }
}
/*
inline void copy_row(char *source, char *target)
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
*/
void copy_row_sync(char *source, char *target)
{
  volatile uint64_t *ptr    = (uint64_t*) IMOC_INST_UPPER;
  volatile uint64_t *data   = (uint64_t*) IMOC_LAST_REG;
  uint64_t imo_op           = 0x1;
  uint32_t source_row_addr  = (uint32_t) source;
  uint64_t target_row_addr  = (uint32_t) target;
  uint64_t inst_lower       = source_row_addr | 
                              (target_row_addr << 32);
  uint64_t inst_upper       = imo_op << (IMO_OP_OFS);

  *ptr = inst_upper;
  *(ptr+1) = inst_lower;
  *(ptr+2) = (uint64_t) 0x1;
  while(*(data) == 0);
  *data = (uint64_t) 0;
}

int rng_buf_size()
{
  volatile uint64_t *ptr    = (uint64_t*) IMOC_INST_UPPER;
  uint64_t imo_op           = 0x8;
  uint64_t inst_upper       = imo_op << (IMO_OP_OFS);

  *(ptr) = inst_upper;
  *(ptr+2) = (uint64_t) 0x1;
  while(*(ptr+2) != 0x2);

  volatile uint64_t *data    = (uint64_t*) IMOC_DATA_OFS;
  return (*data) & 0x1ff;
}

int rng_buf_read()
{
  volatile uint64_t *ptr    = (uint64_t*) IMOC_INST_UPPER;
  uint64_t imo_op           = 0x4;
  uint64_t inst_upper       = imo_op << (IMO_OP_OFS);

  *(ptr) = inst_upper;
  *(ptr+2) = (uint64_t) 0x1;
  while(*(ptr+2) != 0x2);

  volatile uint64_t *data    = (uint64_t*) IMOC_DATA_OFS;
  return (*data) & 0xffff;
}