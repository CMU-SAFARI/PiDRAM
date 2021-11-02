`timescale 1ns / 1ps

`include "encoding.vh"

module rlrd_scheduler(
  input                             clk,
  input                             rst,
  
  input                             rng_boost_enable, // continue until the RNG buffer is full
  input                             rng_fifo_full,
  
  input                             start,
  input                             is_rng,
  output  reg                       finish,
  
  input  [`ROW_SZ-1:0]              s2_row_r,
  input  [`BANK_SZ-1:0]             s2_bank_r,
  input  [`COL_SZ-1:0]              s2_col_r,
          
  input   [3:0]                     timing,

  input                             row_miss,
  input                             row_hit,
  input                             row_conflict,
  
  output  reg                       per_rng_rden,
 
  output  reg [`DEC_DDR_CMD_SZ*4-1:0]   phy_cmd,
  output  reg [`ROW_SZ*4-1:0]           phy_row,
  output  reg [`BANK_SZ*4-1:0]          phy_bank,
  output  reg [`COL_SZ*4-1:0]           phy_col,
  
  output  reg                           pre,
  output  reg                           act,
  
  // interface with cdt
  output  [`DEC_DDR_CMD_SZ-1:0]     cmd,
  output  [`BANK_SZ-1:0]            bank,
  
  output  reg                       issue,
  output  reg [1:0]                 issued_offset,
  
  input   [1:0]                     offset,
  input                             valid
  );
    
  localparam    IDLE_S       =       0;
  localparam    PRE_S        =       1;
  localparam    RLRD_S       =       2;
  localparam    WRITE_S      =       3;
  
  (*dont_touch = "TRUE"*) reg [1:0]     state_r               ;
  reg [1:0]     state_ns              ;
  reg [4:0]     read_timing_ns                                                              ;
  reg [4:0]     read_timing_r                                                               ;
  reg           issued_same_cycle_ns                                                        ;
  reg           issued_same_cycle_r                                                         ;
  
  reg  [`DEC_DDR_CMD_SZ-1:0]         issue_cmd                                              ;
  assign                             cmd = issue_cmd                                        ;
  
  wire          is_delay_even                                             = ~ timing[0]     ;
  wire          is_act_from_odd_slot                                      =  offset[0]      ;
  wire [1:0]    act_correct_offset    = is_delay_even ? (is_act_from_odd_slot ? offset : (offset | 2'b01)) :
                                      /*delay not even*/(is_act_from_odd_slot ? (offset + 1) : offset);
  
  
  always @* begin
    phy_cmd                                                               = 0               ;
    state_ns                                                              = state_r         ;
    issue_cmd                                                             = `DDR_NOP        ;
    issued_offset                                                         = offset          ;
    read_timing_ns                                                        = read_timing_r   ;
    issued_same_cycle_ns                                                  = 0               ;
    finish                                                                = 0               ;
    pre                                                                   = 0               ;
    act                                                                   = 0               ;
    issue                                                                 = 0               ;
    per_rng_rden                                                          = 0               ;

    case(state_r)
      IDLE_S: begin
        if (start) begin
          if (row_miss) begin
            state_ns                                                      = RLRD_S; 
          end else begin
            state_ns                                                      = PRE_S;
          end
        end
      end // IDLE_S
      PRE_S: begin
        issue_cmd = `DDR_PRE;
        if (valid) begin
          phy_cmd[`DEC_DDR_CMD_SZ*offset +: `DEC_DDR_CMD_SZ]        = issue_cmd;
          phy_bank[`BANK_SZ*offset +: `BANK_SZ]                     = s2_bank_r;
          issue                                                     = 1'b1;
          state_ns                                                  = RLRD_S;
          pre                                                       = 1'b1;     
        end           
      end // PRE_S
      RLRD_S: begin
        read_timing_ns                                              =       read_timing_r - 6'd4;
        issue_cmd                                                   =       `DDR_READ;
        if (row_hit) begin
          if (read_timing_r < 6'd4) begin
            phy_cmd[`DEC_DDR_CMD_SZ*read_timing_r +: `DEC_DDR_CMD_SZ]               = `DDR_READ;
            phy_bank[`BANK_SZ*read_timing_r +: `BANK_SZ]                            = s2_bank_r;
            phy_col[`COL_SZ*read_timing_r +: `COL_SZ]                               = s2_col_r;
            per_rng_rden                                                            = 1'b1;
            state_ns                                                                = is_rng ? WRITE_S : IDLE_S;
            if (!is_rng) 
              finish                                                                = 1'b1;                      
          end
          // Means that we have ACTivated the row and still waiting for reduced
          // tRCD to pass
        end
        else begin
          // The row we want to access with reduced latency is in a precharged bank
          // Depending on reduced latency timing, we might issue ACT and RD in the same cycle
          issue_cmd = `DDR_ACT;
          if (valid) begin         
            phy_cmd[`DEC_DDR_CMD_SZ*act_correct_offset +: `DEC_DDR_CMD_SZ]              = issue_cmd;
            phy_bank[`BANK_SZ*act_correct_offset +: `BANK_SZ]                           = s2_bank_r;
            phy_row[`ROW_SZ*act_correct_offset +: `ROW_SZ]                              = s2_row_r;
            issue                                                                       = 1'b1;
            issued_offset                                                               = act_correct_offset;
            act                                                                         = 1'b1;            
            if (act_correct_offset + timing <= 6'b000011) begin // Can issue read this cycle
              phy_cmd[`DEC_DDR_CMD_SZ*(act_correct_offset + timing) +: `DEC_DDR_CMD_SZ] = `DDR_READ;
              per_rng_rden                                                              = 1'b1;
              phy_bank[`BANK_SZ*(act_correct_offset + timing) +: `BANK_SZ]              = s2_bank_r;
              phy_col[`COL_SZ*(act_correct_offset + timing) +: `COL_SZ]                 = s2_col_r;
              state_ns                                                                  = is_rng ? WRITE_S : IDLE_S;
              if (!is_rng) 
                finish                                                                  = 1'b1;
              else
                issued_same_cycle_ns                                                    = 1'b1;
            end else begin
              read_timing_ns                                                            = (act_correct_offset + timing) - 6'd4;
            end // cannot issue read this cycle          
          end // can_issue
        end // else row_hit      
      end // RLRD_S
      WRITE_S: begin
        issued_same_cycle_ns = issued_same_cycle_r; 
        if (issued_same_cycle_r) begin
          issued_same_cycle_ns = 1'b0; // delay by one fabric clock
        end else begin
          issue_cmd = `DDR_WRITE;
          if(valid) begin
            issue                                                  =  1'b1;
            if (offset[0]) begin
              phy_cmd[`DEC_DDR_CMD_SZ*(offset) +: `DEC_DDR_CMD_SZ] = `DDR_WRITE;
              phy_bank[`BANK_SZ*(offset) +: `BANK_SZ]              = s2_bank_r;
              phy_col[`COL_SZ*(offset) +: `COL_SZ]                 = s2_col_r;           
            end else begin
              phy_cmd[`DEC_DDR_CMD_SZ*(offset | 2'b01) +: `DEC_DDR_CMD_SZ]  = `DDR_WRITE;
              phy_bank[`BANK_SZ*(offset | 2'b01) +: `BANK_SZ]               = s2_bank_r;
              phy_col[`COL_SZ*(offset | 2'b01) +: `COL_SZ]                  = s2_col_r;
              issued_offset                                                 = offset | 2'b01;
            end
            finish                                                 =  1'b1;
            state_ns                                               =  IDLE_S;
            if (rng_boost_enable && !rng_fifo_full) begin
              state_ns                                             =  PRE_S;
              finish                                               =  1'b0;            
            end
            if (rng_boost_enable && rng_fifo_full) begin
              state_ns                                             =  IDLE_S;
              finish                                               =  1'b1;            
            end
            
          end // valid
        end
      end     
    endcase        
  end
  
  always @(posedge clk) begin
    if (rst) begin
      state_r             <=      IDLE_S;
      read_timing_r       <=      0;    
      issued_same_cycle_r <=      0;
    end else begin
      state_r             <=      state_ns;
      read_timing_r       <=      read_timing_ns;
      issued_same_cycle_r <=      issued_same_cycle_ns;
    end
  end
  
endmodule
