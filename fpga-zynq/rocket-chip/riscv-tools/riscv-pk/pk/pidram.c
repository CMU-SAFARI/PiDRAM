#include "subarray.h"
#include "pidram.h"
#include "pk.h"
#include "mmap.h"
#include "imolib.h"

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

/*
int find_samt_entry(uintptr_t addr)
{
  // Mask the most significant bits of the addr
  // this assumes subarray addresses increase
  // somehow linearly. i.e. each masked
  // value points to a unique samt.
  pte_t* pte = __walk(addr); // TODO do we need to supply vpns or vns?
  int ppn = pte_ppn(*pte);
  // Access the reverse mapping table 
  // to see which sa this is mapped to
  int samt_idx = PST[ppn];
  return samt_idx;
}
*/

int do_rcc(uintptr_t src, uintptr_t dest, size_t n)
{
  #ifdef DEBUG_PK
  printk("do_rcc::begin\n");
  #endif
  /**
   * 1-> Split src and dest into 8KB chunks
   * 2-> Obtain PAs corresponding to each chunk
   * 3-> Use imolib to copy from src to dest chunks
   */
  if(n < RC_ROWSIZE || n % RC_ROWSIZE != 0) // size has to be a multiple of 8KBs
    return -EINVAL;
  uintptr_t va_s = src;
  uintptr_t va_d = dest;

  int no_chunks = n/RISCV_PGSIZE;
  int i = 0;
  for (; i < no_chunks/2 ; i++)
  {
    // Walk the page table to obtain physical addresses
    pte_t* pte_s = __walk(va_s);
    pte_t* pte_d = __walk(va_d);

    size_t prn_s = (pte_ppn(*pte_s) - DRAM_BASE_PPN) >> 4;
    size_t prn_d = (pte_ppn(*pte_d) - DRAM_BASE_PPN) >> 4;

    int bank_s = (pte_ppn(*pte_s) >> 1) & 0x7;
    int bank_d = (pte_ppn(*pte_d) >> 1) & 0x7;

    // Row number should be (PPN-DRAMBASEPPN)/2
    // row address is ^ multiplied by 8192
    size_t ra_s = pte_ppn(*pte_s) << 12;
    size_t ra_d = pte_ppn(*pte_d) << 12;

    #ifdef DEBUG_PK
    printk("do_rcc::flushing address:0x%x and 0x%x, copy_source:0x%x, copy_target:0x%x\n", 
    (char*)ra_s + (DRAM_BASE_PPN << 12), (char*)ra_d + (DRAM_BASE_PPN << 12), 
    (char*)ra_s, (char*)ra_d);
    #endif 

    // Flush source row and invalidate destination row
    flush_row((char*)ra_s + (DRAM_BASE_PPN << 12));
    flush_row((char*)ra_d + (DRAM_BASE_PPN << 12));

    copy_row((char*)ra_s, (char*)ra_d);

    va_s += RISCV_PGSIZE;
    va_d += RISCV_PGSIZE;
  }

  return 0;
}


int do_rci(uintptr_t src, size_t n)
{
  #ifdef DEBUG_PK
  printk("do_rci::begin\n");
  #endif
   /**
   * 1-> Split src into 4KB chunks
   * 2-> Obtain PAs corresponding to each chunk
   * 3-> Find out which SA a chunk maps to by querying PST
   * 4-> Init using row_copy from all_zero_row to this chunk
   */
  if(n < RC_ROWSIZE || n % RC_ROWSIZE != 0) // size has to be a multiple of 8KBs
    return -EINVAL;
  uintptr_t va_d = src;

  int no_blocks = n/RISCV_PGSIZE;
  int i = 0;
  for (; i < no_blocks/2 ; i++)
  {
    // Walk the page table to obtain physical addresses
    pte_t* pte_d = __walk(va_d);
    // Physical DRAM row number within DRAM bank

    int bank = (pte_ppn(*pte_d) >> 1) & 0x7;
    size_t prn_d = (pte_ppn(*pte_d) - DRAM_BASE_PPN) >> 4;

    #ifdef DEBUG_PK
    printk("do_rci:: bank:%d va:0x%x pa:0x%x ppn:0x%x prn:0x%x\n", bank, va_d, pte_ppn(*pte_d) << 12, pte_ppn(*pte_d), prn_d);
    #endif

    // Find the all-zero-row's physical address


    #ifdef DEBUG_PK
    printk("do_rci:: SAMT_idx:%d\n", PST[bank][prn_d]);
    #endif

    uintptr_t azr = SAMT[bank][PST[bank][prn_d]].all_zero_paddr;

    #ifdef DEBUG_PK
    printk("do_rci:: all-zero-row-pa:0x%x\n",azr);
    #endif

    // Row number should be (PPN-DRAMBASEPPN)/2
    // row address is ^ multiplied by 8192
    size_t ra_d = (pte_ppn(*pte_d) - DRAM_BASE_PPN) << 12;    

    // Invalidate to-be-initialized cache blocks
   
    #ifdef DEBUG_PK
    printk("do_rci::flushing address:0x%x, copy_source:0x%x, copy_target:0x%x\n", (char*)ra_d + (DRAM_BASE_PPN << 12), (char*)(azr - (DRAM_BASE_PPN << 12)),(char*)ra_d);
    #endif 

    flush_row((char*)ra_d + (DRAM_BASE_PPN << 12));
    copy_row((char*)(azr - (DRAM_BASE_PPN << 12)), (char*)ra_d);
    va_d += RISCV_PGSIZE;
  } 
  return 0;
}

