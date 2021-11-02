`timescale 1ns / 1ps


module memctl_sys_top(
    // Differential system clocks
    input                               sys_clk_p,
    input                               sys_clk_n,

    input                               sys_rst,

    output                              init_calib_complete,
    output                              ui_clk,
    output                              ui_rst,

    // Inouts
    inout [63:0]                        ddr3_dq_fpga,
    inout [7:0]                         ddr3_dqs_n_fpga,
    inout [7:0]                         ddr3_dqs_p_fpga,

    // Outputs
    output [13:0]                       ddr3_addr_fpga,
    output [2:0]                        ddr3_ba_fpga,
    output                              ddr3_ras_n_fpga,
    output                              ddr3_cas_n_fpga,
    output                              ddr3_we_n_fpga,
    output                              ddr3_reset_n_fpga,
    output                              ddr3_ck_p_fpga,
    output                              ddr3_ck_n_fpga,
    output [0:0]                        ddr3_cke_fpga,
    output [0:0]                        ddr3_cs_n_fpga,
    output [7:0]                        ddr3_dm_fpga,
    output [0:0]                        ddr3_odt_fpga,
   
    input                               MC_S_AXI_ACLK,
    input                               MC_S_AXI_ARESETN,
    (*dont_touch = "true"*)input [5:0]                         MC_S_AXI_AWID,
    (*dont_touch = "true"*)input [31:0]                        MC_S_AXI_AWADDR,
    (*dont_touch = "true"*)input [7:0]                         MC_S_AXI_AWLEN,
    (*dont_touch = "true"*)input [2:0]                         MC_S_AXI_AWSIZE,
    (*dont_touch = "true"*)input [1:0]                         MC_S_AXI_AWBURST,
    (*dont_touch = "true"*)input                               MC_S_AXI_AWLOCK,
    (*dont_touch = "true"*)input [3:0]                         MC_S_AXI_AWCACHE,
    (*dont_touch = "true"*)input [2:0]                         MC_S_AXI_AWPROT,
    (*dont_touch = "true"*)input [3:0]                         MC_S_AXI_AWQOS,
    (*dont_touch = "true"*)input                               MC_S_AXI_AWVALID,
    (*dont_touch = "true"*)output                              MC_S_AXI_AWREADY,
    (*dont_touch = "true"*)input [63:0]                        MC_S_AXI_WDATA,
    (*dont_touch = "true"*)input [7:0]                         MC_S_AXI_WSTRB,
    (*dont_touch = "true"*)input                               MC_S_AXI_WLAST,
    (*dont_touch = "true"*)input                               MC_S_AXI_WVALID,
    (*dont_touch = "true"*)output                              MC_S_AXI_WREADY,
    (*dont_touch = "true"*)output [5:0]                        MC_S_AXI_BID,
    (*dont_touch = "true"*)output [1:0]                        MC_S_AXI_BRESP,
    (*dont_touch = "true"*)output                              MC_S_AXI_BVALID,
    (*dont_touch = "true"*)input                               MC_S_AXI_BREADY,
    (*dont_touch = "true"*)input [5:0]                         MC_S_AXI_ARID, 
    (*dont_touch = "true"*)input [31:0]                        MC_S_AXI_ARADDR, 
    (*dont_touch = "true"*)input [7:0]                         MC_S_AXI_ARLEN, 
    (*dont_touch = "true"*)input [2:0]                         MC_S_AXI_ARSIZE, 
    (*dont_touch = "true"*)input [1:0]                         MC_S_AXI_ARBURST,
    (*dont_touch = "true"*)input                               MC_S_AXI_ARLOCK,
    (*dont_touch = "true"*)input [3:0]                         MC_S_AXI_ARCACHE,
    (*dont_touch = "true"*)input [2:0]                         MC_S_AXI_ARPROT, 
    (*dont_touch = "true"*)input [3:0]                         MC_S_AXI_ARQOS, 
    (*dont_touch = "true"*)input                               MC_S_AXI_ARVALID,
    (*dont_touch = "true"*)output                              MC_S_AXI_ARREADY,
    (*dont_touch = "true"*)output [5:0]                        MC_S_AXI_RID, 
    (*dont_touch = "true"*)output [63:0]                       MC_S_AXI_RDATA, 
    (*dont_touch = "true"*)output [1:0]                        MC_S_AXI_RRESP, 
    (*dont_touch = "true"*)output                              MC_S_AXI_RLAST,
    (*dont_touch = "true"*)output                              MC_S_AXI_RVALID, 
    (*dont_touch = "true"*)input                               MC_S_AXI_RREADY,
    
    // IMO (Rocket-Chip) Controller <-> Memory Controller 
    input                     imo_req_valid,
    output                    imo_req_ack,
    input [127:0]             imo_req_inst,
    
    output [511:0]            imo_resp_data,
    output                    imo_resp_valid

  );
  
  // MC <-> PHY Interface
  wire [3:0]                mc_ras_n; // DDR Row access strobe
  wire [3:0]                mc_cas_n; // DDR Column access strobe
  wire [3:0]                mc_we_n;  // DDR Write enable
  wire [55:0]               mc_address; // row address for activates / column address for read&writes
  wire [11:0]               mc_bank; // bank address
  wire [3:0]                mc_cs_n; // chip select, probably used to deselect in NOP cycles
  wire                      mc_reset_n; // Have no idea, probably need to keep HIGH
  wire [1:0]                mc_odt; // Need some logic to drive this
  wire [3:0]                mc_cke; // This should be HIGH all the time
  wire [3:0]                mc_aux_out0; 
  wire [3:0]                mc_aux_out1;
  wire                      mc_cmd_wren;       // Enqueue new command
  wire                      mc_ctl_wren;       // Enqueue new control singal
  wire [2:0]                mc_cmd;            // The command to enqueue
  wire [1:0]                mc_cas_slot;       // Which CAS slot we issued this command from 0-2
  wire [5:0]                mc_data_offset;    
  wire [5:0]                mc_data_offset_1;
  wire [5:0]                mc_data_offset_2;
  wire [1:0]                mc_rank_cnt;
  // Write
  wire                      mc_wrdata_en;                // Asserted for DDR-WRITEs
  wire  [511:0]             mc_wrdata;
  wire  [63:0]              mc_wrdata_mask; // Should be 0xff if we don't want to mask out bits
  wire                      idle;
  wire                      phy_mc_ctl_full;     // CTL interface is full
  wire                      phy_mc_cmd_full;     // CMD interface is full
  wire                      phy_mc_data_full;    // ?????????
  (*dont_touch = "true"*) reg pmcctlf;
  (*dont_touch = "true"*) reg pmccmdf;
  (*dont_touch = "true"*) reg pmcdf;
  wire [5:0]                calib_rd_data_offset_0;
  wire [5:0]                calib_rd_data_offset_1;
  wire [5:0]                calib_rd_data_offset_2;
  wire                      phy_rddata_valid;    // Next cycle will have a valid read
  wire [511:0]              phy_rd_data;         
  
  always @(posedge ui_clk) begin
    pmcctlf <= phy_mc_ctl_full;
    pmccmdf <= phy_mc_cmd_full;
    pmcdf   <= phy_mc_data_full;
  end
  
  memctl_mig #
  (
    .SIMULATION("FALSE") 
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
    .ddr3_reset_n         (ddr3_reset_n_fpga),
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
  
  controller_top mem_ctl_top
  (
    .clk(ui_clk),
    .rst(ui_rst),
    .init_calib_complete(init_calib_complete),
    
    .S_AXI_ACLK(MC_S_AXI_ACLK),
    .S_AXI_ARESETN(MC_S_AXI_ARESETN),
    .S_AXI_AWID(MC_S_AXI_AWID),
    .S_AXI_AWADDR(MC_S_AXI_AWADDR),
    .S_AXI_AWLEN(MC_S_AXI_AWLEN),
    .S_AXI_AWSIZE(MC_S_AXI_AWSIZE),
    .S_AXI_AWBURST(MC_S_AXI_AWBURST),
    .S_AXI_AWLOCK(MC_S_AXI_AWLOCK),
    .S_AXI_AWCACHE(MC_S_AXI_AWCACHE),
    .S_AXI_AWPROT(MC_S_AXI_AWPROT),
    .S_AXI_AWQOS(MC_S_AXI_AWQOS),
    .S_AXI_AWVALID(MC_S_AXI_AWVALID),
    .S_AXI_AWREADY(MC_S_AXI_AWREADY),
    .S_AXI_WDATA(MC_S_AXI_WDATA),
    .S_AXI_WSTRB(MC_S_AXI_WSTRB),
    .S_AXI_WLAST(MC_S_AXI_WLAST),
    .S_AXI_WVALID(MC_S_AXI_WVALID),
    .S_AXI_WREADY(MC_S_AXI_WREADY),
    .S_AXI_BID(MC_S_AXI_BID),
    .S_AXI_BRESP(MC_S_AXI_BRESP),
    .S_AXI_BVALID(MC_S_AXI_BVALID),
    .S_AXI_BREADY(MC_S_AXI_BREADY),
    .S_AXI_ARID(MC_S_AXI_ARID), 
    .S_AXI_ARADDR(MC_S_AXI_ARADDR), 
    .S_AXI_ARLEN(MC_S_AXI_ARLEN), 
    .S_AXI_ARSIZE(MC_S_AXI_ARSIZE), 
    .S_AXI_ARBURST(MC_S_AXI_ARBURST),
    .S_AXI_ARLOCK(MC_S_AXI_ARLOCK), 
    .S_AXI_ARCACHE(MC_S_AXI_ARCACHE),
    .S_AXI_ARPROT(MC_S_AXI_ARPROT), 
    .S_AXI_ARQOS(MC_S_AXI_ARQOS), 
    .S_AXI_ARVALID(MC_S_AXI_ARVALID),
    .S_AXI_ARREADY(MC_S_AXI_ARREADY),
    .S_AXI_RID(MC_S_AXI_RID), 
    .S_AXI_RDATA(MC_S_AXI_RDATA), 
    .S_AXI_RRESP(MC_S_AXI_RRESP), 
    .S_AXI_RLAST(MC_S_AXI_RLAST), 
    .S_AXI_RVALID(MC_S_AXI_RVALID), 
    .S_AXI_RREADY(MC_S_AXI_RREADY),
  
    // IMO Controller <-> Mem. controller
    .imo_req_valid(imo_req_valid),
    .imo_req_ack(imo_req_ack),
    .imo_req_inst(imo_req_inst),
      
    .imo_resp_data(imo_resp_data),
    .imo_resp_valid(imo_resp_valid),

    // DDR PHY
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

endmodule
