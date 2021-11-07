#include <stdint.h>
#include <imolib.h>

#define SODIMM_START 0xc0000000u
#define ZYNQ_OFFSET 0x10000000u

uint64_t cycles_g = 0;
uint64_t insts_g = 0;

uint64_t cycles;
uint64_t insts;

static inline void begin_counting()
{
  asm volatile ("csrr %0, %1" : "=r"(insts) : "n"(0xc02));
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

    printf("Copy Size:%ldKiB Cycles:%ld Insts:%ld\n", size/1024, cycles_g/10000, insts_g/10000);

  } 
}

void cpu_copy()
{
  for (int size = 8192, id=0 ; size <= 8*1024*1024 ; size *= 2, id++)
  {
    uint64_t *a = 0xb0000000;
    uint64_t *b = 0xd0004200;

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

    printf("Copy Size:%ldKiB Cycles:%ld Insts:%ld\n", size/1024, cycles_g/100, insts_g/100);
  }
}

int main()
{
	printf("Test CPU copy performance\n");
	cpu_copy();
	printf("Test RowClone copy performance\n");
	test_dram_copy();
}
