`timescale 1ns / 1ps

`include "clocking.vh"

module system_top(
   // Signals that start with ddr3
   // are connected to the SODIMM
   inout [14:0] DDR_addr,
   inout [13:0] ddr3_addr,
   inout [2:0] DDR_ba,
   inout [2:0] ddr3_ba,
   inout DDR_cas_n,
   inout ddr3_cas_n,
   inout DDR_ck_n,
   inout ddr3_ck_n,
   inout DDR_ck_p,
   inout ddr3_ck_p,
   inout DDR_cke,
   inout [0:0]ddr3_cke,
   inout DDR_cs_n,
   inout [0:0]ddr3_cs_n,
   inout [3:0]DDR_dm,
   inout [7:0]ddr3_dm,
   inout [31:0]DDR_dq,
   inout [63:0]ddr3_dq,
   inout [3:0]DDR_dqs_n,
   inout [7:0]ddr3_dqs_n,
   inout [3:0]DDR_dqs_p,
   inout [7:0]ddr3_dqs_p,
   inout DDR_odt,
   inout [0:0]ddr3_odt,
   inout DDR_ras_n,
   inout ddr3_ras_n,
   inout DDR_reset_n,
   inout ddr3_reset_n,
   inout DDR_we_n,
   inout ddr3_we_n,
   inout FIXED_IO_ddr_vrn,
   inout FIXED_IO_ddr_vrp,
   inout [53:0] FIXED_IO_mio,
   inout FIXED_IO_ps_clk,
   inout FIXED_IO_ps_porb,
   inout FIXED_IO_ps_srstb,

    input sys_rst,
    output init_calib_complete,
`ifndef differential_clock
    input clk);
`else
    input sys_clk_p,
    input sys_clk_n
  );
