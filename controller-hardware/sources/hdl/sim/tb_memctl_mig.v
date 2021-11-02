`timescale 1ns / 1ps

//*****************************************************************************
// (c) Copyright 2009 - 2010 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor             : Xilinx
// \   \   \/     Version            : 4.0
//  \   \         Application        : MIG
//  /   /         Filename           : sim_tb_top.v
// /___/   /\     Date Last Modified : $Date: 2011/06/07 13:45:16 $
// \   \  /  \    Date Created       : Tue Sept 21 2010
//  \___\/\___\
//
// Device           : 7 Series
// Design Name      : DDR3 SDRAM
// Purpose          :
//                   Top-level testbench for testing DDR3.
//                   Instantiates:
//                     1. IP_TOP (top-level representing FPGA, contains core,
//                        clocking, built-in testbench/memory checker and other
//                        support structures)
//                     2. DDR3 Memory
//                     3. Miscellaneous clock generation and reset logic
//                     4. For ECC ON case inserts error on LSB bit
//                        of data from DRAM to FPGA.
// Reference        :
// Revision History :
//*****************************************************************************

`timescale 1ps/100fs

module tb_memctl_mig;

   //***************************************************************************
   // The following parameters refer to width of various ports
   //***************************************************************************
   parameter COL_WIDTH             = 10;
                                     // # of memory Column Address bits.
   parameter CS_WIDTH              = 1;
                                     // # of unique CS outputs to memory.
   parameter DM_WIDTH              = 8;
                                     // # of DM (data mask)
   parameter DQ_WIDTH              = 64;
                                     // # of DQ (data)
   parameter DQS_WIDTH             = 8;
   parameter DQS_CNT_WIDTH         = 3;
                                     // = ceil(log2(DQS_WIDTH))
   parameter DRAM_WIDTH            = 8;
                                     // # of DQ per DQS
   parameter ECC                   = "OFF";
   parameter RANKS                 = 1;
                                     // # of Ranks.
   parameter ODT_WIDTH             = 1;
                                     // # of ODT outputs to memory.
   parameter ROW_WIDTH             = 14;
                                     // # of memory Row Address bits.
   parameter ADDR_WIDTH            = 28;
                                     // # = RANK_WIDTH + BANK_WIDTH
                                     //     + ROW_WIDTH + COL_WIDTH;
                                     // Chip Select is always tied to low for
                                     // single rank devices
   //***************************************************************************
   // The following parameters are mode register settings
   //***************************************************************************
   parameter BURST_MODE            = "8";
                                     // DDR3 SDRAM:
                                     // Burst Length (Mode Register 0).
                                     // # = "8", "4", "OTF".
                                     // DDR2 SDRAM:
                                     // Burst Length (Mode Register).
                                     // # = "8", "4".
   parameter CA_MIRROR             = "OFF";
                                     // C/A mirror opt for DDR3 dual rank
   
   //***************************************************************************
   // The following parameters are multiplier and divisor factors for PLLE2.
   // Based on the selected design frequency these parameters vary.
   //***************************************************************************
   parameter CLKIN_PERIOD          = 5000;
                                     // Input Clock Period


   //***************************************************************************
   // Simulation parameters
   //***************************************************************************
   parameter SIM_BYPASS_INIT_CAL   = "FAST";
                                     // # = "SIM_INIT_CAL_FULL" -  Complete
                                     //              memory init &
                                     //              calibration sequence
                                     // # = "SKIP" - Not supported
                                     // # = "FAST" - Complete memory init & use
                                     //              abbreviated calib sequence

   //***************************************************************************
   // IODELAY and PHY related parameters
   //***************************************************************************
   parameter TCQ                   = 100;
   //***************************************************************************
   // IODELAY and PHY related parameters
   //***************************************************************************
   parameter RST_ACT_LOW           = 0;
                                     // =1 for active low reset,
                                     // =0 for active high.

   //***************************************************************************
   // Referece clock frequency parameters
   //***************************************************************************
   parameter REFCLK_FREQ           = 200.0;
                                     // IODELAYCTRL reference clock frequency
   //***************************************************************************
   // System clock frequency parameters
   //***************************************************************************
   parameter tCK                   = 2500;
                                     // memory tCK paramter.
                     // # = Clock Period in pS.
   parameter nCK_PER_CLK           = 4;
                                     // # of memory CKs per fabric CLK

   

   //***************************************************************************
   // Debug and Internal parameters
   //***************************************************************************
   parameter DEBUG_PORT            = "OFF";
                                     // # = "ON" Enable debug signals/controls.
                                     //   = "OFF" Disable debug signals/controls.
   //***************************************************************************
   // Debug and Internal parameters
   //***************************************************************************
   parameter DRAM_TYPE             = "DDR3";

    

  //**************************************************************************//
  // Local parameters Declarations
  //**************************************************************************//

  localparam real TPROP_DQS          = 0.00;
                                       // Delay for DQS signal during Write Operation
  localparam real TPROP_DQS_RD       = 0.00;
                       // Delay for DQS signal during Read Operation
  localparam real TPROP_PCB_CTRL     = 0.00;
                       // Delay for Address and Ctrl signals
  localparam real TPROP_PCB_DATA     = 0.00;
                       // Delay for data signal during Write operation
  localparam real TPROP_PCB_DATA_RD  = 0.00;
                       // Delay for data signal during Read operation

  localparam MEMORY_WIDTH            = 8;
  localparam NUM_COMP                = DQ_WIDTH/MEMORY_WIDTH;
  localparam ECC_TEST 		   	= "OFF" ;
  localparam ERR_INSERT = (ECC_TEST == "ON") ? "OFF" : ECC ;
  

  localparam real REFCLK_PERIOD = (1000000.0/(2*REFCLK_FREQ));
  localparam RESET_PERIOD = 200000; //in pSec  
  localparam real SYSCLK_PERIOD = tCK;
    
    

  //**************************************************************************//
  // Wire Declarations
  //**************************************************************************//
  reg                                sys_rst_n;
  wire                               sys_rst;


  reg                     sys_clk_i;
  wire                               sys_clk_p;
  wire                               sys_clk_n;
    

  reg clk_ref_i;

  
  wire                               ddr3_reset_n;
  wire [DQ_WIDTH-1:0]                ddr3_dq_fpga;
  wire [DQS_WIDTH-1:0]               ddr3_dqs_p_fpga;
  wire [DQS_WIDTH-1:0]               ddr3_dqs_n_fpga;
  wire [ROW_WIDTH-1:0]               ddr3_addr_fpga;
  wire [3-1:0]              ddr3_ba_fpga;
  wire                               ddr3_ras_n_fpga;
  wire                               ddr3_cas_n_fpga;
  wire                               ddr3_we_n_fpga;
  wire [1-1:0]               ddr3_cke_fpga;
  wire [1-1:0]                ddr3_ck_p_fpga;
  wire [1-1:0]                ddr3_ck_n_fpga;
    
  
  wire                               init_calib_complete;
  wire                               tg_compare_error;
  wire [(CS_WIDTH*1)-1:0] ddr3_cs_n_fpga;
    
  wire [DM_WIDTH-1:0]                ddr3_dm_fpga;
    
  wire [ODT_WIDTH-1:0]               ddr3_odt_fpga;
    
  
  reg [(CS_WIDTH*1)-1:0] ddr3_cs_n_sdram_tmp;
    
  reg [DM_WIDTH-1:0]                 ddr3_dm_sdram_tmp;
    
  reg [ODT_WIDTH-1:0]                ddr3_odt_sdram_tmp;
    

  
  wire [DQ_WIDTH-1:0]                ddr3_dq_sdram;
  reg [ROW_WIDTH-1:0]                ddr3_addr_sdram [0:1];
  reg [3-1:0]               ddr3_ba_sdram [0:1];
  reg                                ddr3_ras_n_sdram;
  reg                                ddr3_cas_n_sdram;
  reg                                ddr3_we_n_sdram;
  wire [(CS_WIDTH*1)-1:0] ddr3_cs_n_sdram;
  wire [ODT_WIDTH-1:0]               ddr3_odt_sdram;
  reg [1-1:0]                ddr3_cke_sdram;
  wire [DM_WIDTH-1:0]                ddr3_dm_sdram;
  wire [DQS_WIDTH-1:0]               ddr3_dqs_p_sdram;
  wire [DQS_WIDTH-1:0]               ddr3_dqs_n_sdram;
  reg [1-1:0]                 ddr3_ck_p_sdram;
  reg [1-1:0]                 ddr3_ck_n_sdram;
  
    

