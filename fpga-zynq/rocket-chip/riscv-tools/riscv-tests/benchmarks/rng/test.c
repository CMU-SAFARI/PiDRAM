#include <stdint.h>
#include "imolib.h"

#define SODIMM_START 0xc0000000u
#define ZYNQ_OFFSET  0x10000000u

uint64_t dram_linear_address(uint64_t bank, uint64_t row)
{
  uint64_t addr;
  addr = row << 3; 
  addr |= bank;
  addr <<= 13;
  return addr;
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

static int seedi = 1337;

void spec_srand(int seed) {
  seedi = seed;
}

/* See "Random Number Generators: Good Ones Are Hard To Find", */
/*     Park & Miller, CACM 31#10 October 1988 pages 1192-1201. */
/***********************************************************/
/* THIS IMPLEMENTATION REQUIRES AT LEAST 32 BIT INTEGERS ! */
/***********************************************************/
double spec_rand(void)
#define _A_MULTIPLIER  16807L
#define _M_MODULUS     2147483647L /* (2**31)-1 */
#define _Q_QUOTIENT    127773L     /* 2147483647 / 16807 */
#define _R_REMAINDER   2836L       /* 2147483647 % 16807 */
{
  int lo;
  int hi;
  int test;

  hi = seedi / _Q_QUOTIENT;
  lo = seedi % _Q_QUOTIENT;
  test = _A_MULTIPLIER * lo - _R_REMAINDER * hi;
  if (test > 0) {
    seedi = test;
  } else {
    seedi = test + _M_MODULUS;
  }
  return ( (double) seedi / _M_MODULUS);
}

int drange_characterize()
{
  uint8_t count[512];

  set_timings(5, 5, 4);
  for (int row = 0 ; row < 16*1024 ; row++)
  {
    for (int cb = 0 ; cb < 128 ; cb ++)
    {
      uint64_t a = dram_linear_address(0, row);
      uint64_t a_m = a + (0xc0000000u - 0x10000000u);

      uint64_t* addr_ido = ((uint64_t*) a) + (cb*8);
      uint64_t* addr_memory = ((uint64_t*) a_m) + (cb*8);

      for (int i = 0 ; i < 512 ; i++)
        count[i] = 0;

      //printf("Global address: %p\n", addr_memory);
      //printf("Address: %p\n", addr_ido);

      for (int i = 0 ; i < 1000 ; i++)
      {
        // initialize the cache block
        for (int j = 0 ; j < 8 ; j++)
          addr_memory[j] = 0;
        flush_row((char*)a_m);
        // printf("flush\n");

        // access with reduced tRCD
        induce_activation_failure((char*)addr_ido);
        printf("");
      
        // count the number of ones in each bit in the cache block
        for (int j = 0 ; j < 64 ; j++)
        {     
          uint8_t read = ((uint8_t*)(addr_memory))[j];
          for (int bit = 0 ; bit < 8 ; bit++)
          {
            if((read >> bit) & 0x1)
              count[j*8+bit]++;
          }
        }
      }

      float cb_ent = 0;

      // calculate entropy per bitline
      for (int i = 0 ; i < 512 ; i++)
      {
        float p1 = ((float) count[i])/1000.f;
        float p2 = 1 - p1;
        if (count[i] == 0 || count[i] == 1000)
          continue;
        // Using gini-simpson index
        float bl_ent = 1 - (p1*p1 + p2*p2);
        cb_ent += bl_ent;
        // printf("%d\t",count[i]);
        if (bl_ent > 0.1)
          printf("%d %d %d %d %d %d\n", 0, row, cb, i, (int) (bl_ent*100), (int)(p1*100));
      }
      //printf("%d ", (int)cb_ent);
    }
    //printf("\n");
  } 
}

void test_one_cb(int bank, int row, int cb, int trcd)
{
  set_timings(5, 5, trcd);
  uint64_t a = dram_linear_address(bank, row);
  uint64_t a_m = a + (0xc0000000u - 0x10000000u);

  uint64_t* addr_ido = ((uint64_t*) a) + (cb*8);
  uint64_t* addr_memory = ((uint64_t*) a_m) + (cb*8);

  // initialize the cache block
  for (int j = 0 ; j < 8 ; j++)
    addr_memory[j] = 0x0;
  flush_row((char*)a_m);

  induce_activation_failure((char*) addr_ido);

  for (int j = 0 ; j < 8 ; j++)
    printf("%x\n", addr_memory[j]);
}

void get_bitstream_from_cell(int bank, int row, int cb, int cell, int trcd)
{
  set_timings(5, 5, trcd);
  uint64_t a = dram_linear_address(bank, row);
  uint64_t a_m = a + (0xc0000000u - 0x10000000u);

  uint64_t* addr_ido = ((uint64_t*) a) + (cb*8);
  uint64_t* addr_memory = ((uint64_t*) a_m) + (cb*8);

  printf("%p %d\n",addr_ido, cell);

  uint8_t bitstream[32];
  for (int i = 0 ; i < 32 ; i++)
    bitstream[i] = 0;
  for (int i = 0 ; i < 256 ; i++)
  {
    // initialize the cache block
    for (int j = 0 ; j < 8 ; j++)
      addr_memory[j] = 0x0;
    flush_row((char*)a_m);

    induce_activation_failure((char*) addr_ido);

    printf("");

    uint64_t* addr_dword = addr_memory + (cell/64);
    int bit = ((*addr_dword) >> (cell%64)) & 0x1;

    bitstream[i/8] |= bit;
    bitstream[i/8] <<= 1;
  }

  for (int i = 0 ; i < 32 ; i++)
  {
    printf("%x",bitstream[i]);
  }
  printf("\n");
}

void test_periodic_rng()
{
  set_timings(5, 5, 4);
  printf("set timings\n");

  uint64_t a = dram_linear_address(0, 2);
  uint64_t a_m = a + (0xc0000000u - 0x10000000u);

  uint8_t *address = (uint8_t*) a;
  uint8_t *address_r = (uint8_t*) a_m;

  //flush_row((char*)address_r);

  //printf("flushed row\n");

  //rng_configure(10, (char*)(0x10500), 165, 293, 308, 393, 0);
  
  printf("configured rng\n");


  for(int i = 0 ; i < 512 ; i++)
  {
    int rn;
    while(rng_buf_size() == 0);
    rn = rng_buf_read();
    printf("%d:%x \n",i,rn);
  }

  printf("\n");
}

int main(int argc, char *argv[])
{
  set_timings(5, 5, 4);

  //test_periodic_rng();
  //return 0;
  /*
  printf("Test one cache block\n");
// 0 2 125 437 22 12

  test_periodic_rng();
  get_bitstream_from_cell(0, 1, 20, 165, 3);

  //drange_characterize();

  int bank = 0;
  int row = 1;
  int cb = 20;
  int trcd = 3;

  test_periodic_rng();
  rng_configure(0, (char*)(0x10500), 165, 293);

  //for(int i = 0 ; i < 512 ; i++)
  //{
    get_bitstream_from_cell(bank, row, cb, 165, trcd);
    get_bitstream_from_cell(bank, row, cb, 293, trcd);
 // }
  return 0;
  //test_one_cb(bank, row, cb, trcd);

  //return 0;

  printf("Begin Characterization\n");
  drange_characterize();
  */
  int* arr = (int*)(SODIMM_START-ZYNQ_OFFSET);
  int accumulate = 0;

  for (int conf = 100 ; conf < 1000 ; conf+=100)
  {
    rng_configure(10*conf, (char*)(SODIMM_START-ZYNQ_OFFSET+0x1344), 0, 1, 2, 3, 1);
    uint64_t begin = read_cycles();
    uint64_t begini = read_insts();
    for (int i = 0 ; i < 1024*1024/sizeof(int) ; i++)
    {
      //printf("%d\n",1024*1024/sizeof(short));
      //accumulate += arr[i];
      while (rng_buf_size() == 0);
      accumulate += rng_buf_read();
    }
    uint64_t end = read_cycles();
    uint64_t endi = read_insts();

    accumulate += *(int*)(SODIMM_START - ZYNQ_OFFSET + 0x1337);

    uint64_t drange_time = end-begin;
    uint64_t drange_insts = endi-begini;

    begin = read_cycles();
    begini = read_insts();
    for (int i = 0 ; i < 1024*1024/sizeof(double) ; i++)
    {
      // accumulate += arr[i];
      accumulate += spec_rand();
    }
    end = read_cycles();
    endi = read_insts();

    uint64_t specrand_time = end - begin;
    uint64_t specrand_insts = endi-begini;

    printf("%d %ld-%ld %ld-%ld\n", 10*conf, drange_time, drange_insts, specrand_time, specrand_insts);
  }
}