`endif
  wire FCLK_RESET0_N;
  wire ui_clk;
  wire ui_rst;
  
  wire                     imo_req_valid;
  wire                     imo_req_ack;
  wire  [127:0]            imo_req_inst;
  wire  [511:0]            imo_resp_data;
  wire                     imo_resp_valid;

  // axixbar combined master interfaces
  // first half of the vectors are connected
  // to the zynq, the other goes to the memory controller
  wire [63:0]mc_s_axi_araddr;
  wire [3:0]mc_s_axi_arburst;
  wire [15:0]mc_s_axi_arlen;
  wire [1:0] mc_s_axi_arready;
  wire [5:0]mc_s_axi_arsize;
  wire [1:0]mc_s_axi_arvalid;
  wire [63:0]mc_s_axi_awaddr;
  wire [3:0]mc_s_axi_awburst;
  wire [15:0]mc_s_axi_awlen;
  wire [15:0]mc_s_axi_wstrb;
  wire [1:0]mc_s_axi_awready;
  wire [5:0]mc_s_axi_awsize;
  wire [1:0]mc_s_axi_awvalid;
  wire [1:0]mc_s_axi_bready;
  wire [1:0]mc_s_axi_bvalid;
  wire [127:0]mc_s_axi_rdata;
  wire [1:0]mc_s_axi_rlast;
  wire [1:0]mc_s_axi_rready;
  wire [1:0]mc_s_axi_rvalid;
  wire [127:0]mc_s_axi_wdata;
  wire [1:0]mc_s_axi_wlast;
  wire [1:0]mc_s_axi_wready;
  wire [1:0]mc_s_axi_wvalid;
  wire [11:0] mc_s_axi_arid, mc_s_axi_awid;
  wire [11:0] mc_s_axi_bid, mc_s_axi_rid;
  wire [7:0] mc_s_axi_arcache, mc_s_axi_awcache;
  wire [5:0]  mc_s_axi_arprot,mc_s_axi_awprot;
  wire [7:0]  mc_s_axi_arqos,mc_s_axi_awqos;
  wire [1:0] mc_s_axi_arlock,mc_s_axi_awlock;
  wire [3:0] mc_s_axi_bresp, mc_s_axi_rresp;
  
  wire [31:0]m_axi_araddr;
  wire [1:0]m_axi_arburst;
  wire [7:0]m_axi_arlen;
  wire m_axi_arready;
  wire [2:0]m_axi_arsize;
  wire m_axi_arvalid;
  wire [31:0]m_axi_awaddr;
  wire [1:0]m_axi_awburst;
  wire [7:0]m_axi_awlen;
  wire [3:0]m_axi_wstrb;
  wire m_axi_awready;
  wire [2:0]m_axi_awsize;
  wire m_axi_awvalid;
  wire m_axi_bready;
  wire m_axi_bvalid;
  wire [1:0] m_axi_bresp;
  wire [31:0]m_axi_rdata;
  wire m_axi_rlast;
  wire m_axi_rready;
  wire m_axi_rvalid;
  wire [1:0] m_axi_rresp;
  wire [31:0]m_axi_wdata;
  wire m_axi_wlast;
  wire m_axi_wready;
  wire m_axi_wvalid;
  wire [11:0] m_axi_arid, m_axi_awid; // outputs from ARM core
  wire [11:0] m_axi_bid, m_axi_rid;   // inputs to ARM core

  (*dont_touch = "true"*) wire s_axi_arready;
  (*dont_touch = "true"*) wire s_axi_arvalid;
  (*dont_touch = "true"*) wire [31:0] s_axi_araddr;
  (*dont_touch = "true"*) wire [5:0]  s_axi_arid;
  (*dont_touch = "true"*) wire [2:0]  s_axi_arsize;
  (*dont_touch = "true"*) wire [7:0]  s_axi_arlen;
  (*dont_touch = "true"*) wire [1:0]  s_axi_arburst;
  (*dont_touch = "true"*) wire s_axi_arlock;
  (*dont_touch = "true"*) wire [3:0]  s_axi_arcache;
  (*dont_touch = "true"*) wire [2:0]  s_axi_arprot;
  (*dont_touch = "true"*) wire [3:0]  s_axi_arqos;
  //wire [3:0]  s_axi_arregion;

  (*dont_touch = "true"*) wire s_axi_awready;
  (*dont_touch = "true"*) wire s_axi_awvalid;
  (*dont_touch = "true"*) wire [31:0] s_axi_awaddr;
  (*dont_touch = "true"*) wire [5:0]  s_axi_awid;
  (*dont_touch = "true"*) wire [2:0]  s_axi_awsize;
  (*dont_touch = "true"*) wire [7:0]  s_axi_awlen;
  (*dont_touch = "true"*) wire [1:0]  s_axi_awburst;
  (*dont_touch = "true"*) wire s_axi_awlock;
  (*dont_touch = "true"*) wire [3:0]  s_axi_awcache;
  (*dont_touch = "true"*) wire [2:0]  s_axi_awprot;
  (*dont_touch = "true"*) wire [3:0]  s_axi_awqos;
  //wire [3:0]  s_axi_awregion;

  (*dont_touch = "true"*) wire s_axi_wready;
  (*dont_touch = "true"*) wire s_axi_wvalid;
  (*dont_touch = "true"*) wire [7:0]  s_axi_wstrb;
  (*dont_touch = "true"*) wire [63:0] s_axi_wdata;
  (*dont_touch = "true"*) wire s_axi_wlast;

  (*dont_touch = "true"*) wire s_axi_bready;
  (*dont_touch = "true"*) wire s_axi_bvalid;
  (*dont_touch = "true"*) wire [1:0] s_axi_bresp;
  (*dont_touch = "true"*) wire [5:0] s_axi_bid;
  
  (*dont_touch = "true"*) wire s_axi_rready;
  (*dont_touch = "true"*) wire s_axi_rvalid;
  (*dont_touch = "true"*) wire [1:0]  s_axi_rresp;
  (*dont_touch = "true"*) wire [5:0]  s_axi_rid;
  (*dont_touch = "true"*) wire [63:0] s_axi_rdata;
  (*dont_touch = "true"*) wire s_axi_rlast;
   
  
  memctl_sys_top memctl
  (
    .ui_clk(ui_clk),
    .ui_rst(ui_rst),
    
    .sys_clk_p(sys_clk_p),
    .sys_clk_n(sys_clk_n), 
    .sys_rst(sys_rst),
    .init_calib_complete(init_calib_complete),
    
    .ddr3_dq_fpga(ddr3_dq),
    .ddr3_dqs_n_fpga(ddr3_dqs_n),
    .ddr3_dqs_p_fpga(ddr3_dqs_p),
    
    .ddr3_addr_fpga(ddr3_addr),
    .ddr3_ba_fpga(ddr3_ba),
    .ddr3_ras_n_fpga(ddr3_ras_n),
    .ddr3_cas_n_fpga(ddr3_cas_n),
    .ddr3_we_n_fpga(ddr3_we_n),
    .ddr3_reset_n_fpga(ddr3_reset_n),
    .ddr3_ck_p_fpga(ddr3_ck_p),
    .ddr3_ck_n_fpga(ddr3_ck_n),
    .ddr3_cke_fpga(ddr3_cke),
    .ddr3_cs_n_fpga(ddr3_cs_n),
    .ddr3_dm_fpga(ddr3_dm),
    .ddr3_odt_fpga(ddr3_odt),
    
    .MC_S_AXI_ACLK(ui_clk),
    .MC_S_AXI_ARESETN(~ui_rst),
    .MC_S_AXI_ARADDR(mc_s_axi_araddr[63:32]),
    .MC_S_AXI_ARBURST(mc_s_axi_arburst[3:2]),
    .MC_S_AXI_ARCACHE(mc_s_axi_arcache[7:4]),
    .MC_S_AXI_ARID(mc_s_axi_arid[11:6]),
    .MC_S_AXI_ARLEN(mc_s_axi_arlen[15:8]),
    .MC_S_AXI_ARLOCK(mc_s_axi_arlock[1]),
    .MC_S_AXI_ARPROT(mc_s_axi_arprot[5:3]),
    .MC_S_AXI_ARQOS(mc_s_axi_arqos[7:4]),
    .MC_S_AXI_ARREADY(mc_s_axi_arready[1]),
    .MC_S_AXI_ARSIZE(mc_s_axi_arsize[5:3]),
    .MC_S_AXI_ARVALID(mc_s_axi_arvalid[1]),
    .MC_S_AXI_AWADDR(mc_s_axi_awaddr[63:32]),
    .MC_S_AXI_AWBURST(mc_s_axi_awburst[3:2]),
    .MC_S_AXI_AWCACHE(mc_s_axi_awcache[7:4]),
    .MC_S_AXI_AWID(mc_s_axi_awid[11:6]),
    .MC_S_AXI_AWLEN(mc_s_axi_awlen[15:8]),
    .MC_S_AXI_AWLOCK(mc_s_axi_awlock[1]),
    .MC_S_AXI_AWPROT(mc_s_axi_awprot[5:3]),
    .MC_S_AXI_AWQOS(mc_s_axi_awqos[7:4]),
    .MC_S_AXI_AWREADY(mc_s_axi_awready[1]),
    .MC_S_AXI_AWSIZE(mc_s_axi_awsize[5:3]),
    .MC_S_AXI_AWVALID(mc_s_axi_awvalid[1]),
    .MC_S_AXI_BID(mc_s_axi_bid[11:6]),
    .MC_S_AXI_BREADY(mc_s_axi_bready[1]),
    .MC_S_AXI_BRESP(mc_s_axi_bresp[3:2]),
    .MC_S_AXI_BVALID(mc_s_axi_bvalid[1]),
    .MC_S_AXI_RID(mc_s_axi_rid[11:6]),
    .MC_S_AXI_RDATA(mc_s_axi_rdata[127:64]),
    .MC_S_AXI_RLAST(mc_s_axi_rlast[1]),
    .MC_S_AXI_RREADY(mc_s_axi_rready[1]),
    .MC_S_AXI_RRESP(mc_s_axi_rresp[3:2]),
    .MC_S_AXI_RVALID(mc_s_axi_rvalid[1]),
    .MC_S_AXI_WDATA(mc_s_axi_wdata[127:64]),
    .MC_S_AXI_WLAST(mc_s_axi_wlast[1]),
    .MC_S_AXI_WREADY(mc_s_axi_wready[1]),
    .MC_S_AXI_WSTRB(mc_s_axi_wstrb[15:8]),
    .MC_S_AXI_WVALID(mc_s_axi_wvalid[1]),
    
    .imo_req_valid(imo_req_valid),
    .imo_req_ack(imo_req_ack),
    .imo_req_inst(imo_req_inst),
      
    .imo_resp_data(imo_resp_data),
    .imo_resp_valid(imo_resp_valid)
    
  );
  
  // Rocket-chip operates at a different clock rate
  rchip_axi4_xbar axixbar
  (
    .aclk(ui_clk), // This is rocket-chip domain
    .aresetn(~ui_rst),
    .s_axi_awid(s_axi_awid),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awlen(s_axi_awlen),
    .s_axi_awsize(s_axi_awsize),
    .s_axi_awburst(s_axi_awburst),
    .s_axi_awlock(s_axi_awlock),
    .s_axi_awcache(s_axi_awcache),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_awqos(s_axi_awqos),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bid(s_axi_bid),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_arid(s_axi_arid), 
    .s_axi_araddr(s_axi_araddr), 
    .s_axi_arlen(s_axi_arlen), 
    .s_axi_arsize(s_axi_arsize), 
    .s_axi_arburst(s_axi_arburst),
    .s_axi_arlock(s_axi_arlock), 
    .s_axi_arcache(s_axi_arcache),
    .s_axi_arprot(s_axi_arprot), 
    .s_axi_arqos(s_axi_arqos), 
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rid(s_axi_rid), 
    .s_axi_rdata(s_axi_rdata), 
    .s_axi_rresp(s_axi_rresp), 
    .s_axi_rlast(s_axi_rlast), 
    .s_axi_rvalid(s_axi_rvalid), 
    .s_axi_rready(s_axi_rready),
    .m_axi_awid(mc_s_axi_awid),
    .m_axi_awaddr(mc_s_axi_awaddr),
    .m_axi_awlen(mc_s_axi_awlen),
    .m_axi_awsize(mc_s_axi_awsize),
    .m_axi_awburst(mc_s_axi_awburst),
    .m_axi_awlock(mc_s_axi_awlock),
    .m_axi_awcache(mc_s_axi_awcache),
    .m_axi_awprot(mc_s_axi_awprot),
    .m_axi_awqos(mc_s_axi_awqos),
    .m_axi_awvalid(mc_s_axi_awvalid),
    .m_axi_awready(mc_s_axi_awready),
    .m_axi_wdata(mc_s_axi_wdata),
    .m_axi_wstrb(mc_s_axi_wstrb),
    .m_axi_wlast(mc_s_axi_wlast),
    .m_axi_wvalid(mc_s_axi_wvalid),
    .m_axi_wready(mc_s_axi_wready),
    .m_axi_bid(mc_s_axi_bid),
    .m_axi_bresp(mc_s_axi_bresp),
    .m_axi_bvalid(mc_s_axi_bvalid),
    .m_axi_bready(mc_s_axi_bready),
    .m_axi_arid(mc_s_axi_arid), 
    .m_axi_araddr(mc_s_axi_araddr), 
    .m_axi_arlen(mc_s_axi_arlen), 
    .m_axi_arsize(mc_s_axi_arsize), 
    .m_axi_arburst(mc_s_axi_arburst),
    .m_axi_arlock(mc_s_axi_arlock), 
    .m_axi_arcache(mc_s_axi_arcache),
    .m_axi_arprot(mc_s_axi_arprot), 
    .m_axi_arqos(mc_s_axi_arqos), 
    .m_axi_arvalid(mc_s_axi_arvalid),
    .m_axi_arready(mc_s_axi_arready),
    .m_axi_rid(mc_s_axi_rid), 
    .m_axi_rdata(mc_s_axi_rdata), 
    .m_axi_rresp(mc_s_axi_rresp), 
    .m_axi_rlast(mc_s_axi_rlast), 
    .m_axi_rvalid(mc_s_axi_rvalid), 
    .m_axi_rready(mc_s_axi_rready)
  );
  
  (*dont_touch = "true"*) wire [31:0] mem_araddr;
  (*dont_touch = "true"*) wire [31:0] mem_awaddr;

  // Memory given to Rocket is the upper 256 MB of the 512 MB DRAM
  wire [31:0] mask = 32'h10000000; // this is 256 MBs
  wire [31:0] dec = 32'h80000000; // this is 256 MBs
  //assign s_axi_araddr = mem_araddr[31:0] - dec + mask;
  //assign s_axi_awaddr = mem_awaddr[31:0] - dec + mask;
  
  wire ar_addr_switch = (mem_araddr < 32'hb0000000) || (mem_araddr >= 32'hf0000000); 
  wire aw_addr_switch = (mem_awaddr < 32'hb0000000) || (mem_awaddr >= 32'hf0000000); 
  
  assign s_axi_araddr = ar_addr_switch ? {4'd1, mem_araddr[27:0]} : mem_araddr - dec + mask;
  assign s_axi_awaddr = aw_addr_switch ? {4'd1, mem_awaddr[27:0]} : mem_awaddr - dec + mask;
  
  /*  
  // Memory given to Rocket is the upper 256 MB of the 512 MB DRAM
  assign S_AXI_araddr = {4'd1, mem_araddr[27:0]};
  assign S_AXI_awaddr = {4'd1, mem_awaddr[27:0]};  
  */
  
  Top rocket_chip(
   .clock(ui_clk),    
   .reset(ui_rst),
    
   .io_ps_axi_slave_aw_ready (m_axi_awready),
   .io_ps_axi_slave_aw_valid (m_axi_awvalid),
   .io_ps_axi_slave_aw_bits_addr (m_axi_awaddr),
   .io_ps_axi_slave_aw_bits_len (m_axi_awlen),
   .io_ps_axi_slave_aw_bits_size (m_axi_awsize),
   .io_ps_axi_slave_aw_bits_burst (m_axi_awburst),
   .io_ps_axi_slave_aw_bits_id (m_axi_awid),
   .io_ps_axi_slave_aw_bits_lock (1'b0),
   .io_ps_axi_slave_aw_bits_cache (4'b0),
   .io_ps_axi_slave_aw_bits_prot (3'b0),
   .io_ps_axi_slave_aw_bits_qos (4'b0),

   .io_ps_axi_slave_ar_ready (m_axi_arready),
   .io_ps_axi_slave_ar_valid (m_axi_arvalid),
   .io_ps_axi_slave_ar_bits_addr (m_axi_araddr),
   .io_ps_axi_slave_ar_bits_len (m_axi_arlen),
   .io_ps_axi_slave_ar_bits_size (m_axi_arsize),
   .io_ps_axi_slave_ar_bits_burst (m_axi_arburst),
   .io_ps_axi_slave_ar_bits_id (m_axi_arid),
   .io_ps_axi_slave_ar_bits_lock (1'b0),
   .io_ps_axi_slave_ar_bits_cache (4'b0),
   .io_ps_axi_slave_ar_bits_prot (3'b0),
   .io_ps_axi_slave_ar_bits_qos (4'b0),

   .io_ps_axi_slave_w_valid (m_axi_wvalid),
   .io_ps_axi_slave_w_ready (m_axi_wready),
   .io_ps_axi_slave_w_bits_data (m_axi_wdata),
   .io_ps_axi_slave_w_bits_strb (m_axi_wstrb),
   .io_ps_axi_slave_w_bits_last (m_axi_wlast),

   .io_ps_axi_slave_r_valid (m_axi_rvalid),
   .io_ps_axi_slave_r_ready (m_axi_rready),
   .io_ps_axi_slave_r_bits_id (m_axi_rid),
   .io_ps_axi_slave_r_bits_resp (m_axi_rresp),
   .io_ps_axi_slave_r_bits_data (m_axi_rdata),
   .io_ps_axi_slave_r_bits_last (m_axi_rlast),

   .io_ps_axi_slave_b_valid (m_axi_bvalid),
   .io_ps_axi_slave_b_ready (m_axi_bready),
   .io_ps_axi_slave_b_bits_id (m_axi_bid),
   .io_ps_axi_slave_b_bits_resp (m_axi_bresp),

   .io_mem_axi_ar_valid (s_axi_arvalid),
   .io_mem_axi_ar_ready (s_axi_arready),
   .io_mem_axi_ar_bits_addr (mem_araddr),
   .io_mem_axi_ar_bits_id (s_axi_arid),
   .io_mem_axi_ar_bits_size (s_axi_arsize),
   .io_mem_axi_ar_bits_len (s_axi_arlen),
   .io_mem_axi_ar_bits_burst (s_axi_arburst),
   .io_mem_axi_ar_bits_cache (s_axi_arcache),
   .io_mem_axi_ar_bits_lock (s_axi_arlock),
   .io_mem_axi_ar_bits_prot (s_axi_arprot),
   .io_mem_axi_ar_bits_qos (s_axi_arqos),
   .io_mem_axi_aw_valid (s_axi_awvalid),
   .io_mem_axi_aw_ready (s_axi_awready),
   .io_mem_axi_aw_bits_addr (mem_awaddr),
   .io_mem_axi_aw_bits_id (s_axi_awid),
   .io_mem_axi_aw_bits_size (s_axi_awsize),
   .io_mem_axi_aw_bits_len (s_axi_awlen),
   .io_mem_axi_aw_bits_burst (s_axi_awburst),
   .io_mem_axi_aw_bits_cache (s_axi_awcache),
   .io_mem_axi_aw_bits_lock (s_axi_awlock),
   .io_mem_axi_aw_bits_prot (s_axi_awprot),
   .io_mem_axi_aw_bits_qos (s_axi_awqos),
   .io_mem_axi_w_valid (s_axi_wvalid),
   .io_mem_axi_w_ready (s_axi_wready),
   .io_mem_axi_w_bits_strb (s_axi_wstrb),
   .io_mem_axi_w_bits_data (s_axi_wdata),
   .io_mem_axi_w_bits_last (s_axi_wlast),
   .io_mem_axi_b_valid (s_axi_bvalid),
   .io_mem_axi_b_ready (s_axi_bready),
   .io_mem_axi_b_bits_resp (s_axi_bresp),
   .io_mem_axi_b_bits_id (s_axi_bid),
   .io_mem_axi_r_valid (s_axi_rvalid),
   .io_mem_axi_r_ready (s_axi_rready),
   .io_mem_axi_r_bits_resp (s_axi_rresp),
   .io_mem_axi_r_bits_id (s_axi_rid),
   .io_mem_axi_r_bits_data (s_axi_rdata),
   .io_mem_axi_r_bits_last (s_axi_rlast),
   .io_imo_out_valid(imo_req_valid),
   .io_imo_out_ack(imo_req_ack),
   .io_imo_out_inst(imo_req_inst),
     
   .io_imo_in_data(imo_resp_data),
   .io_imo_in_valid(imo_resp_valid)
  );
  
  system zynq_ps(
    .DDR_addr(DDR_addr),
    .DDR_ba(DDR_ba),
    .DDR_cas_n(DDR_cas_n),
    .DDR_ck_n(DDR_ck_n),
    .DDR_ck_p(DDR_ck_p),
    .DDR_cke(DDR_cke),
    .DDR_cs_n(DDR_cs_n),
    .DDR_dm(DDR_dm),
    .DDR_dq(DDR_dq),
    .DDR_dqs_n(DDR_dqs_n),
    .DDR_dqs_p(DDR_dqs_p),
    .DDR_odt(DDR_odt),
    .DDR_ras_n(DDR_ras_n),
    .DDR_reset_n(DDR_reset_n),
    .DDR_we_n(DDR_we_n),
    .FCLK_RESET0_N(FCLK_RESET0_N),
    .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
    .FIXED_IO_mio(FIXED_IO_mio),
    .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
    
    // master AXI interface (zynq = master, fpga = slave)
    .M00_AXI_araddr(m_axi_araddr),
    .M00_AXI_arburst(m_axi_arburst), // burst type
    .M00_AXI_arcache(),
    .M00_AXI_arid(m_axi_arid),
    .M00_AXI_arlen(m_axi_arlen), // burst length (#transfers)
    .M00_AXI_arlock(),
    .M00_AXI_arprot(),
    .M00_AXI_arqos(),
    .M00_AXI_arready(m_axi_arready),
    .M00_AXI_arsize(m_axi_arsize), // burst size (bits/transfer)
    .M00_AXI_arvalid(m_axi_arvalid),
    .M00_AXI_awaddr(m_axi_awaddr),
    .M00_AXI_awburst(m_axi_awburst),
    .M00_AXI_awcache(),
    .M00_AXI_awid(m_axi_awid),
    .M00_AXI_awlen(m_axi_awlen),
    .M00_AXI_awlock(),
    .M00_AXI_awprot(),
    .M00_AXI_awqos(),
    .M00_AXI_awready(m_axi_awready),
    .M00_AXI_awsize(m_axi_awsize),
    .M00_AXI_awvalid(m_axi_awvalid),
    .M00_AXI_bid(m_axi_bid),
    .M00_AXI_bready(m_axi_bready),
    .M00_AXI_bresp(2'b00),
    .M00_AXI_bvalid(m_axi_bvalid),
    .M00_AXI_rdata(m_axi_rdata),
    .M00_AXI_rid(m_axi_rid),
    .M00_AXI_rlast(m_axi_rlast),
    .M00_AXI_rready(m_axi_rready),
    .M00_AXI_rresp(2'b00),
    .M00_AXI_rvalid(m_axi_rvalid),
    .M00_AXI_wdata(m_axi_wdata),
    .M00_AXI_wlast(m_axi_wlast),
    .M00_AXI_wready(m_axi_wready),
    .M00_AXI_wstrb(m_axi_wstrb),
    .M00_AXI_wvalid(m_axi_wvalid),
    
    // slave AXI interface (fpga = master, zynq = slave) 
    // connected directly to DDR controller to handle test chip mem
    .S00_AXI_araddr(mc_s_axi_araddr[31:0]),
    .S00_AXI_arburst(mc_s_axi_arburst[1:0]),
    .S00_AXI_arcache(mc_s_axi_arcache[3:0]),
    .S00_AXI_arid(mc_s_axi_arid[5:0]),
    .S00_AXI_arlen(mc_s_axi_arlen[7:0]),
    .S00_AXI_arlock(mc_s_axi_arlock[0]),
    .S00_AXI_arprot(mc_s_axi_arprot[2:0]),
    .S00_AXI_arqos(mc_s_axi_arqos[3:0]),
    .S00_AXI_arready(mc_s_axi_arready[0]),
    .S00_AXI_arregion(4'b0),
    .S00_AXI_arsize(mc_s_axi_arsize[2:0]),
    .S00_AXI_arvalid(mc_s_axi_arvalid[0]),
    .S00_AXI_awaddr(mc_s_axi_awaddr[31:0]),
    .S00_AXI_awburst(mc_s_axi_awburst[1:0]),
    .S00_AXI_awcache(mc_s_axi_awcache[3:0]),
    .S00_AXI_awid(mc_s_axi_awid[5:0]),
    .S00_AXI_awlen(mc_s_axi_awlen[7:0]),
    .S00_AXI_awlock(mc_s_axi_awlock[0]),
    .S00_AXI_awprot(mc_s_axi_awprot[2:0]),
    .S00_AXI_awqos(mc_s_axi_awqos[3:0]),
    .S00_AXI_awready(mc_s_axi_awready[0]),
    .S00_AXI_awregion(4'b0),
    .S00_AXI_awsize(mc_s_axi_awsize[2:0]),
    .S00_AXI_awvalid(mc_s_axi_awvalid[0]),
    .S00_AXI_bid(mc_s_axi_bid[5:0]),
    .S00_AXI_bready(mc_s_axi_bready[0]),
    .S00_AXI_bresp(mc_s_axi_bresp[1:0]),
    .S00_AXI_bvalid(mc_s_axi_bvalid[0]),
    .S00_AXI_rid(mc_s_axi_rid[5:0]),
    .S00_AXI_rdata(mc_s_axi_rdata[63:0]),
    .S00_AXI_rlast(mc_s_axi_rlast[0]),
    .S00_AXI_rready(mc_s_axi_rready[0]),
    .S00_AXI_rresp(mc_s_axi_rresp[1:0]),
    .S00_AXI_rvalid(mc_s_axi_rvalid[0]),
    .S00_AXI_wdata(mc_s_axi_wdata[63:0]),
    .S00_AXI_wlast(mc_s_axi_wlast[0]),
    .S00_AXI_wready(mc_s_axi_wready[0]),
    .S00_AXI_wstrb(mc_s_axi_wstrb[7:0]),
    .S00_AXI_wvalid(mc_s_axi_wvalid[0]),
    .ext_clk_in(ui_clk)
  );

/*  
 `ifndef differential_clock
    IBUFG ibufg_gclk (.I(clk), .O(gclk_i));
  `else
    IBUFDS #(.DIFF_TERM("TRUE"), .IBUF_LOW_PWR("TRUE"), .IOSTANDARD("DEFAULT")) clk_ibufds (.O(gclk_i), .I(SYSCLK_P), .IB(SYSCLK_N));
  `endif
    BUFG  bufg_host_clk (.I(host_clk_i), .O(host_clk)); 
  
  MMCME2_BASE #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKFBOUT_MULT_F(`RC_CLK_MULT),
    .CLKFBOUT_PHASE(0.0),
    .CLKIN1_PERIOD(`ZYNQ_CLK_PERIOD),
    .CLKOUT1_DIVIDE(1),
    .CLKOUT2_DIVIDE(1),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT0_DIVIDE_F(`RC_CLK_DIVIDE),
    .CLKOUT0_DUTY_CYCLE(0.5),
    .CLKOUT1_DUTY_CYCLE(0.5),
    .CLKOUT2_DUTY_CYCLE(0.5),
    .CLKOUT3_DUTY_CYCLE(0.5),
    .CLKOUT4_DUTY_CYCLE(0.5),
    .CLKOUT5_DUTY_CYCLE(0.5),
    .CLKOUT6_DUTY_CYCLE(0.5),
    .CLKOUT0_PHASE(0.0),
    .CLKOUT1_PHASE(0.0),
    .CLKOUT2_PHASE(0.0),
    .CLKOUT3_PHASE(0.0),
    .CLKOUT4_PHASE(0.0),
    .CLKOUT5_PHASE(0.0),
    .CLKOUT6_PHASE(0.0),
    .CLKOUT4_CASCADE("FALSE"),
    .DIVCLK_DIVIDE(1),
    .REF_JITTER1(0.0),
    .STARTUP_WAIT("FALSE")
  ) MMCME2_BASE_inst (
    .CLKOUT0(host_clk_i),
    .CLKOUT0B(),
    .CLKOUT1(),
    .CLKOUT1B(),
    .CLKOUT2(),
    .CLKOUT2B(),
    .CLKOUT3(),
    .CLKOUT3B(),
    .CLKOUT4(),
    .CLKOUT5(),
    .CLKOUT6(),
    .CLKFBOUT(gclk_fbout),
    .CLKFBOUTB(),
    .LOCKED(mmcm_locked),
    .CLKIN1(gclk_i),
    .PWRDWN(1'b0),
    .RST(1'b0),
    .CLKFBIN(gclk_fbout));
  */
endmodule
