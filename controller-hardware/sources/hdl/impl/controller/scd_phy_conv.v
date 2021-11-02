`timescale 1ns / 1ps
`include "encoding.vh"

module scd_phy_conv
  (
    input                                               clk,
    input                                               rst,
    
    input                                               init_calib_complete,
  
    // Scheduler <-> Converter
    input [`DEC_DDR_CMD_SZ*4-1:0]                       scd_cmd,
    input [`ROW_SZ*4-1:0]                               scd_row,
    input [`BANK_SZ*4-1:0]                              scd_bank,
    input [`COL_SZ*4-1:0]                               scd_col,

    // Converter <-> PHY Interface
    output [3:0]                                        mc_ras_n, // DDR Row access strobe
    output [3:0]                                        mc_cas_n, // DDR Column access strobe
    output [3:0]                                        mc_we_n,  // DDR Write enable
    output [4*14-1:0]                                   mc_address, // row address for activates / column address for read&writes
    output [11:0]                                       mc_bank, // bank address
    output [3:0]                                        mc_cs_n, // chip select, probably used to deselect in NOP cycles
    output                                              mc_reset_n, // Have no idea, probably need to keep HIGH
    output reg [1:0]                                    mc_odt, // Need some logic to drive this
    output [3:0]                                        mc_cke, // This should be HIGH all the time
    // AUX - For ODT and CKE assertion during reads and writes
    output [3:0]                                        mc_aux_out0, 
    output [3:0]                                        mc_aux_out1,
    output                                              mc_cmd_wren, // Enqueue new command
    output                                              mc_ctl_wren, // Enqueue new control singal
    output [2:0]                                        mc_cmd, // The command to enqueue
    output [1:0]                                        mc_cas_slot, // Which CAS slot we issued this command from 0-2
    output reg [5:0]                                    mc_data_offset,    
    output reg [5:0]                                    mc_data_offset_1,
    output reg [5:0]                                    mc_data_offset_2,
    output [1:0]                                        mc_rank_cnt,
    // Write
    output                                              mc_wrdata_en, // Asserted for DDR-WRITEs
    output                                              idle,
    input                                               phy_mc_ctl_full, // CTL interface is full
    input                                               phy_mc_cmd_full, // CMD interface is full
    input                                               phy_mc_data_full, // ?????????
    input [5:0]                                         calib_rd_data_offset_0,
    input [5:0]                                         calib_rd_data_offset_1,
    input [5:0]                                         calib_rd_data_offset_2,
    // Misc
    output                                              wd_fifo_rden   
  );

  localparam CWL = 5;

  reg mc_wrdata_en_ns;
  reg wrdata_en_s1, wrdata_en_s2;
  // Pipe these signals
  (* dont_touch = "true" *)reg [`DEC_DDR_CMD_SZ*4-1:0] scd_cmd_r; 
  (* dont_touch = "true" *)reg [`ROW_SZ*4-1:0]         scd_row_r; 
  (* dont_touch = "true" *)reg [`BANK_SZ*4-1:0]        scd_bank_r;
  (* dont_touch = "true" *)reg [`COL_SZ*4-1:0]         scd_col_r;                             
  reg [1:0] mc_odt_r, mc_odt_ns; // Needs to be HI for two consecutive cycles after each WRITE
  reg [2:0] mc_cmd_int;
  assign    mc_cmd = mc_cmd_int;
          
          
  always @(posedge clk) begin
    wrdata_en_s1  <= mc_wrdata_en_ns;
    wrdata_en_s2  <= wrdata_en_s1;
    scd_cmd_r     <= scd_cmd;
    scd_row_r     <= scd_row;
    scd_bank_r    <= scd_bank;
    scd_col_r     <= scd_col;
    mc_odt_r      <= mc_odt_ns;
  end

  wire [1:0] cas_offset    = scd_cmd_r[`DEC_DDR_CMD_SZ + 3] | scd_cmd_r[`DEC_DDR_CMD_SZ + 2] ?
                              2'b01 : 2'b11;
  // TODO set ODT and wrdata_en correctly
  assign wd_fifo_rden = wrdata_en_s1;
  assign mc_wrdata_en = wrdata_en_s2;
  assign mc_reset_n   = 1'b1;
  assign mc_cke       = {4{1'b1}}; 
  assign mc_aux_out0  = 3'b0;
  assign mc_aux_out1  = 3'b0;
  assign idle         = 1'b0;
  assign mc_cmd_wren  = init_calib_complete;
  assign mc_ctl_wren  = init_calib_complete;
  assign mc_cas_slot  = cas_offset;
  assign mc_rank_cnt  = 2'b0;
  
  genvar cmd_off;
  generate
    for(cmd_off = 0 ; cmd_off < 4 ; cmd_off = cmd_off + 1) begin: for_conv
      assign mc_cs_n[cmd_off]   = scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ +: `DEC_DDR_CMD_SZ] == 0;   // NOP
      assign mc_ras_n[cmd_off]  = scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ + 2] |  // READ
                                      scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ + 3] |  // WRITE
                                      scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ + 4];   // ZQS
      assign mc_cas_n[cmd_off]  = scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ] |  // ACT
                                      scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ + 1] |  // PRE
                                      scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ + 6] |  // PRE-ALL
                                      scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ + 4];   // ZQS
      assign mc_we_n[cmd_off]   = scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ] |  // ACT
                                      scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ + 2] |  // READ
                                      scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ + 5];   // REF
      assign mc_bank            = scd_bank_r;
      assign mc_address[cmd_off*`ROW_SZ +: `ROW_SZ] = 
            (scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ + 2] |  // READ or WRITE
            scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ + 3]) ? 
            scd_col_r[cmd_off*`COL_SZ+:`COL_SZ]: // column address if read&write
            scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ] ?
            scd_row_r[cmd_off*`ROW_SZ+:`ROW_SZ] :// row address 
            scd_cmd_r[cmd_off*`DEC_DDR_CMD_SZ + 6] ?
            14'b00_0100_0000_0000 : 14'b0; // all zeros if PRE - 10th bit will precharge all banks
    end
  endgenerate

  always @* begin
    mc_odt          = mc_odt_r;
    mc_odt_ns       = 2'b0;
    mc_wrdata_en_ns = 1'b0;
    mc_cmd_int      = 0;
    if(scd_cmd_r[3] | scd_cmd_r[`DEC_DDR_CMD_SZ + 3] 
      | scd_cmd_r[2*`DEC_DDR_CMD_SZ + 3] 
      | scd_cmd_r[3*`DEC_DDR_CMD_SZ + 3]) begin// WRITE
      mc_cmd_int        = 3'b001;
      mc_data_offset    = CWL + 2'b10 + 1'b1;
      mc_data_offset_1  = CWL + 2'b10 + 1'b1;
      mc_data_offset_2  = CWL + 2'b10 + 1'b1;
      mc_odt_ns         = 2'b01;
      mc_odt            = 2'b01;
      mc_wrdata_en_ns   = 1'b1;
    end
    else if(scd_cmd_r[2] | scd_cmd_r[`DEC_DDR_CMD_SZ + 2] 
      | scd_cmd_r[2*`DEC_DDR_CMD_SZ + 2] 
      | scd_cmd_r[3*`DEC_DDR_CMD_SZ + 2]) begin// READ
      mc_cmd_int        = 3'b011;
      mc_data_offset    = calib_rd_data_offset_0[5:0];
      mc_data_offset_1  = calib_rd_data_offset_1[5:0];
      mc_data_offset_2  = calib_rd_data_offset_2[5:0];
    end  
    else begin
      mc_cmd_int        = 3'b100;
      mc_data_offset    = 6'b0;
      mc_data_offset_1  = 6'b0;
      mc_data_offset_2  = 6'b0;
    end
  end

endmodule