uint16_t do_read_rand()
{
  while(!rng_buf_size());
  return rng_buf_read();
}

#ifdef NO
int do_cpyalign(uintptr_t src, uintptr_t dest, size_t n)
{
  /** Atb:
  * Basically
  * 0-> Split src and dest arrays into 8KB chunks
  * For i in range(0,n/8192,8192):
  *  1-> Find two empty physical addresses from the subphy table
  *  2-> Map these physical addresses to src + i*8192 and dest + i *8192
  */
  if(n < RC_ROWSIZE || n % RC_ROWSIZE != 0) // size has to be a multiple of 8KBs
    return -EINVAL;
  
  uintptr_t va_s = src;
  uintptr_t va_d = dest;
  #ifdef DEBUG_PK
  printk("Aligning %p and %p\n", va_s, va_d);
  #endif

  int to_align = n/RC_ROWSIZE;
  // Traverse the subphy -> physical address table
  for(int j = 0 ; j < SAMT_SUBARRAYS ; j++)
  {
    // There are two unmapped rows in the jth subarray
    if(SAMT[j].free_entries > 1)
    {
      // Decrement the # of free rows in this subarray
      SAMT[j].free_entries -= 2;
      // Physical addresses of these two segments
      // are initially null
      uintptr_t pa_s = 0, pa_d = 0;
      for(int k = 0 ; k < SAMT_RPS ; k++)
      {
        // We found a row for the dest. segment
        if (pa_s && !SAMT[j].is_used[k])
        {
          pa_d = SAMT[j].pairs[k].a1;
          SAMT[j].is_used[k] = 1;
          break;
        } 
        // We found a row for src. segment
        else if(!SAMT[j].is_used[k])
        {
          pa_s = SAMT[j].pairs[k].a1;
          SAMT[j].is_used[k] = 1;
        }
      }
      // Create page table entries such that
      // va_x -> pa_x, here since we are operating
      // on 8KB granularity, we make two calls to
      // map two pages (4KB).

      #ifdef DEBUG_PK
      printk("do_cpyalign(): P1-1:0x%lx P1-2:0x%lx P2-1:0x%lx P2-2:0x%lx\n", 
            pa_s, pa_s+RISCV_PGSIZE, pa_d, pa_d+RISCV_PGSIZE);
      #endif

      __pt_map(va_s, pa_s);
      __pt_map(va_d, pa_d);
      __pt_map(va_s + RISCV_PGSIZE, pa_s + RISCV_PGSIZE);
      __pt_map(va_d + RISCV_PGSIZE, pa_d + RISCV_PGSIZE);
      to_align -= 1;
      if(to_align == 0)
        break;
      va_s += RC_ROWSIZE;
      va_d += RC_ROWSIZE;
      // Continue allocating from one subarray until its full
      // TODO might want to rethink this.
      j--;
    }
    // No free entries in this subarray
    else
      continue;      
  }

  flush_tlb();

  // We could not align all the data
  if(to_align)
    return -1;

  return 0;
}
#endif 
/**
 * Retrieve free physical addresses from SAMT.
 * Returns two physical addresses that
 * collectively point to a DRAM row.
 * @param ptr_arr the list of PAs to populate
 * @param bank PA should point to this DRAM bank
 * @param id allocate s.t. this array can be copied to other
 *  arrays with the same id
 */