//**************************************************************************//

  //**************************************************************************//
  // Reset Generation
  //**************************************************************************//
  initial begin
    sys_rst_n = 1'b0;
    #RESET_PERIOD
      sys_rst_n = 1'b1;
   end

   assign sys_rst = RST_ACT_LOW ? sys_rst_n : ~sys_rst_n;

  //**************************************************************************//
  // Clock Generation
  //**************************************************************************//

  initial
    sys_clk_i = 1'b0;
  always
    sys_clk_i = #(CLKIN_PERIOD/2.0) ~sys_clk_i;

  assign sys_clk_p = sys_clk_i;
  assign sys_clk_n = ~sys_clk_i;

  initial
    clk_ref_i = 1'b0;
  always
    clk_ref_i = #REFCLK_PERIOD ~clk_ref_i;




  always @( * ) begin
    ddr3_ck_p_sdram      <=  #(TPROP_PCB_CTRL) ddr3_ck_p_fpga;
    ddr3_ck_n_sdram      <=  #(TPROP_PCB_CTRL) ddr3_ck_n_fpga;
    ddr3_addr_sdram[0]   <=  #(TPROP_PCB_CTRL) ddr3_addr_fpga;
    ddr3_addr_sdram[1]   <=  #(TPROP_PCB_CTRL) (CA_MIRROR == "ON") ?
                                                 {ddr3_addr_fpga[ROW_WIDTH-1:9],
                                                  ddr3_addr_fpga[7], ddr3_addr_fpga[8],
                                                  ddr3_addr_fpga[5], ddr3_addr_fpga[6],
                                                  ddr3_addr_fpga[3], ddr3_addr_fpga[4],
                                                  ddr3_addr_fpga[2:0]} :
                                                 ddr3_addr_fpga;
    ddr3_ba_sdram[0]     <=  #(TPROP_PCB_CTRL) ddr3_ba_fpga;
    ddr3_ba_sdram[1]     <=  #(TPROP_PCB_CTRL) (CA_MIRROR == "ON") ?
                                                 {ddr3_ba_fpga[3-1:2],
                                                  ddr3_ba_fpga[0],
                                                  ddr3_ba_fpga[1]} :
                                                 ddr3_ba_fpga;
    ddr3_ras_n_sdram     <=  #(TPROP_PCB_CTRL) ddr3_ras_n_fpga;
    ddr3_cas_n_sdram     <=  #(TPROP_PCB_CTRL) ddr3_cas_n_fpga;
    ddr3_we_n_sdram      <=  #(TPROP_PCB_CTRL) ddr3_we_n_fpga;
    ddr3_cke_sdram       <=  #(TPROP_PCB_CTRL) ddr3_cke_fpga;
  end
    

  always @( * )
    ddr3_cs_n_sdram_tmp   <=  #(TPROP_PCB_CTRL) ddr3_cs_n_fpga;
  assign ddr3_cs_n_sdram =  ddr3_cs_n_sdram_tmp;
    

  always @( * )
    ddr3_dm_sdram_tmp <=  #(TPROP_PCB_DATA) ddr3_dm_fpga;//DM signal generation
  assign ddr3_dm_sdram = ddr3_dm_sdram_tmp;
    

  always @( * )
    ddr3_odt_sdram_tmp  <=  #(TPROP_PCB_CTRL) ddr3_odt_fpga;
  assign ddr3_odt_sdram =  ddr3_odt_sdram_tmp;
    

