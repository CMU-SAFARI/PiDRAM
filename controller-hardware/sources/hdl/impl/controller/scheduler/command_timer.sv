`timescale 1ns / 1ps
`include "encoding.vh"
`include "parameters.vh"

/*
* This module contains the required set of counters
* to correctly satify both (i) manufacturer-recommended
* (ii) customized timing parameters
* The requestor (scheduler) simply inputs the command
* it wants to issue and its target bank, the command_timer
* will respond with the valid signal (sets it to HIGH if 
* command can be issued) 
* NOTE: This module considers custom command sequences 
* to be a single command: e.g., ACT->PRE->ACT is an "APA" command
*/
module command_timer(
  input                                       clk,
  input                                       rst,

  input         [`DEC_DDR_CMD_SZ-1:0]         cmd,
  input         [`BANK_SZ-1:0]                bank,
  
  input                                       issue,
  input         [1:0]                         new_issue_offset,
    
  // where this command should be issued from (suggestion)
  output        [1:0]                         offset,
  output        reg                           valid
);


  `define HIGH 1'b1;
  `define LOW 1'b0;
  
  reg   [1:0]   selected_offset;
  assign offset = selected_offset;
    
  reg           trcd_start  [7:0] , trp_start  [7:0] , tras_start   [7:0] , twr_start   [7:0] , twtr_start    , trc_start   [7:0], trrd_start    , tccd_start    , trfc_start    , trtp_start  [7:0];
  wire          trcd_done   [7:0] , trp_done   [7:0] , tras_done    [7:0] , twr_done    [7:0] , twtr_done     , trc_done    [7:0], trrd_done     , tccd_done     , trfc_done     , trtp_done   [7:0];
  reg   [1:0]   trcd_offset [7:0] , trp_offset [7:0] , tras_offset  [7:0] , twr_offset  [7:0] , twtr_offset   , trc_offset  [7:0], trrd_offset   , tccd_offset   , trfc_offset   , trtp_offset  [7:0];

  genvar g;
  generate
  
  for (g = 0 ; g < 8 ; g = g + 1) begin : gencounters
    timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRCD))
    trcd_ctr (.clk(clk), .rst(rst), .start(trcd_start[g]), .slot(new_issue_offset), .offset(trcd_offset[g]), .done(trcd_done[g]));
    
    timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRP))
    trp_ctr (.clk(clk), .rst(rst), .start(trp_start[g]), .slot(new_issue_offset), .offset(trp_offset[g]), .done(trp_done[g]));
    
    timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRAS))
    tras_ctr (.clk(clk), .rst(rst), .start(tras_start[g]), .slot(new_issue_offset), .offset(tras_offset[g]), .done(tras_done[g]));
    
    timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRTP))
    trtp_ctr (.clk(clk), .rst(rst), .start(trtp_start[g]), .slot(new_issue_offset), .offset(trtp_offset[g]), .done(trtp_done[g]));
    
    timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tWR))                                  
    twr_ctr (.clk(clk), .rst(rst), .start(twr_start[g]), .slot(new_issue_offset), .offset(twr_offset[g]), .done(twr_done[g]));
      
    timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRC))
    trc_ctr (.clk(clk), .rst(rst), .start(trc_start[g]), .slot(new_issue_offset), .offset(trc_offset[g]), .done(trc_done[g]));      
    
  end
  
  endgenerate
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRFC))
  trfc_ctr       (.clk(clk), .rst(rst), .start(trfc_start), .slot(new_issue_offset), .offset(trfc_offset), .done(trfc_done));  
    
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRRD))
  trrd_ctr (.clk(clk), .rst(rst), .start(trrd_start), .slot(new_issue_offset), .offset(trrd_offset), .done(trrd_done));
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tCCD))
  tccd_ctr (.clk(clk), .rst(rst), .start(tccd_start), .slot(new_issue_offset), .offset(tccd_offset), .done(tccd_done));
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tWTR))
  twtr_ctr (.clk(clk), .rst(rst), .start(twtr_start), .slot(new_issue_offset), .offset(twtr_offset), .done(twtr_done));  

  // Find which of the N offsets we should abide by in sending the next command 
    
  wire act_any_three = &trp_offset[bank] | &trc_offset[bank] | &trrd_offset | &trfc_offset;
  wire act_any_two = trp_offset[bank][1] | trc_offset[bank][1] | trrd_offset[1] | trfc_offset[1];
  wire act_any_one = trp_offset[bank][0] | trc_offset[bank][0] | trrd_offset[0] | trfc_offset[0];
  wire [1:0] act_greatest_offset = act_any_three ? 2'b11 : act_any_two ? 2'b10 : act_any_one ? 2'b01 : 2'b00;
  
  wire pre_any_three = &tras_offset[bank] | &twr_offset[bank] | &trtp_offset[bank] | &trrd_offset;
  wire pre_any_two = tras_offset[bank][1] | twr_offset[bank][1] | trtp_offset[bank][1] | trrd_offset[1];
  wire pre_any_one = tras_offset[bank][0] | twr_offset[bank][0] | trtp_offset[bank][0] | trrd_offset[0];
  wire [1:0] pre_greatest_offset = pre_any_three ? 2'b11 : pre_any_two ? 2'b10 : pre_any_one ? 2'b01 : 2'b00;
  
    
  wire read_any_three = &trcd_offset[bank] | &twtr_offset | &tccd_offset;
  wire read_any_two = trcd_offset[bank][1] | twtr_offset[1] | tccd_offset[1];
  wire read_any_one = trcd_offset[bank][0] | twtr_offset[0] | tccd_offset[0]; 
  wire [1:0] read_greatest_offset = read_any_three ? 2'b11 : read_any_two ? 2'b10 : read_any_one ? 2'b01 : 2'b00;
  
  wire write_any_three = &trcd_offset[bank] | &twtr_offset | &tccd_offset;
  wire write_any_two = trcd_offset[bank][1] | twtr_offset[1] | tccd_offset[1];
  wire write_any_one = trcd_offset[bank][0] | twtr_offset[0] | tccd_offset[0];
  wire [1:0] write_greatest_offset = write_any_three ? 2'b11 : write_any_two ? 2'b10 : write_any_one ? 2'b01 : 2'b00;

  wire all_bank_trp_done              = trp_done[0] & trp_done[1] & trp_done[2] & trp_done[3] & trp_done[4] & trp_done[5] & trp_done[6] & trp_done[7]; 
  wire all_bank_trtp_done             = trtp_done[0] & trtp_done[1] & trtp_done[2] & trtp_done[3] & trtp_done[4] & trtp_done[5] & trtp_done[6] & trtp_done[7];   
  wire all_bank_twr_done              = twr_done[0] & twr_done[1] & twr_done[2] & twr_done[3] & twr_done[4] & twr_done[5] & twr_done[6] & twr_done[7]; 
  wire all_bank_tras_done             = tras_done[0] & tras_done[1] & tras_done[2] & tras_done[3] & tras_done[4] & tras_done[5] & tras_done[6] & tras_done[7];;
  
  reg [1:0] all_bank_trp_offset, all_bank_trtp_offset, all_bank_twr_offset, all_bank_tras_offset;

  integer i;
  
  reg [1:0] trp_offset_partial [7:0];
  reg [1:0] trtp_offset_partial [7:0];
  reg [1:0] twr_offset_partial [7:0];
  reg [1:0] tras_offset_partial [7:0];
    
  always @* begin
    all_bank_trp_offset               =             2'b00;
    all_bank_trtp_offset              =             2'b00;
    all_bank_twr_offset               =             2'b00;
    all_bank_tras_offset              =             2'b00;
    
    trp_offset_partial[0]             =             trp_offset[0];
    trtp_offset_partial[0]            =             trtp_offset[0];
    twr_offset_partial[0]             =             twr_offset[0];
    tras_offset_partial[0]            =             tras_offset[0];
    for (i = 1 ; i < 8 ; i = i + 1) begin : all_bank_timing
      trp_offset_partial[i]           =             trp_offset_partial[i-1] > trp_offset[i] ? trp_offset_partial[i-1] : trp_offset[i];
      trtp_offset_partial[i]          =             trtp_offset_partial[i-1] > trtp_offset[i] ? trtp_offset_partial[i-1] : trtp_offset[i];
      twr_offset_partial[i]           =             twr_offset_partial[i-1] > twr_offset[i] ? twr_offset_partial[i-1] : twr_offset[i];
      tras_offset_partial[i]          =             tras_offset_partial[i-1] > tras_offset[i] ? tras_offset_partial[i-1] : tras_offset[i];
    end
    
    all_bank_trp_offset               =             trp_offset_partial[7];
    all_bank_trtp_offset              =             trtp_offset_partial[7];
    all_bank_twr_offset               =             twr_offset_partial[7];
    all_bank_tras_offset              =             tras_offset_partial[7];
  end
    
  wire pre_all_any_three = &all_bank_tras_offset | &all_bank_twr_offset | &all_bank_trtp_offset | &trrd_offset;
  wire pre_all_any_two = all_bank_tras_offset[1] | all_bank_twr_offset[1] | all_bank_trtp_offset[1] | trrd_offset[1];
  wire pre_all_any_one = all_bank_tras_offset[0] | all_bank_twr_offset[0] | all_bank_trtp_offset[0] | trrd_offset[0];
  wire [1:0] pre_all_greatest_offset = pre_all_any_three ? 2'b11 : pre_all_any_two ? 2'b10 : pre_all_any_one ? 2'b01 : 2'b00;

  always @* begin
    valid = `LOW;
    
    for (i = 0 ; i < 8 ; i = i+1) begin
      tras_start[i]                   =             `LOW;
      trcd_start[i]                   =             `LOW;
      trp_start[i]                    =             `LOW;
      twr_start[i]                    =             `LOW;
      trc_start[i]                    =             `LOW;
      trtp_start[i]                   =             `LOW; 
    end
    
    twtr_start                        =             `LOW;
    trrd_start                        =             `LOW;
    tccd_start                        =             `LOW;
    trfc_start                        =             `LOW;  
    
    selected_offset                   =             2'b00;
    
    case (cmd)
      `DDR_ACT: begin       
        if (trp_done[bank] && trc_done[bank] && trrd_done && trfc_done) begin 
          valid                       =             `HIGH;
        end
        if (issue) begin
          tras_start[bank]            =             `HIGH;
          trc_start[bank]             =             `HIGH;
          trcd_start[bank]            =             `HIGH;
          trrd_start                  =             `HIGH;
          selected_offset             =             act_greatest_offset;
        end // issue
      end // ACT       
      `DDR_PRE: begin
        if (tras_done[bank] && twr_done[bank] && trtp_done[bank] && trrd_done) 
          valid                       =             `HIGH;
        if (issue) begin
          trp_start[bank]             =             `HIGH;
          trrd_start                  =             `HIGH;
          selected_offset             =             pre_greatest_offset;

        end // issue
      end // PRE
      `DDR_READ: begin
        if (trcd_done[bank] && twtr_done && tccd_done)
          valid                       =             `HIGH;
        if (issue) begin
          trtp_start[bank]            =             `HIGH;
          tccd_start                  =             `HIGH;
          twtr_start                  =             `HIGH;
          selected_offset             =             read_greatest_offset;

        end // issue
      end // READ
      `DDR_WRITE: begin
        if (trcd_done[bank] && twtr_done && tccd_done) // use twtr for read to write latency as well
          valid                       =             `HIGH;
        if (issue) begin
          twr_start[bank]             =             `HIGH;
          twtr_start                  =             `HIGH;
          tccd_start                  =             `HIGH;
          selected_offset             =             write_greatest_offset;

        end // issue      
      end // write
      
      `DDR_ZQS: begin
        // Not Yet Implemented
      end
      `DDR_REF: begin
        if (all_bank_trp_done)
          valid                       =             `HIGH;
        if (issue) begin
          trfc_start                  =             `HIGH;
          trrd_start                  =             `HIGH; // probably not necessary
          selected_offset             =             all_bank_trp_offset;
        end
      end
      `DDR_PRE_ALL: begin
        if (all_bank_tras_done && all_bank_twr_done && all_bank_trtp_done && trrd_done)
          valid                       =             `HIGH;
        if (issue) begin
          trrd_start                  =             `HIGH;       
          for(i = 0 ; i < 8 ; i = i + 1) begin
            trp_start[i]              =             `HIGH;
          end         
          selected_offset             =             pre_all_greatest_offset;

        end
      end            
      `DDR_NOP: begin
        valid                         =             `HIGH;
      end
      default: begin
        valid                         =             `HIGH;
      end
    endcase
  
  end

endmodule
