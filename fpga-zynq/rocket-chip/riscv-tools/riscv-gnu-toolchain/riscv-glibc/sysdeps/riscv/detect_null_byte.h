#ifndef _RISCV_DETECT_NULL_BYTE_H
#define _RISCV_DETECT_NULL_BYTE_H	1

static __inline__ unsigned long detect_null_byte (unsigned long w)
{
  unsigned long mask = 0x7f7f7f7f;
  if (sizeof (long) == 8)
    mask = ((mask << 16) << 16) | mask;
  return ~(((w & mask) + mask) | w | mask);
}

#endif /* detect_null_byte.h */