// Controlling the bi-directional BUS

  genvar dqwd;
  generate
    for (dqwd = 1;dqwd < DQ_WIDTH;dqwd = dqwd+1) begin : dq_delay
      WireDelay #
       (
        .Delay_g    (TPROP_PCB_DATA),
        .Delay_rd   (TPROP_PCB_DATA_RD),
        .ERR_INSERT ("OFF")
       )
      u_delay_dq
       (
        .A             (ddr3_dq_fpga[dqwd]),
        .B             (ddr3_dq_sdram[dqwd]),
        .reset         (sys_rst_n),
        .phy_init_done (init_calib_complete)
       );
    end
    // For ECC ON case error is inserted on LSB bit from DRAM to FPGA
          WireDelay #
       (
        .Delay_g    (TPROP_PCB_DATA),
        .Delay_rd   (TPROP_PCB_DATA_RD),
        .ERR_INSERT (ERR_INSERT)
       )
      u_delay_dq_0
       (
        .A             (ddr3_dq_fpga[0]),
        .B             (ddr3_dq_sdram[0]),
        .reset         (sys_rst_n),
        .phy_init_done (init_calib_complete)
       );
  endgenerate

  genvar dqswd;
  generate
    for (dqswd = 0;dqswd < DQS_WIDTH;dqswd = dqswd+1) begin : dqs_delay
      WireDelay #
       (
        .Delay_g    (TPROP_DQS),
        .Delay_rd   (TPROP_DQS_RD),
        .ERR_INSERT ("OFF")
       )
      u_delay_dqs_p
       (
        .A             (ddr3_dqs_p_fpga[dqswd]),
        .B             (ddr3_dqs_p_sdram[dqswd]),
        .reset         (sys_rst_n),
        .phy_init_done (init_calib_complete)
       );

      WireDelay #
       (
        .Delay_g    (TPROP_DQS),
        .Delay_rd   (TPROP_DQS_RD),
        .ERR_INSERT ("OFF")
       )
      u_delay_dqs_n
       (
        .A             (ddr3_dqs_n_fpga[dqswd]),
        .B             (ddr3_dqs_n_sdram[dqswd]),
        .reset         (sys_rst_n),
        .phy_init_done (init_calib_complete)
       );
    end
  endgenerate
  
  localparam BANK_WIDTH = 3;
  localparam nCS_PER_RANK = 1;
  localparam CWL = 5;
   
  wire ui_clk, ui_rst;
   
  // MC <-> PHY Interface
  wire [nCK_PER_CLK-1:0]            mc_ras_n; // DDR Row access strobe
  wire [nCK_PER_CLK-1:0]            mc_cas_n; // DDR Column access strobe
  wire [nCK_PER_CLK-1:0]            mc_we_n;  // DDR Write enable
  wire [nCK_PER_CLK*ROW_WIDTH-1:0]  mc_address; // row address for activates / column address for read&writes
  wire [nCK_PER_CLK*BANK_WIDTH-1:0] mc_bank; // bank address
  wire [CS_WIDTH*nCS_PER_RANK*nCK_PER_CLK-1:0] mc_cs_n; // chip select, probably used to deselect in NOP cycles
  wire                              mc_reset_n; // Have no idea, probably need to keep HIGH
  wire [1:0]                        mc_odt; // Need some logic to drive this
  wire [nCK_PER_CLK-1:0]            mc_cke; // This should be HIGH all the time
  wire [3:0]                        mc_aux_out0; 
  wire [3:0]                        mc_aux_out1;
  wire                              mc_cmd_wren;       // Enqueue new command
  wire                              mc_ctl_wren;       // Enqueue new control singal
  wire [2:0]                        mc_cmd;            // The command to enqueue
  wire [1:0]                        mc_cas_slot;       // Which CAS slot we issued this command from 0-2
  wire [5:0]                        mc_data_offset;    
  wire [5:0]                        mc_data_offset_1;
  wire [5:0]                        mc_data_offset_2;
  wire [1:0]                        mc_rank_cnt;
  // Write
  wire                              mc_wrdata_en;                // Asserted for DDR-WRITEs
  wire  [2*nCK_PER_CLK*DQ_WIDTH-1:0]      mc_wrdata;
  wire  [2*nCK_PER_CLK*(DQ_WIDTH/8)-1:0]  mc_wrdata_mask; // Should be 0xff if we don't want to mask out bits
  wire                              idle;
  wire                              phy_mc_ctl_full;     // CTL interface is full
  wire                              phy_mc_cmd_full;     // CMD interface is full
  wire                              phy_mc_data_full;    // ?????????
  wire [6*RANKS-1:0]                calib_rd_data_offset_0;
  wire [6*RANKS-1:0]                calib_rd_data_offset_1;
  wire [6*RANKS-1:0]                calib_rd_data_offset_2;
  wire                              phy_rddata_valid;    // Next cycle will have a valid read
  wire [2*nCK_PER_CLK*DQ_WIDTH-1:0] phy_rd_data;           
   
  memctl_mig #
  (
    .SIMULATION("TRUE"), 
    .SIM_BYPASS_INIT_CAL(SIM_BYPASS_INIT_CAL)
  ) 
  phy
  (
    .ddr3_dq              (ddr3_dq_fpga),
    .ddr3_dqs_n           (ddr3_dqs_n_fpga),
    .ddr3_dqs_p           (ddr3_dqs_p_fpga),
    
    .ddr3_addr            (ddr3_addr_fpga),
    .ddr3_ba              (ddr3_ba_fpga),
    .ddr3_ras_n           (ddr3_ras_n_fpga),
    .ddr3_cas_n           (ddr3_cas_n_fpga),
    .ddr3_we_n            (ddr3_we_n_fpga),
    .ddr3_reset_n         (ddr3_reset_n),
    .ddr3_ck_p            (ddr3_ck_p_fpga),
    .ddr3_ck_n            (ddr3_ck_n_fpga),
    .ddr3_cke             (ddr3_cke_fpga),
    .ddr3_cs_n            (ddr3_cs_n_fpga),
    
    .ddr3_dm              (ddr3_dm_fpga),
    
    .ddr3_odt             (ddr3_odt_fpga),
    
    
    .mc_ras_n(mc_ras_n),
    .mc_cas_n(mc_cas_n),
    .mc_we_n(mc_we_n),
    .mc_address(mc_address),
    .mc_bank(mc_bank),
    .mc_cs_n(mc_cs_n),
    .mc_reset_n(mc_reset_n),
    .mc_odt(mc_odt),
    .mc_cke(mc_cke),
    
    .mc_aux_out0(mc_aux_out0),
    .mc_aux_out1(mc_aux_out1),
    .mc_cmd_wren(mc_cmd_wren),
    .mc_ctl_wren(mc_ctl_wren),
    .mc_cmd(mc_cmd),
    .mc_cas_slot(mc_cas_slot),
    .mc_data_offset(mc_data_offset),
    .mc_data_offset_1(mc_data_offset_1),
    .mc_data_offset_2(mc_data_offset_2),
    .mc_rank_cnt(mc_rank_cnt),
    
    .mc_wrdata_en(mc_wrdata_en),
    .mc_wrdata(mc_wrdata),
    .mc_wrdata_mask(mc_wrdata_mask),
    .idle(idle),
    .phy_mc_ctl_full(phy_mc_ctl_full),
    .phy_mc_cmd_full(phy_mc_cmd_full),
    .phy_mc_data_full(phy_mc_data_full),
    .calib_rd_data_offset_0(calib_rd_data_offset_0),
    .calib_rd_data_offset_1(calib_rd_data_offset_1),
    .calib_rd_data_offset_2(calib_rd_data_offset_2),
    .phy_rddata_valid(phy_rddata_valid),
    .phy_rd_data(phy_rd_data),
    
    
    .sys_clk_p(sys_clk_p),
    .sys_clk_n(sys_clk_n),
    
    .ui_clk(ui_clk),
    .ui_clk_sync_rst(ui_rst),
    
    .init_calib_complete(init_calib_complete),
    
    .sys_rst(sys_rst)
  );
  
  //*********************************//
  // Brand new memory controller
  //*********************************//
  poc_ctrlr #(
      .nCK_PER_CLK(nCK_PER_CLK),
      .ROW_WIDTH(ROW_WIDTH),
      .BANK_WIDTH(BANK_WIDTH),
      .CS_WIDTH(CS_WIDTH),
      .nCS_PER_RANK(nCS_PER_RANK),
      .DQ_WIDTH(DQ_WIDTH),
      .RANKS(RANKS),
      .CWL(CWL)
    )
    basic_sm
    (
      .clk(ui_clk),
      .rst(ui_rst),
      .init_calib_complete(init_calib_complete),
    
      .mc_ras_n(mc_ras_n),
      .mc_cas_n(mc_cas_n),
      .mc_we_n(mc_we_n),
      .mc_address(mc_address),
      .mc_bank(mc_bank),
      .mc_cs_n(mc_cs_n),
      .mc_reset_n(mc_reset_n),
      .mc_odt(mc_odt),
      .mc_cke(mc_cke),
      
      .mc_aux_out0(mc_aux_out0),
      .mc_aux_out1(mc_aux_out1),
      .mc_cmd_wren(mc_cmd_wren),
      .mc_ctl_wren(mc_ctl_wren),
      .mc_cmd(mc_cmd),
      .mc_cas_slot(mc_cas_slot),
      .mc_data_offset(mc_data_offset),
      .mc_data_offset_1(mc_data_offset_1),
      .mc_data_offset_2(mc_data_offset_2),
      .mc_rank_cnt(mc_rank_cnt),
      
      .mc_wrdata_en(mc_wrdata_en),
      .mc_wrdata(mc_wrdata),
      .mc_wrdata_mask(mc_wrdata_mask),
      .idle(idle),
      .phy_mc_ctl_full(phy_mc_ctl_full),
      .phy_mc_cmd_full(phy_mc_cmd_full),
      .phy_mc_data_full(phy_mc_data_full),
      .calib_rd_data_offset_0(calib_rd_data_offset_0),
      .calib_rd_data_offset_1(calib_rd_data_offset_1),
      .calib_rd_data_offset_2(calib_rd_data_offset_2),
      .phy_rddata_valid(phy_rddata_valid),
      .phy_rd_data(phy_rd_data)          
    );
  //**************************************************************************//
  // Memory Models instantiations
  //**************************************************************************//

  genvar r,i;
  generate
    for (r = 0; r < CS_WIDTH; r = r + 1) begin: mem_rnk
      for (i = 0; i < NUM_COMP; i = i + 1) begin: gen_mem
        ddr3_model u_comp_ddr3
          (
           .rst_n   (ddr3_reset_n),
           .ck      (ddr3_ck_p_sdram[(i*MEMORY_WIDTH)/72]),
           .ck_n    (ddr3_ck_n_sdram[(i*MEMORY_WIDTH)/72]),
           .cke     (ddr3_cke_sdram[((i*MEMORY_WIDTH)/72)+(1*r)]),
           .cs_n    (ddr3_cs_n_sdram[((i*MEMORY_WIDTH)/72)+(1*r)]),
           .ras_n   (ddr3_ras_n_sdram),
           .cas_n   (ddr3_cas_n_sdram),
           .we_n    (ddr3_we_n_sdram),
           .dm_tdqs (ddr3_dm_sdram[i]),
           .ba      (ddr3_ba_sdram[r]),
           .addr    (ddr3_addr_sdram[r]),
           .dq      (ddr3_dq_sdram[MEMORY_WIDTH*(i+1)-1:MEMORY_WIDTH*(i)]),
           .dqs     (ddr3_dqs_p_sdram[i]),
           .dqs_n   (ddr3_dqs_n_sdram[i]),
           .tdqs_n  (),
           .odt     (ddr3_odt_sdram[((i*MEMORY_WIDTH)/72)+(1*r)])
           );
      end
    end
  endgenerate
       
endmodule