void __retrieve_free_pa(uintptr_t* ptr_arr, int bank, int id)
{
  #ifdef DEBUG_PK
  printk("__retrieve_free_pa::bank:%d, id:%d\n", bank, id);
  #endif

  unsigned short aiste = AIST[bank][id];
  // no SAMT entries were allocated using this ID
  // first we allocate an SAMT entry
  if (aiste == MAX_ALLOC_ID + 1)
  {
    // we can freely allocate any SAMT entry
    for (int i = 0 ; i < SUBARRAYS_PER_BANK ; i++)
    {
      // found a free SAMT entry
      if (SAMT[bank][i].alloc_id == MAX_ALLOC_ID + 1)
      {
        #ifdef DEBUG_PK
        printk("__retrieve_free_pa::found free SAMT entry: %d\n", i);
        #endif        
        AIST[bank][id] = i;
        SAMT[bank][i].alloc_id = id;
        break;
      }
    }
  }
  // there is a SAMT entry allocated to this ID
  aiste = AIST[bank][id];
  for (int i = 0 ; i < SAMT_ROWS_PER_ENTRY ; i++)
  {
    #ifdef DEBUG_PK
    printk("__retrieve_free_pa::SAMT[%d][%d][%d] is used?: %d free?: %d\n", bank, aiste, i, SAMT[bank][aiste].used[i], SAMT[bank][aiste].free);
    #endif
    // we found an empty address pair
    // return the address pair
    // and set this entry to be used
    if (!SAMT[bank][aiste].free)
      // TODO this should not happen, or should be handled
      continue;
    if (!SAMT[bank][aiste].used[i])
    {
      ptr_arr[0] = SAMT[bank][aiste].pairs[i].a1;
      ptr_arr[1] = SAMT[bank][aiste].pairs[i].a2;
      SAMT[bank][aiste].used[i] = 1;
      SAMT[bank][aiste].free -= 1;
      #ifdef DEBUG_PK
      printk("__retrieve_free_pa():: found empty SAMT pair -- bank:%d SAMTindex:%d pair:%d\n",
        bank, aiste, i);
      #endif
      break; //TODO: break or return which one is more readable?
    }
  }
}

/**
 * Returns a pointer to virtually contiguous bytes.
 */
uintptr_t __retrieve_va_range(size_t size)
{
  // TODO: this will call our own version of MMAP?
  uintptr_t curr = rc_area_curr;
  rc_area_curr += size;
  return curr;
}
/**
 * Optimize allocation for RowClone-ability
 * @param size bytes to allocate
 * @param id allocation id of this array, we will
 *  allocate memory s.t. arrays with same ids can be 
 *  copied to/from each other
 * @returns pointer (virtual) to the start of 
 *  the allocated array
 */
uintptr_t do_alloc_align(size_t size, int id)
{
  // TODO unfortunately we need to pad the size
  // this function should only be called
  // with size == ROW_BYTES * N
  if (size % ROW_BYTES)
    return -EINVAL;

  // the size of the optimizable region
  // this specifies how much we can 
  // copy using RowClone
  int opt_size = size/ROW_BYTES;
  
  // the virtual address to allocate to the
  // start of the array
  uintptr_t va_begin = __retrieve_va_range(size);
  // we will allocate for RowClone-ability
  if(opt_size > 0)
  {
    int btu = opt_size < BANK_SIZE ? opt_size : BANK_SIZE;
    for(int i = 0 ; i < opt_size ; i++)
    {
      // we map the current virtual page and
      // the i + opt_size/2th page together
      // to the same DRAM row
      uintptr_t this_va = va_begin + i*RISCV_PGSIZE;
      uintptr_t far_va = va_begin + i*RISCV_PGSIZE + opt_size*ROW_BYTES/2;

      // which DRAM bank we want to allocate to
      int bank = i%BANK_SIZE;

      uintptr_t ptr[2];
      // populate ptr array with btu*2 physical addresses
      __retrieve_free_pa(ptr, bank, id);

      //printk("alloc_align()::i:%d this_va:0x%lx far_va:0x%lx this_pa:0x%x far_va:0x%x\n",
        //i, this_va, far_va, ptr[0], ptr[1]);

      __pt_map(this_va, ptr[0]);
      __pt_map(far_va, ptr[1]);
    }
  }
  return va_begin;
  // TODO: requires sfence.vma (i.e. flush_tlb())?
}

