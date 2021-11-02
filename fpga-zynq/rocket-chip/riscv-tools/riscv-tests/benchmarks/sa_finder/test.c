/*
#include "imolib.h"

uint64_t lfsr = 0xDEADBEEF;
int dummy[4*1024]; // access this to forcefully evict caches

// Initialize rows with random data before copying them
uint64_t wdata [ROW_BYTES/sizeof(uint64_t)];
uint64_t wdata2 [ROW_BYTES/sizeof(uint64_t)];

int slow_flush()
{
  int i = 0,j=0;
  int acc = 0;
  for(;j<4;j++)
  {
    for(;i<4*1024;i++)
    {
      acc += dummy[i];
      dummy[i] += 7 + j;
    }
  }
  return acc;
}

// generate random numbers using an lfsr
void srand(uint64_t seed)
{
  lfsr = seed;
}

uint64_t rand()
{ 
  // Tap 64, 63, 61, 60
  uint64_t tap1 = (lfsr >> 63) & 0x1;
  uint64_t tap2 = (lfsr >> 62) & 0x1;
  uint64_t tap3 = (lfsr >> 60) & 0x1;
  uint64_t tap4 = (lfsr >> 59) & 0x1;
  lfsr          = (lfsr << 1) | (tap1 ^ tap2 ^ tap3 ^ tap4);
  return lfsr;
}

void init_wdata()
{
  int i = 0;
  for(; i<1024 ; i++)
    wdata[i] = rand();
}

void init_wdata2()
{
  int i = 0;
  for(; i<1024 ; i++)
    wdata2[i] = rand();
}

void init_row_wdata(uint64_t *row_addr, int invert)
{
  int i = 0;
  if(invert)
    for(; i<1024 ; i++)
      row_addr[i] = ~wdata[i];
  else
    for(; i<1024 ; i++)
      row_addr[i] = wdata[i];
}

void init_row_wdata2(uint64_t *row_addr, int invert)
{
  int i = 0;
  for(; i<1024 ; i++)
    row_addr[i] = wdata2[i];
}

static char found_subarray[1024*1024*1024/ROW_BYTES];

void find_subarrays()
{
  set_timings(5,5,4);
  int sa_id = 0;
  uint64_t *base = (uint64_t*) (SODIMM_START - ZYNQ_OFFSET);
  int row_count = 0;
  memset(found_subarray, 0, 1024*1024*1024/ROW_BYTES);
  
  int dummy_var = 0;

  // Iterate over all source <-> target pairs to fill up spt
  for (uint64_t* source = base, sidx = 0 ;; source += ROW_BYTES/8, sidx++)
  {
    // This row is already indexed in the spt
    if(found_subarray[sidx])
      continue;

    printf("%ld - ",((uintptr_t)(source-base))>>10);

    // Iterate over all possible target rows
    for(uint64_t* target = base, tidx = 0; target < (base + (1024*1024*128/sizeof(uint64_t))) ; target += ROW_BYTES/8, tidx++)
    {
      //printf("Source:%p Target:%p\n", source, target);
      // This target row is also already indexed in the spt
      if(found_subarray[tidx])
        continue;

      init_wdata();
      init_wdata2();
      init_row_wdata(source, 0);
      init_row_wdata2(target, 0);

      dummy_var += slow_flush();

      //flush_row((char*) source);
      //flush_row((char*) target);
      
      copy_row((char*) (sidx*(ROW_BYTES)), 
        (char*) (tidx*(ROW_BYTES)));

      // Check if there are any errors in the read
      int err = 0;
      for(int i = 0; i < ROW_BYTES/8 ; i++)
      {
        uint64_t word = target[i];
        uint64_t diff = word^wdata[i];
        if (diff) err++;
      }
      // Skip this row if there are errors
      // printf("%d\n",err);
      if(err>512)
        continue;

      found_subarray[tidx] = 1;
      printf("%ld ", ((uintptr_t)(target-base))>>10);
      //printf("spt_initialize:: address:0x%x row_id:%d sa_id:%d\n", (uintptr_t)target, ((uintptr_t)(target-base))>>10, sa_id);
    }
    printf("\n");
    found_subarray[sidx] = 1;
    sa_id++;
  }
  printf("%d\n",dummy_var);
}


#define SODIMM_START 0xc0000000u  // Where the sodimm addresses start in memory
#define ZYNQ_OFFSET  0x10000000u  // the system already increases our addresses by this amount

#define BANK_SIZE 8

// Assume there are as many as 512 rows
// in  a subarray and there are as many
// as 64 subarrays in one bank
static uint64_t subarrays[8][64][512];

static char found_subarray[1024*1024*1024/ROW_BYTES];

// Initialize DRAM rows using these arrays.
uint64_t wdata [ROW_BYTES/sizeof(uint64_t)];
uint64_t wdata2 [ROW_BYTES/sizeof(uint64_t)];

// Generate random addresses for dummy testing.
uint64_t lfsr = 1337;
uint64_t __rand()
{ 
  // Tap 64, 63, 61, 60
  uint64_t tap1 = (lfsr >> 63) & 0x1;
  uint64_t tap2 = (lfsr >> 62) & 0x1;
  uint64_t tap3 = (lfsr >> 60) & 0x1;
  uint64_t tap4 = (lfsr >> 59) & 0x1;
  lfsr          = (lfsr << 1) | (tap1 ^ tap2 ^ tap3 ^ tap4);

  return lfsr;
}

void init_wdata()
{
  int i = 0;
  for(; i<1024 ; i++)
    wdata[i] = __rand();
}

void init_wdata_all_zeros()
{
  int i = 0;
  for(; i<1024 ; i++)
    wdata[i] = 0;
}

void init_wdata2()
{
  int i = 0;
  for(; i<1024 ; i++)
    wdata2[i] = __rand();
}

void init_row_wdata(uint64_t *row_addr, int invert)
{
  int i = 0;
  if(invert)
    for(; i<1024 ; i++)
      row_addr[i] = ~wdata[i];
  else
    for(; i<1024 ; i++)
      row_addr[i] = wdata[i];
}

void init_row_wdata2(uint64_t *row_addr, int invert)
{
  int i = 0;
  for(; i<1024 ; i++)
    row_addr[i] = wdata2[i];
}

int main()
{
  //printk("SAMT INITIALIZE\n");
  // We want one byte to mark rows that we already
  // found a subarray for.
  set_timings(5,5,4);
  int sa_id = 0;
  uint64_t *base = (uint64_t*) (SODIMM_START - ZYNQ_OFFSET);

  for (int bank = 0 ; bank < BANK_SIZE ; bank++)
  {

    for (int i = 0 ; i < 1024*1024*1024/ROW_BYTES ; i++)
    {
      found_subarray[i] = 0;
    }
    printf("BANK%d\n",bank);
    sa_id = 0;
    // Iterate over all source <-> target pairs to fill up SAMT
    // with enough stride so that we traverse rows in the same bank
    for (uint64_t* source = base + (bank*0x2000)/8, sidx = bank ; source < (base + (1024*1024*1024/sizeof(uint64_t))) ; source += (0x10000/8), sidx+=8)
    {
      // We found the subarray this row belongs to
      if(found_subarray[sidx])
        continue;

      int row_id = 0;
      // Iterate over all possible target rows
      for(uint64_t* target = base + (bank*0x2000)/8, tidx = bank; target < (base + (1024*1024*1024/sizeof(uint64_t))) ; 
        target += (0x10000/8), tidx+=8)
      {
        // printk("Source:%p Target:%p\n", source, target);
        // This target row is also already indexed in the SAMT
        if(source == target) 
          continue;
        if(found_subarray[tidx])
          continue;

        init_wdata();
        init_wdata2();
        init_row_wdata(source, 0);
        init_row_wdata2(target, 0);

        flush_row((char*) source);
        flush_row((char*) target);

        copy_row((char*) (sidx*(ROW_BYTES)), 
          (char*) (tidx*(ROW_BYTES)));

        // Check if there are any errors in the read
        int err = 0;
        for(int i = 0; i < ROW_BYTES/8 ; i++)
        {
          uint64_t word = target[i];
          uint64_t diff = word^wdata[i];
          if(diff)
          {
            err = 1;
            //printk("Cannot Copy\n", source, target);
            break;
            //printk("Cannot Copy\n", source, target);
          }
        }
        // Skip this row if there are errors
        if(err)
          continue;

        // Test to see if we can do it the other way around  
        init_wdata();
        init_wdata2();
        init_row_wdata(source, 0);
        init_row_wdata2(target, 0);

        flush_row((char*) source);
        flush_row((char*) target);

        copy_row((char*) (tidx*(ROW_BYTES)), 
          (char*) (sidx*(ROW_BYTES)));

        // Check if there are any errors in the read
        err = 0;
        for(int i = 0; i < ROW_BYTES/8 ; i++)
        {
          uint64_t word = source[i];
          uint64_t diff = word^wdata2[i];
          if(diff)
          {
            err = 1;
            //printk("Cannot Copy\n", source, target);
            break;
            //printk("Cannot Copy\n", source, target);
          }
        }
        // Skip this row if there are errors
        if(err)
          continue;

        // Add to subarray list otherwise
        subarrays[bank][sa_id][row_id] = (uint64_t) target;
        row_id++;
        found_subarray[tidx] = 1;
      }

      // Two cases: (i) we found a subarray for this row
      // (ii) we did not. Either way, it is impossible for this
      // row to be cloned to any other row

      subarrays[bank][sa_id][row_id] = (uint64_t) source;
      row_id++;
      found_subarray[sidx] = 1;

      //printf("sa_id:%d done, rows in sa:\n", sa_id);

      for(int i = 0 ; i < row_id-1 ; i++)
      {
        printf("%lx,",subarrays[bank][sa_id][i]);
      }

      printf("%lx\n",subarrays[bank][sa_id][row_id-1]);

      sa_id ++;
    }
  }
}
*/