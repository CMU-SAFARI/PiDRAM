#include <stdint.h>
#include <stdio.h>

char a[64*1024];
char b[64*1024];

unsigned char farr[64*1024];

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

void flush_bench();
void simple_flush_test();

uint64_t debug_array [8192*8];
void debug_flush_test()
{
  uint64_t* base = ((uint64_t)debug_array)/16384 * 16384 + 16384;

  for (int i = 5 ; i < 256 ; i++)
  {
    printf("loop_variable:%p %d\n",&i, i);
    // Because we traverse long ints
    uint64_t* this_cache_block = base + i * 8;
    for(int j = 0 ; j < 10 ; j++)
    {
      *this_cache_block = 0xffffffffffffffff;
      *(this_cache_block+1) = 0xffffffffffffffff;
      *(this_cache_block+2) = 0xffffffffffffffff;
      *(this_cache_block+3) = 0xffffffffffffffff;
      *(this_cache_block+4) = 0xffffffffffffffff;
      *(this_cache_block+5) = 0xffffffffffffffff;
      *(this_cache_block+6) = 0xffffffffffffffff;
      *(this_cache_block+7) = 0xffffffffffffffff;
      //printf("Cache block %d @%p done\n", i, this_cache_block);
      asm volatile("fence");
      asm volatile("flush %[value]\n\t" :: [value] "r" ((char*)this_cache_block));
      //asm volatile("flush %[value]\n\t" :: [value] "r" ((char*)this_cache_block));
      //asm volatile("flush %[value]\n\t" :: [value] "r" ((char*)this_cache_block));
    }
    printf("Cache block %d @%p done\n", i, this_cache_block);
  }
}

void debug_flush_test_cache_block_basis()
{
  uint64_t* base = ((uint64_t)debug_array)/16384 * 16384 + 16384;

  for (int i = 0 ; i < 100 ; i++)
  {
    printf("loop_variable:%p %d\n",&i, i);
    uint64_t lv_address = (uint64_t)&i;
    uint64_t cl_idx = (lv_address % 4096) / 64;
    uint64_t* this_cache_block = base + (cl_idx-1) * 8;
    for(int j = 0 ; j < 1000 ; j++)
    {
      *this_cache_block = 0xffffffffffffffff;
      asm volatile("fence");
      asm volatile("flush %[value]\n\t" :: [value] "r" ((char*)this_cache_block));
    }
    printf("Cache block %d @%p done\n", i, this_cache_block);
    this_cache_block = base + cl_idx * 8;
    for(int j = 0 ; j < 1000 ; j++)
    {
      *this_cache_block = 0xffffffffffffffff;
      asm volatile("fence");
      asm volatile("flush %[value]\n\t" :: [value] "r" ((char*)this_cache_block));
    }
    printf("Cache block %d @%p done\n", i, this_cache_block);
  }
}

int main()
{
  int i = 0;
  //debug_flush_test_cache_block_basis();
  debug_flush_test();

  simple_flush_test();
  printf("Begin traversing\n");

  uint64_t insts = read_insts();
  uint64_t begin = read_cycles();

  for (;i<64*1024;i++)
  {
    a[i] = b[i];
  }

  uint64_t cputime = read_cycles() - begin;
  uint64_t cpuinsts = read_insts() - insts;
 
  /*
  printf("Flush first block %d %d\n", cputime, cpuinsts);
  asm volatile("flush %[value]\n\t" :: [value] "r" (a) );
  asm volatile("fence");
  a[20] += a[0] + a[1];
  */

  unsigned char* fca = (unsigned char*) (((uint64_t)a)/64 * 64 + 64);
  unsigned char* fcb = (unsigned char*) (((uint64_t)b)/64 * 64 + 64);

  printf("Start flushing\n");
  asm volatile("fence");
  for(i = 0 ; i < 1024; i++){
    char* ptr = fca + i*64;
    asm volatile("fence");
    asm volatile("flush %[value]\n\t" :: [value] "r" (ptr) );
    asm volatile("fence");
    ptr = fcb + i*64;
    asm volatile("fence");
    asm volatile("flush %[value]\n\t" :: [value] "r" (ptr) );
    asm volatile("fence");
  }

  printf("Flushed first block\n");
  printf("Try to access a[0]\n");

}

void simple_flush_test()
{

  //printf("simple_flush_test::begin\n");
  
  uint64_t* fcb = (uint64_t*) (((uint64_t)farr)/64 * 64 + 64);
  fcb += 1107;

  int ofs = 0;
  for (ofs = 0 ; ofs < 16 ; ofs++)
  {
    fcb[0] = (uint64_t) 0xffffffffffffffff;
    printf("base:%p\n", fcb);

    uint64_t cached_time = 0;
    uint64_t uncached_time = 0;

    int i = 0;
    for (; i < 100 ; i++)
    {
      uint64_t begin = read_cycles();
      uint64_t load;
      asm volatile("ld %[value], 0(%[addr])" : [value] "=r" (load) : [addr] "r" (fcb));
      cached_time += read_cycles() - begin;
    }

    for (i=0 ; i < 100 ; i++)
    {
      asm volatile("fence");
      asm volatile("flush %[value]\n\t" :: [value] "r" ((char*)fcb));
      asm volatile("fence");
      uint64_t begin = read_cycles();
      uint64_t load;
      asm volatile("ld %[value], 0(%[addr])" : [value] "=r" (load) : [addr] "r" (fcb));
      uncached_time += read_cycles() - begin;
    }

    printf("average cache cycles:%d average memory cycles:%d\n", cached_time/100, uncached_time/100);
  
    fcb += 1;

  }
}


void flush_bench()
{
  int rec[256] = {0};
  int recinst[256] = {0};
  int i = 0, iter = 0, fs = 0;

  for(;i<256;i++)
  {
    rec[i] = 0;
    recinst[i] = 0;
  }

  unsigned char* fcb = (unsigned char*) (((uint64_t)farr)/64 * 64 + 64);

  //char* fcb = SODIMM_START - ZYNQ_OFFSET;

  for(iter = 0 ; iter < 5 ; iter++)
  {
    printf("i%d\n",iter);
    for(fs = 0 ; fs < 16 ; fs++)
    {
      // WARMUP
      for(i = 0 ; i < 2*1024 ; i++)
        farr[i] = 0;

      for(i = 0 ; i < 2*1024 ; i++)
        farr[i] = i + 1;

      printf("%p-%p\n", farr, fcb);

      uint64_t insts = read_insts();
      uint64_t begin = read_cycles();
      asm volatile("fence");
      for(i = 0 ; i < fs; i++){
        char* ptr = fcb + i*64;
        asm volatile("flush %[value]\n\t" :: [value] "r" (ptr) );
        asm volatile("fence");
      }
      uint64_t cputime = read_cycles() - begin;
      uint64_t cpuinsts = read_insts() - insts;
      
      rec[fs] += cputime;
      recinst[fs] += cpuinsts;

      //for(i = 0 ; i < 32*1024 ; i++)
        //farr[i] = i + 1;
    }
  }

  int _fs = 0;
  for(_fs = 0 ; _fs < 16 ; _fs++)
    printf("Flush %d blocks -- %d cycles %d insts\n", _fs, rec[_fs]/5, recinst[_fs]/5); 
}