#ifdef NO
int do_initalign(uintptr_t src, size_t n)
{
  /** Atb:
  * Basically
  * 0-> Split src and dest arrays into 8KB chunks
  * For i in range(0,n/8192,8192):
  *  1-> Find two empty physical addresses from the subphy table
  *  2-> Map these physical addresses to src + i*8192 and dest + i *8192
  */
  if(n < RC_ROWSIZE || n % RC_ROWSIZE != 0) // size has to be a multiple of 8KBs
    return -EINVAL;
  
  uintptr_t va_s = src;
  #ifdef DEBUG_PK
  printk("Aligning %p s.t. it can be rc-initialized\n", va_s);
  #endif

  int to_align = n/RC_ROWSIZE;
  // Traverse the subphy -> physical address table
  for(int j = 0 ; j < SAMT_SUBARRAYS ; j++)
  {
    // There is one unmapped row in the jth subarray
    if(SAMT[j].free_entries > 0)
    {
      // Decrement the # of free rows in this subarray
      SAMT[j].free_entries -= 1;
      // Physical address of the segment is initially null
      uintptr_t pa_s = 0;
      for(int k = 0 ; k < SAMT_RPS ; k++)
      {
        // We found a row for src. segment
        if(!SAMT[j].is_used[k])
        {
          pa_s = SAMT[j].pairs[k].a1;
          SAMT[j].is_used[k] = 1;
          break;
        }
      }
      // Create page table entries such that
      // va_x -> pa_x, here since we are operating
      // on 8KB granularity, we make two calls to
      // map two pages (4KB).

      #ifdef DEBUG_PK
      printk("do_cpyalign(): P1-1:0x%lx P1-2:0x%lx\n", 
            pa_s, pa_s+RISCV_PGSIZE);
      #endif

      __pt_map(va_s, pa_s);
      __pt_map(va_s + RISCV_PGSIZE, pa_s + RISCV_PGSIZE);

      to_align -= 1;
      if(to_align == 0)
        break;
      va_s += RC_ROWSIZE;
      // Continue allocating from one subarray until its full
      // TODO might want to rethink this.
      j--;
    }
    // No free entries in this subarray
    else
      continue;      
  }

  flush_tlb();

  // We could not align all the data
  if(to_align)
    return -1;

  return 0;
}
#endif

void samt_initialize_from_header()
{
  for (int bank = 0 ; bank < BANK_SIZE ; bank++)
  {
    printk("SAMT_INITIALIZE()::BANK:%d\n", bank);
    for (int sa = 0 ; sa < SAS_IN_BANK ; sa++)
    {
    printk("SAMT_INITIALIZE()::sa:%d\n", sa);
      for(int row = 0 ; row < no_rows_in_same_sa[bank][sa] ; row++)
      {
        SAMT[bank][sa].pairs[row].a1 = (uintptr_t) rows_in_same_sa[bank][sa][row];
        SAMT[bank][sa].pairs[row].a2 = ((uintptr_t) rows_in_same_sa[bank][sa][row]) + 4096;
        SAMT[bank][sa].used[row] = 0;
        SAMT[bank][sa].free++;
        PST[bank][((ppn((uintptr_t)rows_in_same_sa[bank][sa][row])-DRAM_BASE_PPN)>>1)/8] = sa;

      }
      
      // Allocate a row for 0-initialization
      uintptr_t all_zero_row_addr = SAMT[bank][sa].pairs[SAMT[bank][sa].free-1].a1;
      SAMT[bank][sa].all_zero_paddr = all_zero_row_addr;

      init_wdata_all_zeros();
      printk("all_zero_row_addr:0x%lx\n", all_zero_row_addr);
      init_row_wdata((uint64_t*)all_zero_row_addr, 0);
      //flush_row((char*)all_zero_row_addr);
      printk("all_zero_row_addr:0x%lx done\n", all_zero_row_addr);

      int free = SAMT[bank][sa].free;  
      SAMT[bank][sa].free -= 1;
      SAMT[bank][sa].used[free-1] = 1;
      SAMT[bank][sa].alloc_id = MAX_ALLOC_ID + 1;
      AIST[bank][sa] = MAX_ALLOC_ID + 1;
    }
  }

  
}

