#include <stdint.h>
#include "imolib.h"

#define SODIMM_START 0xc0000000u
#define ZYNQ_OFFSET  0x10000000u

#define DCMISS 0xc03

uint64_t cycles_g = 0;
uint64_t insts_g = 0;
uint64_t dc_misses_g = 0;

uint64_t cycles;
uint64_t dc_misses;
uint64_t insts;

#define write_csr(reg, val) ({ \
  asm volatile ("csrw " #reg ", %0" :: "rK"(val)); })

static inline void begin_counting()
{
  asm volatile ("csrr %0, %1" : "=r"(insts) : "n"(0xc02));
  //asm volatile ("csrr %0, %1" : "=r"(dc_misses) : "n"(DCMISS));
  asm volatile ("csrr %0, %1" : "=r"(cycles) : "n"(0xc00));
}

static inline void begin_rdcycle()
{
  asm volatile ("csrr %0, %1" : "=r"(cycles) : "n"(0xc00));
}

static inline void end_rdcycle()
{
  uint64_t tmp;
  asm volatile ("csrr %0, %1" : "=r"(tmp) : "n"(0xc00));
  cycles = tmp - cycles;
}


static void accumulate_rdcycle()
{
  cycles_g += cycles;
}

static void accumulate_counters()
{
  cycles_g += cycles;
  insts_g += insts;
  //dc_misses_g += dc_misses;
}

static inline void end_counting()
{
  uint64_t tmp;
  asm volatile ("csrr %0, %1" : "=r"(tmp) : "n"(0xc00));
  cycles = tmp - cycles;
  
  asm volatile ("csrr %0, %1" : "=r"(tmp) : "n"(0xc02));
  insts = tmp - insts;
}

void init_kernel(uint64_t* a, int size)
{
  uint64_t val = 0;
  int j = 0;
  for (j = 0 ; j < size/8 ; j++)
  {
    uint64_t* addr = (a + j);
    asm volatile("sd %0, %1(%2)" : : "r" (val), "i" (0), "r" (addr));
  }
}

void copy_kernel(uint64_t* a, uint64_t* b, int size)
{
  int j = 0;
  for (j = 0 ; j < size/8 ; j++)
  {
    uint64_t* aaddr = (a + j);
    uint64_t* baddr = (b + j);
    uint64_t val;
    asm volatile("ld %0, %1(%2)" : "=r" (val) : "i" (0), "r" (aaddr));
    asm volatile("sd %0, %1(%2)" : : "r" (val), "i" (0), "r" (baddr));
  }
}

uint64_t a_arm[1024*1024*2];
uint64_t b_arm[1024*1024*2];

void test_dram_copy()
{
  set_timings(5,5,3);
  for (int size = 8192, id=0 ; size <= 32*1024*1024 ; size *= 2, id++)
  {
    uint64_t* a = 0xb0000000;
    uint64_t* b = 0xb0010000;

    cycles_g = 0;
    insts_g = 0;

    for(int i = 0 ; i < 10000 ; i++)
    {
      for (int i = 0 ; i < size/8192 ; i++)
      {
        begin_counting();
        copy_row((char*) a, (char*) b);
        end_counting();
        accumulate_counters();
      }
    }

    //printf("%ld %ld %ld %ld %ld %ld %ld\n", size, cycles_g/100, insts_g/100, dc_misses_g/100, dc_hits_g/100, tlb_misses_g/100, tlb_hits_g/100);
    printf("%ld %ld %ld\n", size, cycles_g/10000, insts_g/10000);

  } 
}

void cpu_copy(int arm)
{
  for (int size = 8192, id=0 ; size <= 8*1024*1024 ; size *= 2, id++)
  {
    uint64_t *a;
    uint64_t *b;
    if (arm)
    {
      a = a_arm;
      b = &(b_arm[16384+512]);
    }
    else
    {
      a = 0xb0000000;
      b = 0xd0004200;
    }

    cycles_g = 0;
    insts_g = 0;

    for(int i = 0 ; i < 100 ; i++)
    {
      for (int j = 0 ; j < size ; j += 1024)
      {
        flush_row((char*)&(a[j]));
        flush_row((char*)&(b[j]));
      }

      int j = 0;
      while (j < 10000) j++;

      begin_counting();
      copy_kernel((uint64_t*) a, (uint64_t*) b, size);
      end_counting();
      accumulate_counters();
    }
    //printf("%ld %ld %ld %ld %ld %ld %ld\n", size, cycles_g/100, insts_g/100, dc_misses_g/100, dc_hits_g/100, tlb_misses_g/100, tlb_hits_g/100);
    printf("%ld %ld %ld %ld\n", size, cycles_g/100, insts_g/100, dc_misses_g/100);
  }
}

void test_flush()
{
  for (int size = 8192, id=0 ; size <= 8192 ; size *= 2, id++)
  {
 
    uint64_t* a = 0xb0000000;

    cycles_g = 0;
    insts_g = 0;

    uint64_t *cached = 0xd0003200;

    *cached = 127;

    for(int i = 0 ; i < 1000 ; i++)
    {
      uint64_t val = i;
      
      a = 0xb0000000;
      
      /*
      for (int j = 0 ; j < 512 ; j++)
      {
        asm volatile("sd %0, %1(%2)" : "=r" (val) : "i" (0), "r" (a));
        a++;
      }
      */
      
      
      a = 0xb0000000;
      asm volatile("fence");
      asm volatile("fence");
      asm volatile("fence");
      for (int j = 0 ; j < 64 ; j++)
      {
        //asm volatile("ld %0, %1(%2)" : "=r" (val) : "i" (0), "r" (a));
        //asm volatile("fence");
        //asm volatile("fence");
        asm volatile("flush %[value]\n\t" :: [value] "r" (a) );
        asm volatile("fence");
        asm volatile("fence");
        asm volatile("fence");
        asm volatile("fence");
        asm volatile("fence");
        begin_rdcycle();
        asm volatile("flush %[value]\n\t" :: [value] "r" (a) );
        asm volatile("ld %0, %1(%2)" : "=r" (val) : "i" (0), "r" (cached));
        asm volatile("ld %0, %1(%2)" : "=r" (val) : "i" (0), "r" (cached));
        //asm volatile("fence");
        end_rdcycle();
        //printf("%d %ld\n", j, cycles);
        accumulate_rdcycle();
        a += 8;
      }
      //asm volatile("fence");
      //end_counting();
      //accumulate_counters();

    }
    //printf("%ld %ld %ld %ld %ld %ld %ld\n", size, cycles_g/100, insts_g/100, dc_misses_g/100, dc_hits_g/100, tlb_misses_g/100, tlb_hits_g/100);
    printf("%ld %ld %ld %ld\n", size, cycles_g/1000/64, insts_g/1000/64, dc_misses_g/1000/64);
  }
}

int main()
{
  int arm = 0;
  write_csr(0x323, (uint32_t) 0xffff);
  cpu_copy(arm);
  test_dram_copy();

  //test_flush();
}