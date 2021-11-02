`timescale 1ns / 1ps

`include "encoding.vh"

module apa_scheduler(
  input                             clk,
  input                             rst,
  
  input                             start,
  output  reg                       finish,
  
  input  [`ROW_SZ-1:0]              s2_src_r,
  input  [`ROW_SZ-1:0]              s2_dst_r,
  input  [`BANK_SZ-1:0]             s2_bank_r,
          
  input   [3:0]                     t1,
  input   [3:0]                     t2,
  
  input                             row_miss,
  input                             row_hit,
  input                             row_conflict,
  
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
  localparam    PRE1_S       =       1;
  localparam    COPY1_S      =       2;
  localparam    COPY2_S      =       3;
  localparam    COPY3_S      =       4;
  localparam    PRE2_S       =       5;
  
  reg [2:0]     state_r               ;
  reg [2:0]     state_ns              ;
  
  reg  [`DEC_DDR_CMD_SZ-1:0]         issue_cmd                                              ;
  assign                             cmd = issue_cmd                                        ;
  
  reg [4:0]     first_act_position_r, first_act_position_ns                                 ;
  reg [4:0]     first_pre_position_r, first_pre_position_ns                                 ;
  reg [4:0]     second_act_position_r, second_act_position_ns                               ;
 
 
  always @* begin
    first_act_position_ns                                                 = first_act_position_r        ;
    second_act_position_ns                                                = second_act_position_r       ;
    first_pre_position_ns                                                 = first_pre_position_r        ;
    phy_cmd                                                               = 0                           ;
    state_ns                                                              = state_r                     ;
    issue_cmd                                                             = `DDR_NOP                    ;
    issued_offset                                                         = offset                      ;
    finish                                                                = 0                           ;
    pre                                                                   = 0                           ;
    act                                                                   = 0                           ;
    issue                                                                 = 0                           ;
  
    if ((state_r == COPY1_S) || (state_r == COPY2_S) || (state_r == COPY3_S)) begin
      if (first_act_position_r > 5'd3) 
        first_act_position_ns                   =             first_act_position_r  - 5'd4              ;
      if (first_pre_position_r > 5'd3) 
        first_pre_position_ns                   =             first_pre_position_r  - 5'd4              ;
      if (second_act_position_r > 5'd3) 
        second_act_position_ns                  =             second_act_position_r - 5'd4              ;             
    end
  
  
    case(state_r)
      IDLE_S: begin
        if (start) begin
          if (row_miss) begin
            state_ns                                                      = COPY1_S; 
          end else begin
            state_ns                                                      = PRE1_S;
          end
        end
      end // IDLE_S
      PRE1_S: begin
        issue_cmd = `DDR_PRE;
        if (valid) begin
          phy_cmd[`DEC_DDR_CMD_SZ*offset +: `DEC_DDR_CMD_SZ]        = issue_cmd;
          phy_bank[`BANK_SZ*offset +: `BANK_SZ]                     = s2_bank_r;
          issue                                                     = 1'b1;
          state_ns                                                  = COPY1_S;
          pre                                                       = 1'b1;     
        end
        
        // We manually enforce tRP
        first_act_position_ns                                       = offset + 5'd6 - 5'd4;
        first_pre_position_ns                                       = first_act_position_ns + t1; 
        second_act_position_ns                                      = first_pre_position_ns + t2; 
                   
      end // PRE_S
      COPY1_S: begin
      // TODO do not forget to set act signal to 1
        
        // Three things can happen here:
        // 1 - only the first act command is scheduled
        // 2 - the first two act, pre commands are scheduled
        // 3 - all three commands are scheduled
        
        if (first_act_position_r < 5'd4) begin
          phy_cmd[`DEC_DDR_CMD_SZ*first_act_position_r +: `DEC_DDR_CMD_SZ]        = `DDR_ACT;
          phy_bank[`BANK_SZ*first_act_position_r +: `BANK_SZ]                     = s2_bank_r;
          phy_row[`ROW_SZ*first_act_position_r +: `ROW_SZ]                        = s2_src_r;     
        end
        
        if (first_pre_position_r < 5'd4) begin
          phy_cmd[`DEC_DDR_CMD_SZ*first_pre_position_r +: `DEC_DDR_CMD_SZ]        = `DDR_PRE;
          phy_bank[`BANK_SZ*first_pre_position_r +: `BANK_SZ]                     = s2_bank_r;
        end
        
        if (second_act_position_r < 5'd4) begin
          issue_cmd                                                                = `DDR_ACT;
          issue                                                                    = 1'b1;
          phy_cmd[`DEC_DDR_CMD_SZ*second_act_position_r +: `DEC_DDR_CMD_SZ]        = `DDR_ACT;
          phy_bank[`BANK_SZ*second_act_position_r +: `BANK_SZ]                     = s2_bank_r;
          phy_row[`ROW_SZ*second_act_position_r +: `ROW_SZ]                        = s2_dst_r;
          act                                                                      = 1'b1;     
        end      
        
        if (first_act_position_r < 5'd4) begin
          state_ns = COPY2_S;
          if (first_pre_position_r < 5'd4) begin
            state_ns = COPY3_S;
            if (second_act_position_r < 5'd4) begin
              state_ns = PRE2_S;
            end 
          end
        end     
      end // COPY1_S
      COPY2_S: begin
      // TODO do not forget to set act signal to 1
        
        // Three things can happen here:
        // 1 - the second pre command is scheduled
        // 2 - all two (pre-act) commands are scheduled
        
        if (first_pre_position_r < 5'd4) begin
          phy_cmd[`DEC_DDR_CMD_SZ*first_pre_position_r +: `DEC_DDR_CMD_SZ]        = `DDR_PRE;
          phy_bank[`BANK_SZ*first_pre_position_r +: `BANK_SZ]                     = s2_bank_r;
        end
        
        if (second_act_position_r < 5'd4) begin
          issue_cmd                                                                = `DDR_ACT;
          issue                                                                    = 1'b1;      
          phy_cmd[`DEC_DDR_CMD_SZ*second_act_position_r +: `DEC_DDR_CMD_SZ]        = `DDR_ACT;
          phy_bank[`BANK_SZ*second_act_position_r +: `BANK_SZ]                     = s2_bank_r;
          phy_row[`ROW_SZ*second_act_position_r +: `ROW_SZ]                        = s2_dst_r;
          act                                                                      = 1'b1;     
        end      
        
        if (first_pre_position_r < 5'd4) begin
          state_ns = COPY3_S;
          if (second_act_position_r < 5'd4) begin
            state_ns = PRE2_S;
          end 
        end
      end // COPY2_S
      
      COPY3_S: begin
      
        if (second_act_position_r < 5'd4) begin
          issue_cmd                                                                = `DDR_ACT;
          issue                                                                    = 1'b1;      
          phy_cmd[`DEC_DDR_CMD_SZ*second_act_position_r +: `DEC_DDR_CMD_SZ]        = `DDR_ACT;
          phy_bank[`BANK_SZ*second_act_position_r +: `BANK_SZ]                     = s2_bank_r;
          phy_row[`ROW_SZ*second_act_position_r +: `ROW_SZ]                        = s2_dst_r;
          act                                                                      = 1'b1;     
        end      
        
        if (second_act_position_r < 5'd4) begin
          state_ns = PRE2_S;
        end
      end // COPY3_S
      PRE2_S: begin
        issue_cmd = `DDR_PRE;
        if (valid) begin
          phy_cmd[`DEC_DDR_CMD_SZ*offset +: `DEC_DDR_CMD_SZ]        = issue_cmd;
          phy_bank[`BANK_SZ*offset +: `BANK_SZ]                     = s2_bank_r;
          issue                                                     = 1'b1;
          state_ns                                                  = IDLE_S;
          finish                                                    = 1'b1;
          pre                                                       = 1'b1;     
        end
      end     
    endcase
  end
  
   
  always @(posedge clk) begin
    if (rst) begin
      state_r             <=      IDLE_S;
      first_act_position_r  <=    0                                ;
      first_pre_position_r  <=    0                                ;
      second_act_position_r <=    0                                ;
    end else begin
      state_r             <=      state_ns;
      first_act_position_r  <= first_act_position_ns                                 ;
      first_pre_position_r  <= first_pre_position_ns                                 ;
      second_act_position_r <= second_act_position_ns                                ;      
    end
  end

endmodule