void samt_initialize()
{
  //printk("SAMT INITIALIZE\n");
  // We want one byte to mark rows that we already
  // found a subarray for.
  memset(found_subarray, 0, 1024*1024*1024/ROW_BYTES);
  set_timings(5,5,4);
  int sa_id = 0;
  uint64_t *base = (uint64_t*) (SODIMM_START - ZYNQ_OFFSET);

  for (int bank = 0 ; bank < BANK_SIZE ; bank++)
  {
    printk("BANK%d\n",bank);
    sa_id = 0;
    // Iterate over all source <-> target pairs to fill up SAMT
    // with enough stride so that we traverse rows in the same bank
    for (uint64_t* source = base + (bank*0x2000)/8, sidx = bank ;; source += (0x10000/8), sidx+=8)
    {
      if(sa_id == SUBARRAYS_PER_BANK)
        break;
      // This row is already indexed in the SAMT
      if(found_subarray[sidx])
        continue;

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

        // Add to SAMT otherwise
        int samt_idx = SAMT[bank][sa_id].free;
        SAMT[bank][sa_id].pairs[samt_idx].a1 = (uintptr_t) target;
        SAMT[bank][sa_id].pairs[samt_idx].a2 = ((uintptr_t) target) + 4096;
        SAMT[bank][sa_id].used[samt_idx] = 0;
        SAMT[bank][sa_id].free++;
        
        #ifdef DEBUG_PK
        printk("samt_initialize::addr:%p PST_idx:0x%x sa_id:%d\n", target, ((ppn((uintptr_t)target)-DRAM_BASE_PPN)>>1)/8, sa_id);
        #endif
        PST[bank][((ppn((uintptr_t)target)-DRAM_BASE_PPN)>>1)/8] = sa_id;

        found_subarray[tidx] = 1;

        // We are one row away from filling an samt entry
        if(SAMT[bank][sa_id].free == SAMT_ROWS_PER_ENTRY - 1)
          break;
      }

      // if we found at least one other row in this subarray
      // we finally add the source row to the list
      if(SAMT[bank][sa_id].free)
      {
        int samt_idx = SAMT[bank][sa_id].free;
        SAMT[bank][sa_id].pairs[samt_idx].a1 = (uintptr_t) source;
        SAMT[bank][sa_id].pairs[samt_idx].a2 = ((uintptr_t) source) + 4096;
        SAMT[bank][sa_id].used[samt_idx] = 0;
        SAMT[bank][sa_id].alloc_id = MAX_ALLOC_ID + 1;
        SAMT[bank][sa_id].free++;
        #ifdef DEBUG_PK
        printk("samt_initialize:: PST_idx:0x%x sa_id:%d\n", (ppn((uintptr_t)source)-DRAM_BASE_PPN)>>1, sa_id);
        #endif
        PST[bank][((ppn((uintptr_t)source)-DRAM_BASE_PPN)>>1)/8] = sa_id;
      }

      // Two cases: (i) we found a subarray for this row
      // (ii) we did not. Either way, it is impossible for this
      // row to be cloned to any other row
      found_subarray[sidx] = 1;

      #ifdef DEBUG_PK
      printk("sa_id:%d done\n", sa_id);
      #endif

      sa_id ++;
    }

    // Initialize all zero and all one rows to be used for rc-init
    for (int i = 0; i < SUBARRAYS_PER_BANK ; i++)
    {

      #ifdef DEBUG_PK
      printk("%d free entries in samt_idx:%d\n", SAMT[bank][i].free,i);
      #endif
      int free = SAMT[bank][i].free;
      if (free < 2)
        continue;
      
      // Allocate two rows for initialization
      uintptr_t all_zero_row_addr = SAMT[bank][i].pairs[SAMT[bank][i].free-1].a1;

      SAMT[bank][i].all_zero_paddr = all_zero_row_addr;

      init_wdata_all_zeros();
      init_row_wdata((uint64_t*)all_zero_row_addr, 0);

      #ifdef DEBUG_PK
      printk("samt_initialize::Flush:%p\n",(char*)all_zero_row_addr);
      #endif

      flush_row((char*)all_zero_row_addr);

      int diff = 0;
      for (int i = 0 ; i < 8192 ; i++)
      {
        if(*((uint64_t*)all_zero_row_addr))
          diff++;
      }
      //if(diff)
        //printk("Could not initialize 0x%x with zeros\n", all_zero_row_addr);

      SAMT[bank][i].free -= 1;
      SAMT[bank][i].used[free-1] = 1;
      SAMT[bank][i].alloc_id = MAX_ALLOC_ID + 1;
      AIST[bank][i] = MAX_ALLOC_ID + 1;
      //printk("samt_initialize::entry free count:%d\n",SAMT[bank][i].free);
    }
  }
}