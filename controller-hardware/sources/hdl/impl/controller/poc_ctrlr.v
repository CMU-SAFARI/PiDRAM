`timescale 1ns / 1ps

module poc_ctrlr #(
    parameter nCK_PER_CLK = 4,
    parameter ROW_WIDTH = 14,
    parameter BANK_WIDTH = 2,
    parameter CS_WIDTH = 1,
    parameter nCS_PER_RANK = 1,
    parameter DQ_WIDTH = 64,
    parameter RANKS = 1,
    parameter CWL = 5
  )
  (
    input clk,
    input rst,
    input init_calib_complete,
  
    // MC <-> PHY Interface
    output reg [nCK_PER_CLK-1:0]                        mc_ras_n, // DDR Row access strobe
    output reg [nCK_PER_CLK-1:0]                        mc_cas_n, // DDR Column access strobe
    output reg [nCK_PER_CLK-1:0]                        mc_we_n,  // DDR Write enable
    output reg [nCK_PER_CLK*ROW_WIDTH-1:0]              mc_address, // row address for activates / column address for read&writes
    output reg [nCK_PER_CLK*BANK_WIDTH-1:0]             mc_bank, // bank address
    output reg [CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK-1:0]  mc_cs_n, // chip select, probably used to deselect in NOP cycles
    output                                              mc_reset_n, // Have no idea, probably need to keep HIGH
    output reg [1:0]                                    mc_odt, // Need some logic to drive this
    output [nCK_PER_CLK-1:0]                            mc_cke, // This should be HIGH all the time
    // AUX - For ODT and CKE assertion during reads and writes
    output [3:0]                                        mc_aux_out0, 
    output [3:0]                                        mc_aux_out1,
    output reg                                          mc_cmd_wren, // Enqueue new command
    output reg                                          mc_ctl_wren, // Enqueue new control singal
    output reg [2:0]                                    mc_cmd, // The command to enqueue
    output reg [1:0]                                    mc_cas_slot, // Which CAS slot we issued this command from 0-2
    output reg [5:0]                                    mc_data_offset,    
    output reg [5:0]                                    mc_data_offset_1,
    output reg [5:0]                                    mc_data_offset_2,
    output reg [1:0]                                    mc_rank_cnt,
    // Write
    output                                              mc_wrdata_en, // Asserted for DDR-WRITEs
    output [2*nCK_PER_CLK*DQ_WIDTH-1:0]                 mc_wrdata,
    output [2*nCK_PER_CLK*(DQ_WIDTH/8)-1:0]             mc_wrdata_mask, // Should be 0xff if we don't want to mask out bits
    output                                              idle,
    input                                               phy_mc_ctl_full, // CTL interface is full
    input                                               phy_mc_cmd_full, // CMD interface is full
    input                                               phy_mc_data_full, // ?????????
    input [6*RANKS-1:0]                                 calib_rd_data_offset_0,
    input [6*RANKS-1:0]                                 calib_rd_data_offset_1,
    input [6*RANKS-1:0]                                 calib_rd_data_offset_2,
    input                                               phy_rddata_valid, // Next cycle will have a valid read
    input [2*nCK_PER_CLK*DQ_WIDTH-1:0]                  phy_rd_data     
  );
  
  localparam PRE1_S   = 1;
  localparam ACT1_S   = 2;
  localparam WRITE_S  = 3; 
  localparam PRE2_S   = 4;
  localparam COPY1_S  = 5;
  localparam COPY2_S  = 6;
  localparam COPY3_S  = 7;
  localparam PRE3_S   = 8;
  localparam ACT2_S   = 9;
  localparam READ_S   = 10;
  localparam PRE4_S   = 11;
  localparam END_S    = 12;
  
  reg mc_wrdata_en_ns;
  reg mc_wrdata_en_soon1;
  reg mc_wrdata_en_soon2;
  
  assign mc_wrdata_en = mc_wrdata_en_soon2;
  
  reg[3:0] state_r, state_ns;
  reg[6:0] rw_ctr_r, rw_ctr_ns;
  reg[3:0] wait_ctr_r, wait_ctr_ns;
  reg[1:0] mc_odt_r, mc_odt_ns; // Needs to be asserted for two consecutive cycles per WRITE
  
  wire[511:0] wr_data = {256'h00_01_02_03_04_05_06_07_08_09_0a_0b_0c_0d_0e_0f_10_11_12_13_14_15_16_17_18_19_1a_1b_1c_1d_1e_1f,
                        256'h20_21_22_23_24_25_26_27_28_29_2a_2b_2c_2d_2e_2f_30_31_32_33_34_35_36_37_38_39_3a_3b_3c_3d_3e_3f};
  
  always @* begin
    state_ns = state_r;
    rw_ctr_ns = rw_ctr_r;
    wait_ctr_ns = wait_ctr_r == 0 ? 0 : wait_ctr_r - 1;
    mc_odt_ns = 1'b0;
    // Default values for MC signals
    // --- DDR Signals ---
    mc_ras_n      = {nCK_PER_CLK{1'bX}};
    mc_cas_n      = {nCK_PER_CLK{1'bX}};
    mc_we_n       = {nCK_PER_CLK{1'bX}};
    mc_address    = {nCK_PER_CLK*ROW_WIDTH{1'b0}};
    mc_bank       = {nCK_PER_CLK*BANK_WIDTH{1'b0}};
    mc_cs_n       = {CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK{1'b1}};
    // --- Misc. control signals ---
    mc_odt            = mc_odt_r;
    mc_wrdata_en_ns   = 1'b0;
    mc_cmd            = 3'b100; // Non-data command: 0x04, WR: 0x01, RD: 0x03
    mc_cas_slot       = 2'b0;   // This SM only issues from the 0th slot
    mc_cmd_wren       = init_calib_complete;   // TODO: No idea what to do about these two signals
    mc_ctl_wren       = init_calib_complete;   // Xilinx UG: Generally always tied high so the PHY can receive data
    mc_cas_slot       = 2'b0;   // Which CAS slot we issued this command from 0-2
    // TODO do we need to consider CWL for below?
    mc_data_offset    = 6'b0;   // For non-CAS commands this should be 0 
    mc_data_offset_1  = 6'b0;    
    mc_data_offset_2  = 6'b0;
    mc_rank_cnt       = 2'b0;
    
    // This should start after calib
    if(init_calib_complete && (wait_ctr_r == 4'b0)) begin
      case(state_r)
        PRE1_S: begin 
          // PRE-ALL Encoding --
          // RAS: Lo CAS: Hi WE: Lo address[10]: HI
          mc_cs_n[0]      = 1'b0;
          mc_ras_n[0]     = 1'b0;
          mc_cas_n[0]     = 1'b1;
          mc_we_n[0]      = 1'b0;
          mc_address[10]  = 1'b1;
          
          state_ns        = ACT1_S;
          wait_ctr_ns     = 4'd5;
        end
        ACT1_S: begin
          // ACT Encoding --
          // RAS: Lo CAS: Hi WE: Hi address[10]: HI
          mc_cs_n[0]      = 1'b0;
          mc_ras_n[0]     = 1'b0;
          mc_cas_n[0]     = 1'b1;
          mc_we_n[0]      = 1'b1;  
                  
          state_ns        = WRITE_S;
          wait_ctr_ns     = 4'd5;
          // Write 128 times, filling a row
          rw_ctr_ns       = 7'b0;        
        end
        WRITE_S: begin
          mc_cs_n[1]          = 1'b0;
          mc_ras_n[1]         = 1'b1;
          mc_cas_n[1]         = 1'b0;
          mc_we_n[1]          = 1'b0;  
          mc_address[ROW_WIDTH+:ROW_WIDTH] = 
              (rw_ctr_r << 3);
              
          mc_wrdata_en_ns     = 1'b1;
          mc_data_offset      = CWL + 2'b10 + 1'b1;
          mc_data_offset_1    = CWL + 2'b10 + 1'b1;
          mc_data_offset_2    = CWL + 2'b10 + 1'b1;
          mc_odt_ns           = 2'b01;
          mc_odt              = 2'b01;
          mc_cmd              = 3'b001;
          
          rw_ctr_ns           = rw_ctr_r + 1;
          wait_ctr_ns         = 4'd1;
          if(&rw_ctr_r) begin
            state_ns          = PRE2_S;
            wait_ctr_ns       = 4'd5;
          end
        end
        PRE2_S: begin
          mc_cs_n[0]      = 1'b0;
          mc_ras_n[0]     = 1'b0;
          mc_cas_n[0]     = 1'b1;
          mc_we_n[0]      = 1'b0;
          
          state_ns        = COPY1_S;
          wait_ctr_ns     = 4'd5;        
        end
        COPY1_S: begin
          // Send an ACT
          mc_cs_n[0]      = 1'b0;
          mc_ras_n[0]     = 1'b0;
          mc_cas_n[0]     = 1'b1;
          mc_we_n[0]      = 1'b1;
          
          state_ns        = COPY2_S;
        end
        COPY2_S: begin
          // Send a PRE
          mc_cs_n[1]      = 1'b0;
          mc_ras_n[1]     = 1'b0;
          mc_cas_n[1]     = 1'b1;
          mc_we_n[1]      = 1'b0;
          state_ns        = COPY3_S;
          //wait_ctr_ns     = 4'd1;
        end
        COPY3_S: begin
          // Send another ACT
          // Copy data from row 0 to row 1
          mc_cs_n[2]      = 1'b0;
          mc_ras_n[2]     = 1'b0;
          mc_cas_n[2]     = 1'b1;
          mc_we_n[2]      = 1'b1;
          // Don't forget to change below
          // if we issue from another slot
          mc_address[ROW_WIDTH*2 +: ROW_WIDTH] = 
              14'b00_0000_0000_0001;
          wait_ctr_ns     = 4'd5;
          state_ns        = PRE3_S;
        end
        PRE3_S: begin
          mc_cs_n[0]      = 1'b0;
          mc_ras_n[0]     = 1'b0;
          mc_cas_n[0]     = 1'b1;
          mc_we_n[0]      = 1'b0;
          
          state_ns        = ACT2_S;
          wait_ctr_ns     = 4'd5;        
        end
        ACT2_S: begin
          mc_cs_n[0]      = 1'b0;
          mc_ras_n[0]     = 1'b0;
          mc_cas_n[0]     = 1'b1;
          mc_we_n[0]      = 1'b1;
          mc_address[0 +: ROW_WIDTH] = 
              14'b00_0000_0000_0001;
          wait_ctr_ns     = 4'd5;
          state_ns        = READ_S;      
        end
        READ_S: begin
          mc_data_offset      = calib_rd_data_offset_0[5:0];
          mc_data_offset_1    = calib_rd_data_offset_1[5:0];
          mc_data_offset_2    = calib_rd_data_offset_2[5:0];
          mc_cs_n[0]          = 1'b0;
          mc_ras_n[0]         = 1'b1;
          mc_cas_n[0]         = 1'b0;
          mc_we_n[0]          = 1'b1;  
          mc_address[ROW_WIDTH-1:0] = 
              (rw_ctr_r << 3);
          
          
          mc_cmd              = 3'b011;
          rw_ctr_ns           = rw_ctr_r + 1;
          wait_ctr_ns         = 4'd1;
          if(&rw_ctr_r) begin
            state_ns          = PRE4_S;
            wait_ctr_ns       = 4'd5;
          end      
        end
        PRE4_S: begin
          mc_cs_n[0]      = 1'b0;
          mc_ras_n[0]     = 1'b0;
          mc_cas_n[0]     = 1'b1;
          mc_we_n[0]      = 1'b0;
          state_ns        = END_S;
        end
        END_S: begin
          state_ns        = END_S;
        end
      endcase
    end
  end
  
  always @(posedge clk) begin
    if(rst) begin
      state_r     <= 4'b1;
      rw_ctr_r    <= 0;
      wait_ctr_r  <= 0;
      mc_odt_r    <= 0;
      mc_wrdata_en_soon1 <= 0;
      mc_wrdata_en_soon2 <= 0;
    end
    else begin
      mc_wrdata_en_soon1 <= mc_wrdata_en_ns;
      mc_wrdata_en_soon2 <= mc_wrdata_en_soon1;
      state_r     <= state_ns;
      rw_ctr_r    <= rw_ctr_ns;
      wait_ctr_r  <= wait_ctr_ns;
      mc_odt_r    <= mc_odt_ns;
    end
  end
  
  assign mc_reset_n   = 1'b1; // Have no idea, probably need to keep HIGH
  assign mc_cke       = {nCK_PER_CLK{1'b1}}; // This should be HIGH all the time
  // AUX - For ODT and CKE assertion during reads and writes
  assign mc_aux_out0  = 3'b0;
  assign mc_aux_out1  = 3'b0;
  assign idle         = 1'b0; // presumably, this SM is not going to be idle :)))
  
  assign mc_wrdata      = wr_data;
  assign mc_wrdata_mask = {2*nCK_PER_CLK*(DQ_WIDTH/8){1'b0}};
  
endmodule
