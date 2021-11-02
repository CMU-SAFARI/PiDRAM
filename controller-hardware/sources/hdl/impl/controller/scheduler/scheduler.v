`timescale 1ns / 1ps
`include "encoding.vh"
`include "parameters.vh"

module scheduler(
  input                           clk,
  input                           rst,

  // To AXI4 converter
  output reg                      axi_rack,
  output reg                      axi_wack,
  input [29:0]                    axi_rdaddr,
  input [29:0]                    axi_wraddr,
  input                           axi_wren,
  input                           axi_rden,
  
  // In-memory operations controller
  input [59:0]                    imo_addr,
  input [`INT_CMD_SZ-1:0]         imo_cmd,
  input                           imo_valid,
  output reg                      imo_ack,
  
  // Periodic operations controller
  input [59:0]                    poc_addr,
  input [`INT_CMD_SZ-1:0]         poc_cmd,
  input                           poc_valid,
  output reg                      poc_ack,
  
  // Configurable timing parameters
  input  [3:0]                    rc_t1,
  input  [3:0]                    rc_t2,
  input  [3:0]                    rlrd_t1,
  input                           rng_boost_enable,
  input                           rng_fifo_full,
  
  // PHY Converter
  output reg [`DEC_DDR_CMD_SZ*4-1:0]  phy_cmd,
  output reg [`ROW_SZ*4-1:0]          phy_row,
  output reg [`BANK_SZ*4-1:0]         phy_bank,
  output reg [`COL_SZ*4-1:0]          phy_col,
  
  output [5:0]                        rd_flag,
  output                              rd_en  
);
  
  (*dont_touch = "true"*) reg [39:0]              rd_ctr_r, rd_ctr_ns;
      
  // Stage 1 signals
  reg [`INT_CMD_SZ-1:0]   s1_cmd_r, s1_cmd_ns;
  reg [59:0]              s1_addr_r, s1_addr_ns;
  reg                     s1_valid_r, s1_valid_ns;
  
  // Stage 2 signals
  reg                     s1_ack;
  reg [`INT_CMD_SZ-1:0]   s2_cmd_ns, s2_cmd_r;
  reg [`ROW_SZ-1:0]       s2_row1_ns, s2_row1_r;
  reg [`ROW_SZ-1:0]       s2_row2_ns, s2_row2_r;
  reg [`BANK_SZ-1:0]      s2_bank_ns, s2_bank_r;
  reg [`COL_SZ-1:0]       s2_col_ns, s2_col_r;
  reg                     s2_valid_ns, s2_valid_r;
  
  // Stage 3 signals
  reg                     s2_ack;
  
  // #########################################################
  // ############# Stage 1 - Arbitration #####################
  // #########################################################

  // Arbiter selects between abstracted memory commands
  // originated from three modules:
  //   1. Periodic operations controller
  //        - This module is responsible for issuing
  //        ZQS calibration and periodic reads that are
  //        required to keep the Xilinx PHY alive.
  //        - It is also configured to issue RNG commands
  //        at a certain frequency and fill random number buffers
  //   2. Rocket-chip memory bus
  //   3. InMemOps (IMO) controller in rocket-chip

  wire s0_advance = (s1_valid_r && s1_ack) || ~s1_valid_r;
  wire any_requestor_valid = poc_valid | axi_rden | axi_wren | imo_valid;

  always @* begin
    axi_rack    = 1'b0;
    axi_wack    = 1'b0;
    imo_ack     = 1'b0;
    poc_ack     = 1'b0;
    s1_valid_ns = (s1_valid_r & !s1_ack) | any_requestor_valid;
    s1_cmd_ns   = 16'bx;
    s1_addr_ns  = 60'bx;
    if(~s0_advance) begin
      s1_cmd_ns   = s1_cmd_r;
      s1_addr_ns  = s1_addr_r;
    end
    else if(poc_valid) begin
      poc_ack     = s0_advance;
      s1_cmd_ns   = poc_cmd;
      s1_addr_ns  = poc_addr;        
    end
    else if(axi_rden) begin
      axi_rack    = s0_advance;
      s1_cmd_ns   = 1 << `INT_RD_OFS;
      s1_addr_ns  = axi_rdaddr;
    end
    else if(axi_wren) begin
      axi_wack    = s0_advance;
      s1_cmd_ns   = 1 << `INT_WR_OFS;
      s1_addr_ns  = axi_wraddr;      
    end
    else if(imo_valid) begin
      imo_ack     = s0_advance;
      s1_cmd_ns   = imo_cmd;
      s1_addr_ns  = imo_addr;
    end
  end

  always @(posedge clk) begin
    if(rst) begin
      s1_valid_r <= 1'b0;
      s1_cmd_r <= {`INT_CMD_SZ{1'bx}};
      s1_addr_r <= 60'bx;     
    end
    else begin
      s1_valid_r <= s1_valid_ns;
      s1_cmd_r <= s1_cmd_ns;
      s1_addr_r <= s1_addr_ns;
    end
  end
  
  // ###########################
  // Stage 2 - address decoding
  // ###########################
  
  wire s1_advance = (s2_valid_r && s2_ack) || ~s2_valid_r;
  
  always @* begin
    s2_valid_ns = (s2_valid_r & !s2_ack) | s1_valid_r;
    s1_ack      = 1'b0;
    s2_row1_ns  = 15'bx;
    s2_row2_ns  = 15'bx;
    s2_bank_ns  = 3'bx;
    s2_col_ns   = 10'bx;
    s2_cmd_ns   = 16'b0;
    if(~s1_advance) begin
      s2_row1_ns    = s2_row1_r;
      s2_row2_ns    = s2_row2_r;
      s2_bank_ns    = s2_bank_r;          
      s2_col_ns     = s2_col_r;
      s2_cmd_ns     = s2_cmd_r;      
    end
    // RBC address decoding
    // least significant bits are column bits
    // most significant bits are row bits
    // bank bits are in the middle 
    else if(s1_valid_r & s1_advance) begin
      s1_ack        = s1_advance;
      s2_row1_ns    = s1_addr_r[16+:14];
      s2_row2_ns    = s1_addr_r[46+:14];
      s2_bank_ns    = s1_addr_r[13+:3];          
      s2_col_ns     = s1_addr_r[3+:10];
      s2_cmd_ns     = s1_cmd_r;
    end
  end
  
  always @(posedge clk) begin
    if(rst) begin
      s2_valid_r       <= 0; 
    end
    else begin
      s2_row1_r        <= s2_row1_ns;
      s2_row2_r        <= s2_row2_ns;
      s2_bank_r        <= s2_bank_ns;
      s2_col_r         <= s2_col_ns;
      s2_cmd_r         <= s2_cmd_ns;
      s2_valid_r       <= s2_valid_ns;    
    end 
  end
  
  // #############################
  // Stage 3 - Command Generation
  // #############################

  integer i;

  localparam ZERO   = 0;
  localparam ONE    = 1;
  localparam TWO    = 2;
  localparam THREE  = 3;
  
  wire can_issue;
  wire [1:0] issue_offset;
  reg [1:0] new_issue_offset;
  reg issue;
  reg [`DEC_DDR_CMD_SZ-1:0] issue_cmd;
  
  // to obey manufacturer-recommended timings
  command_timer cdt(
  .clk(clk),
  .rst(rst),
    
  .cmd(issue_cmd),
  .bank(s2_bank_r),
  
  .issue(issue),
  .new_issue_offset(new_issue_offset),
  
  // where this command should be issued from
  .offset(issue_offset),
  .valid(can_issue)
  );

  // Must have: RD/WR should be as *fast*
  // as possible, at least for sequential accesses.
  
  (*dont_touch = "true" *) reg[`ROW_SZ-1:0] open_row_addr_r [7:0], open_row_addr_ns [7:0];
  (*dont_touch = "true" *) reg[7:0] is_open_r, is_open_ns;  
  
  wire is_rd          = s2_valid_r & s2_cmd_r[`INT_RD_OFS];
  wire is_rw          = s2_valid_r & (s2_cmd_r[`INT_RD_OFS] | s2_cmd_r[`INT_WR_OFS]);
  wire is_wr          = s2_valid_r & (s2_cmd_r[`INT_WR_OFS]);
  wire addr_row_hit   = (is_open_r[s2_bank_r] && (s2_row1_r == open_row_addr_r[s2_bank_r]));
  wire row_hit        = is_rw && addr_row_hit; 
  wire row_conflict   = is_open_r[s2_bank_r] && ~row_hit;
  wire row_miss       = ~is_open_r[s2_bank_r];
  
  wire is_rlrd        = s2_valid_r & (s2_cmd_r[`INT_RLRD_OFS] | s2_cmd_r[`INT_RNG_OFS]);
  wire is_per_rng     = s2_valid_r & s2_cmd_r[`INT_RNG_OFS];
  reg  rlrd_act_once;
  wire  per_rng_rden; 
    
  wire is_copy        = s2_valid_r & s2_cmd_r[`INT_COPY_OFS];
  reg  copy_pre_r, copy_pre_ns;
  reg  copy_act1_r, copy_act1_ns;  

  wire is_ref         = s2_valid_r & s2_cmd_r[`INT_REF_OFS];

  assign rd_flag      = is_rd ? (ONE << `REGULAR_READ_OFS) : 
                        s2_cmd_r[`INT_RNG_OFS] ? (ONE << `RNG_READ_OFS) : 
                        (1 << `GARBAGE_READ_OFS); // These will be discarded
  assign rd_en        = ((is_rd | (is_rlrd & ~is_per_rng)) & s2_ack) || (is_per_rng & per_rng_rden);
  
  // we can only issue reads&writes to odd phy slots     
  wire [1:0] zeroth_slot       = ZERO;
  wire [1:0] first_slot        = ONE;
  wire [1:0] second_slot       = TWO;
  wire [1:0] third_slot        = THREE;  

  localparam              IDLE_S = 0;
  localparam              COPY_S = 1;
  reg  [1:0]              copy_state_r, copy_state_ns;
  reg                     cp_act1_sent_r, cp_act1_sent_ns;
  reg                     cp_pre_sent_r, cp_pre_sent_ns;

  reg [4:0] cp_act1_idx_r, cp_act1_idx_ns;
  reg [4:0] cp_pre_idx_r, cp_pre_idx_ns;
  reg [4:0] cp_act2_idx_r, cp_act2_idx_ns;     
 
  localparam              REF_S = 1;
  reg  [1:0]              ref_state_r, ref_state_ns;

  
  // this dude issues the reduced latency access commands
  
  wire              rlrd_finish, rlrd_pre, rlrd_act;
  reg               rlrd_start;
  
  wire [`DEC_DDR_CMD_SZ*4-1:0]  rlrd_phy_cmd;
  wire [`ROW_SZ*4-1:0]          rlrd_phy_row;
  wire [`BANK_SZ*4-1:0]         rlrd_phy_bank;
  wire [`COL_SZ*4-1:0]          rlrd_phy_col;
  
  wire  [`DEC_DDR_CMD_SZ-1:0]   rlrd_issue_cmd;
  wire                          rlrd_issue;
  wire  [1:0]                   rlrd_issued_offset;
  
  rlrd_scheduler rlrd_sched(
  .clk              (clk)                   ,
  .rst              (rst)                   ,
  
  .rng_boost_enable (rng_boost_enable)      ,
  .rng_fifo_full    (rng_fifo_full)         ,
  
  .start            (rlrd_start)            ,
  .finish           (rlrd_finish)           ,
  .is_rng           (is_per_rng)            , 
  
  .s2_row_r         (s2_row1_r)             ,
  .s2_bank_r        (s2_bank_r)             ,
  .s2_col_r         (s2_col_r)              ,
  
  .timing           (rlrd_t1)               ,
  
  .row_miss         (row_miss)              ,
  .row_hit          (addr_row_hit)          ,
  .row_conflict     (row_conflict)          ,
  
  .phy_cmd          (rlrd_phy_cmd)          ,
  .phy_row          (rlrd_phy_row)          ,
  .phy_bank         (rlrd_phy_bank)         ,
  .phy_col          (rlrd_phy_col)          ,
  
  .pre              (rlrd_pre)              ,
  .act              (rlrd_act)              ,
  .per_rng_rden     (per_rng_rden)          ,
  
  // interface with cdt
  .cmd              (rlrd_issue_cmd)        ,
  
  .issue            (rlrd_issue)            ,
  .issued_offset    (rlrd_issued_offset)    ,
  
  .offset           (issue_offset)          ,
  .valid            (can_issue)
  );
  
  wire              copy_finish, copy_pre, copy_act;
  reg               copy_start;
  
  wire [`DEC_DDR_CMD_SZ*4-1:0]  copy_phy_cmd;
  wire [`ROW_SZ*4-1:0]          copy_phy_row;
  wire [`BANK_SZ*4-1:0]         copy_phy_bank;
  wire [`COL_SZ*4-1:0]          copy_phy_col;
  
  wire  [`DEC_DDR_CMD_SZ-1:0]   copy_issue_cmd;
  wire                          copy_issue;
  wire  [1:0]                   copy_issued_offset;  
  
  apa_scheduler apa_sched(
  .clk              (clk)                   ,
  .rst              (rst)                   ,
  
  .start            (copy_start)            ,
  .finish           (copy_finish)           ,
 
  .s2_src_r         (s2_row1_r)             ,
  .s2_dst_r         (s2_row2_r)             ,
  .s2_bank_r        (s2_bank_r)             ,
  
  .t1               (rc_t1)                 ,
  .t2               (rc_t2)                 ,
   
  .row_miss         (row_miss)              ,
  .row_hit          (addr_row_hit)          ,
  .row_conflict     (row_conflict)          ,
  
  .phy_cmd          (copy_phy_cmd)          ,
  .phy_row          (copy_phy_row)          ,
  .phy_bank         (copy_phy_bank)         ,
  .phy_col          (copy_phy_col)          ,
  
  .pre              (copy_pre)              ,
  .act              (copy_act)              ,
  
  // interface with cdt
  .cmd              (copy_issue_cmd)        ,
  
  .issue            (copy_issue)            ,
  .issued_offset    (copy_issued_offset)    ,
  
  .offset           (issue_offset)          ,
  .valid            (can_issue)  
  
  );

  // **************************************************************************
  // Some debug signals
  
  (*dont_touch = "true"*) reg row_hit_r, row_hit_ns;
  (*dont_touch = "true"*) reg row_conflict_r, row_conflict_ns;
  (*dont_touch = "true"*) reg row_miss_r, row_miss_ns;
  
  (*dont_touch = "true"*) reg [`ROW_SZ-1:0] row_addr_r, row_addr_ns;
  (*dont_touch = "true"*) reg [`BANK_SZ-1:0] bank_addr_r, bank_addr_ns;
  (*dont_touch = "true"*) reg [`COL_SZ-1:0] col_addr_r, col_addr_ns;
  
  (*dont_touch = "true"*) reg debug_reg_enable_r, debug_reg_enable_ns;
  
  
  // **************************************************************************
  integer bank;
  always @* begin
    rd_ctr_ns                                                                 = rd_ctr_r;
  
    issue                                                                     = 0;
    issue_cmd                                                                 = 0; // indicates NOP
  
    phy_cmd                                                                   = 0; // indicates NOP
    for (i = 0 ; i < 8 ; i = i+1)
      open_row_addr_ns[i]                                                     = open_row_addr_r[i];
    is_open_ns                                                                = is_open_r;

    copy_state_ns                                                             = copy_state_r;
    cp_act1_sent_ns                                                           = cp_act1_sent_r;
    cp_pre_sent_ns                                                            = cp_pre_sent_r;
    cp_act2_idx_ns                                                            = cp_act2_idx_r;
    cp_act1_idx_ns                                                            = cp_act1_idx_r;
    cp_pre_idx_ns                                                             = cp_pre_idx_r;    
        
    ref_state_ns                                                              = ref_state_r;
    
//    per_rng_rden                                                              = 1'b0;
    s2_ack                                                                    = 1'b0;

    phy_row                                                                   = 120'bx;
    phy_bank                                                                  = 20'bx;
    phy_col                                                                   = 120'bx;
    
    new_issue_offset                                                          = issue_offset;
    
    rlrd_start                                                                = 0;
    copy_start                                                                = 0;

    // **************************************************************************
    // Some debug signals
  
    row_hit_ns                                                                = row_hit_r;
    row_conflict_ns                                                           = row_conflict_r;
    row_miss_ns                                                               = row_miss_r;
 
    row_addr_ns                                                               = row_addr_r;
    bank_addr_ns                                                              = bank_addr_r;
    col_addr_ns                                                               = col_addr_r;

    debug_reg_enable_ns                                                       = debug_reg_enable_r;
  
    // **************************************************************************
    
    if (is_rw && row_hit) begin
      issue_cmd = is_rd ? `DDR_READ : `DDR_WRITE;
      if (debug_reg_enable_r) begin
        row_hit_ns          =   1'b1;
        row_conflict_ns     =   1'b0;
        row_miss_ns         =   1'b0;
        row_addr_ns         =   s2_row1_r;
        col_addr_ns         =   s2_col_r;
        bank_addr_ns        =   s2_bank_r;
        debug_reg_enable_ns =   1'b0;
      end
      if (can_issue) begin
        if(issue_offset[0] == 1'b1) begin // odd slot, can fire
          phy_cmd[`DEC_DDR_CMD_SZ*issue_offset +: `DEC_DDR_CMD_SZ]            = issue_cmd;
          phy_bank[`BANK_SZ*issue_offset +: `BANK_SZ]                         = s2_bank_r;
          phy_col[`COL_SZ*issue_offset +: `COL_SZ]                            = s2_col_r;
        end else begin
          phy_cmd[`DEC_DDR_CMD_SZ*(issue_offset | 1'b1) +: `DEC_DDR_CMD_SZ]   = issue_cmd;
          phy_bank[`BANK_SZ*(issue_offset | 1'b1) +: `BANK_SZ]                = s2_bank_r;
          phy_col[`COL_SZ*(issue_offset | 1'b1) +: `COL_SZ]                   = s2_col_r;
          new_issue_offset                                                    = issue_offset | 1'b1;        
        end
        issue                                                                 = 1'b1;
        s2_ack                                                                = 1'b1;
        if (is_rd)
          rd_ctr_ns                                                           = rd_ctr_r + 1;
      end
    end
    
    if (is_rw && row_miss) begin
      issue_cmd = `DDR_ACT;
      if (debug_reg_enable_r) begin
        row_hit_ns          =   1'b0;
        row_conflict_ns     =   1'b0;
        row_miss_ns         =   1'b1;
        row_addr_ns         =   s2_row1_r;
        col_addr_ns         =   s2_col_r;
        bank_addr_ns        =   s2_bank_r;
        debug_reg_enable_ns =   1'b0;
      end      
      if (can_issue) begin
        phy_cmd[`DEC_DDR_CMD_SZ*issue_offset +: `DEC_DDR_CMD_SZ]              = issue_cmd;
        phy_bank[`BANK_SZ*issue_offset +: `BANK_SZ]                           = s2_bank_r;
        phy_row[`ROW_SZ*issue_offset +: `ROW_SZ]                              = s2_row1_r;            
        issue                                                                 = 1'b1;
        is_open_ns[s2_bank_r]                                                 = 1'b1;
        open_row_addr_ns[s2_bank_r]                                           = s2_row1_r;
      end    
    end
    
    if (is_rw && row_conflict) begin
      issue_cmd = `DDR_PRE;
      if (debug_reg_enable_r) begin
        row_hit_ns          =   1'b0;
        row_conflict_ns     =   1'b1;
        row_miss_ns         =   1'b0;
        row_addr_ns         =   s2_row1_r;
        col_addr_ns         =   s2_col_r;
        bank_addr_ns        =   s2_bank_r;
        debug_reg_enable_ns =   1'b0;
      end      
      if (can_issue) begin
        phy_cmd[`DEC_DDR_CMD_SZ*issue_offset +: `DEC_DDR_CMD_SZ]              = issue_cmd;
        phy_bank[`BANK_SZ*issue_offset +: `BANK_SZ]                           = s2_bank_r;
        issue                                                                 = 1'b1;
        is_open_ns[s2_bank_r]                                                 = 1'b0;
      end    
    end
    
    if (is_ref) begin
      case(ref_state_r) // TODO: REFRESH will precharge-all regardless of the state
      IDLE_S: begin      
        issue_cmd = `DDR_PRE_ALL;
        if (can_issue) begin
          phy_cmd[`DEC_DDR_CMD_SZ*issue_offset +: `DEC_DDR_CMD_SZ]            = issue_cmd;
          issue                                                               = 1'b1;
          is_open_ns                                                          = 8'b0;     
          ref_state_ns                                                        = REF_S;        
        end
      end        
      REF_S: begin
        issue_cmd = `DDR_REF;
        if (can_issue) begin
          // Send a REF
          phy_cmd[`DEC_DDR_CMD_SZ*issue_offset+:`DEC_DDR_CMD_SZ]              = `DDR_REF;
          issue                                                               = 1'b1;
          ref_state_ns                                                        = IDLE_S;
          s2_ack                                                              = 1'b1;
        end
      end
      endcase      
    end

    if (is_rlrd) begin
      // 1- start the state machine
      // 2- check for PRE, ACT commands which modify bank state
      // 3- check for finish signal
      phy_cmd                                                                 = rlrd_phy_cmd;
      phy_row                                                                 = rlrd_phy_row;
      phy_bank                                                                = rlrd_phy_bank;
      phy_col                                                                 = rlrd_phy_col;
    
      new_issue_offset                                                        = rlrd_issued_offset;
      issue_cmd                                                               = rlrd_issue_cmd;
      issue                                                                   = rlrd_issue;
    
      // this can remain set, would not be a problem
      rlrd_start                                                              = 1'b1;
 
      if (rlrd_pre) begin
        is_open_ns[s2_bank_r]                                                 = 1'b0;             
      end
      
      if (rlrd_act) begin
        is_open_ns[s2_bank_r]                                                 = 1'b1;
        open_row_addr_ns[s2_bank_r]                                           = s2_row1_r;          
      end
        
      if (rlrd_finish) begin
        s2_ack                                                                = 1'b1;
      end    
    end

    if (is_copy) begin
      // 1- start the state machine
      // 2- check for PRE, ACT commands which modify bank state
      // 3- check for finish signal
      phy_cmd                                                                 = copy_phy_cmd;
      phy_row                                                                 = copy_phy_row;
      phy_bank                                                                = copy_phy_bank;
      phy_col                                                                 = copy_phy_col;
    
      new_issue_offset                                                        = copy_issued_offset;
      issue_cmd                                                               = copy_issue_cmd;
      issue                                                                   = copy_issue;
    
      // this can remain set, would not be a problem
      copy_start                                                              = 1'b1;
 
      if (copy_pre) begin
        is_open_ns[s2_bank_r]                                                 = 1'b0;             
      end
      
      if (copy_act) begin
        is_open_ns[s2_bank_r]                                                 = 1'b1;
        open_row_addr_ns[s2_bank_r]                                           = s2_row2_r;          
      end
        
      if (copy_finish) begin
        s2_ack                                                                = 1'b1;
      end    
    end
    if (s2_ack) debug_reg_enable_ns                                           = 1'b1;
  end
  
  
  always @(posedge clk) begin
    if (rst) begin
      rd_ctr_r          <= 0;
      rlrd_act_once     <= 0;
      is_open_r         <= 0;
      copy_pre_r        <= 0;
      copy_act1_r       <= 0;  
      for (i = 0 ; i < 8 ; i = i+1)
        open_row_addr_r[i] <= 0;
      copy_state_r     <= IDLE_S;
      cp_act2_idx_r    <= 5'd10;
      cp_act1_idx_r    <= 5'd0;
      cp_pre_idx_r     <= 5'd5;
      cp_pre_sent_r    <= 1'b0;
      cp_act1_sent_r   <= 1'b0;
      
      ref_state_r      <= IDLE_S;
      
       
      row_hit_r      <= 0;
      row_conflict_r <= 0;
      row_miss_r     <= 0;
                    
      row_addr_r     <= 0;
      bank_addr_r    <= 0;
      col_addr_r     <= 0;
      
      debug_reg_enable_r <= 1'b1;      
    end
    else begin
      rd_ctr_r          <= rd_ctr_ns;
      copy_pre_r        <= copy_pre_ns;
      copy_act1_r       <= copy_act1_ns;
      is_open_r         <= is_open_ns;
      for (i = 0 ; i < 8 ; i = i+1)
        open_row_addr_r[i] <= open_row_addr_ns[i];
      
      copy_state_r   <= copy_state_ns;
      cp_act2_idx_r  <= cp_act2_idx_ns;
      cp_act1_idx_r  <= cp_act1_idx_ns;
      cp_pre_idx_r   <= cp_pre_idx_ns;
      cp_pre_sent_r  <= cp_pre_sent_ns;
      cp_act1_sent_r <= cp_act1_sent_ns;
      
      ref_state_r   <= ref_state_ns;
      
      
      row_hit_r     <= row_hit_ns;
      row_conflict_r<= row_conflict_ns;
      row_miss_r    <= row_miss_ns;
                    
      row_addr_r    <= row_addr_ns;
      bank_addr_r   <= bank_addr_ns;
      col_addr_r    <= col_addr_ns;
      
      debug_reg_enable_r <= debug_reg_enable_ns;      
    end
  end

endmodule
