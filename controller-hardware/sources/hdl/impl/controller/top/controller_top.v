`timescale 1ns / 1ps
`include "parameters.vh"
`include "encoding.vh"

module controller_top
  (
    input                     clk,
    input                     rst,
    input                     init_calib_complete,
    // Rocket-Chip <-> MC Arbiter
    input                     S_AXI_ACLK,
    input                     S_AXI_ARESETN,
    input [5:0]               S_AXI_AWID,
    input [31:0]              S_AXI_AWADDR,
    input [7:0]               S_AXI_AWLEN,
    input [2:0]               S_AXI_AWSIZE,
    input [1:0]               S_AXI_AWBURST,
    input                     S_AXI_AWLOCK,
    input [3:0]               S_AXI_AWCACHE,
    input [2:0]               S_AXI_AWPROT,
    input [3:0]               S_AXI_AWQOS,
    input                     S_AXI_AWVALID,
    output                    S_AXI_AWREADY,
    input [63:0]              S_AXI_WDATA,
    input [7:0]               S_AXI_WSTRB,
    input                     S_AXI_WLAST,
    input                     S_AXI_WVALID,
    output                    S_AXI_WREADY,
    output [5:0]              S_AXI_BID,
    output [1:0]              S_AXI_BRESP,
    output                    S_AXI_BVALID,
    input                     S_AXI_BREADY,
    input [5:0]               S_AXI_ARID, 
    input [31:0]              S_AXI_ARADDR, 
    input [7:0]               S_AXI_ARLEN, 
    input [2:0]               S_AXI_ARSIZE, 
    input [1:0]               S_AXI_ARBURST,
    input                     S_AXI_ARLOCK, 
    input [3:0]               S_AXI_ARCACHE,
    input [2:0]               S_AXI_ARPROT, 
    input [3:0]               S_AXI_ARQOS, 
    input                     S_AXI_ARVALID,
    output                    S_AXI_ARREADY,
    output [5:0]              S_AXI_RID, 
    output [63:0]             S_AXI_RDATA, 
    output [1:0]              S_AXI_RRESP, 
    output                    S_AXI_RLAST, 
    output                    S_AXI_RVALID, 
    input                     S_AXI_RREADY,
    // IMO (Rocket-Chip) Controller <-> Memory Controller 
    input                     imo_req_valid,
    output                    imo_req_ack,
    input [127:0]             imo_req_inst,
    
    output [511:0]            imo_resp_data,
    output                    imo_resp_valid,
    // MC <-> PHY Interface
    output [3:0]              mc_ras_n, // DDR Row access strobe
    output [3:0]              mc_cas_n, // DDR Column access strobe
    output [3:0]              mc_we_n,  // DDR Write enable
    output [4*`ROW_SZ-1:0]    mc_address, // row address for activates / column address for read&writes
    output [4*`BANK_SZ-1:0]   mc_bank, // bank address
    output [3:0]              mc_cs_n, // chip select, probably used to deselect in NOP cycles
    output                    mc_reset_n, // Have no idea, probably need to keep HIGH
    output [1:0]              mc_odt, // Need some logic to drive this
    output [3:0]              mc_cke, // This should be HIGH all the time
    output [3:0]              mc_aux_out0, 
    output [3:0]              mc_aux_out1,
    output                    mc_cmd_wren, // Enqueue new command
    output                    mc_ctl_wren, // Enqueue new control singal
    output [2:0]              mc_cmd, // The command to enqueue
    output [1:0]              mc_cas_slot, // Which CAS slot we issued this command from 0-2
    output [5:0]              mc_data_offset,    
    output [5:0]              mc_data_offset_1,
    output [5:0]              mc_data_offset_2,
    output [1:0]              mc_rank_cnt,
    // Write
    output                    mc_wrdata_en, // Asserted for DDR-WRITEs
    output  [511:0]           mc_wrdata,
    output  [63:0]            mc_wrdata_mask, // Should be 0xff if we don't want to mask out bits
    output                    idle,
    input                     phy_mc_ctl_full, // CTL interface is full
    input                     phy_mc_cmd_full, // CMD interface is full
    input                     phy_mc_data_full, // ?????????
    input [5:0]               calib_rd_data_offset_0,
    input [5:0]               calib_rd_data_offset_1,
    input [5:0]               calib_rd_data_offset_2,
    input                     phy_rddata_valid, // Next cycle will have a valid read
    input [511:0]             phy_rd_data
  );

  
    
  // Scheduler <-> Converter
  wire [`DEC_DDR_CMD_SZ*4-1:0] scd_phy_cmd;
  wire [`ROW_SZ*4-1:0]         scd_phy_row;
  wire [`BANK_SZ*4-1:0]        scd_phy_bank;
  wire [`COL_SZ*4-1:0]         scd_phy_col;
  // PHY Converter <-> WD FIFO
  wire wd_fifo_rden;
  
  // AXI4 <-> Arbiter (1st stage of the scheduler)
  wire arb_axi_rack, arb_axi_wack, axi_arb_rden, axi_arb_wren;
  wire [29:0] axi_arb_rdaddr, axi_arb_wraddr;
  wire [511:0] axi_arb_wrdata;
  wire [63:0] axi_arb_wrdata_mask;
 
  // IMO Controller <-> Arbiter
  wire [`INT_CMD_SZ-1:0]  imo_arb_cmd;
  wire                    imo_arb_valid;
  wire [59:0]             imo_arb_addr;
  wire                    imo_arb_ack;
  
  // PerOps Controller <-> Arbiter
  wire [`INT_CMD_SZ-1:0]  poc_arb_cmd;
  wire                    poc_arb_valid;
  wire [59:0]             poc_arb_addr;
  wire                    poc_arb_ack;  
  
  // Control Register File 
  wire [3:0]   cr_waddr;
  wire [31:0]  cr_wdata;
  wire         cr_wvalid;
  
  // Customizable DDRX timings
  wire [3:0]  rc_t1;
  wire [3:0]  rc_t2;
  wire [3:0]  rlrd_t1;
  
  // D-RaNGe parameters
  wire [31:0]         rng_prd;
  wire [`ADDR_SZ-1:0] rng_addr;
  wire [8:0]          rng_idx1;
  wire [8:0]          rng_idx2;
  wire [8:0]          rng_idx3;
  wire [8:0]          rng_idx4;
  wire                rng_boost_enable;

  
  // POC <-> IMOC
  wire [3:0]          rng_bits;
  wire                rng_valid;
  wire                rng_fifo_full;
  
  // Scheduler misc. signals
  wire                scd_rd_en;
  wire [5:0]          scd_rd_flag;   
  wire [5:0]          phy_rd_flag;
  // We associate some metadata to reads.
  // Some of them need to go through the
  // periodic ops controller, others go to AXI
  read_metadata_fifo rmf
  (
    .clk(clk),
    .srst(rst),
    .full(),
    .empty(),
    .din(scd_rd_flag),
    .wr_en(scd_rd_en),
    .rd_en(phy_rddata_valid),
    .dout(phy_rd_flag)
  );
 
  // Clock converted AXI signals go through the 
  // axi_to_mc and get converted to an internal
  // simpler format.
  axi_to_mc amc(
    .arb_rack(arb_axi_rack),
    .arb_wack(arb_axi_wack),
    .arb_wrdata(axi_arb_wrdata),
    .arb_wrdata_mask(axi_arb_wrdata_mask),
    .arb_rdaddr(axi_arb_rdaddr),
    .arb_wraddr(axi_arb_wraddr),
    .arb_wren(axi_arb_wren),
    .arb_rden(axi_arb_rden),
    .arb_rddata(phy_rd_data),
    .arb_rdvalid(phy_rddata_valid & phy_rd_flag[`REGULAR_READ_OFS]),
    .S_AXI_ACLK(clk),
    .S_AXI_ARESETN(~rst),
    .S_AXI_AWID       (S_AXI_AWID),
    .S_AXI_AWADDR     (S_AXI_AWADDR),
    .S_AXI_AWLEN      (S_AXI_AWLEN),
    .S_AXI_AWSIZE     (S_AXI_AWSIZE),
    .S_AXI_AWBURST    (S_AXI_AWBURST),
    .S_AXI_AWLOCK     (S_AXI_AWLOCK),
    .S_AXI_AWCACHE    (S_AXI_AWCACHE),
    .S_AXI_AWPROT     (S_AXI_AWPROT),
    .S_AXI_AWQOS      (S_AXI_AWQOS),
    .S_AXI_AWVALID    (S_AXI_AWVALID),
    .S_AXI_AWREADY    (S_AXI_AWREADY),
    .S_AXI_WDATA      (S_AXI_WDATA),
    .S_AXI_WSTRB      (S_AXI_WSTRB),
    .S_AXI_WLAST      (S_AXI_WLAST),
    .S_AXI_WVALID     (S_AXI_WVALID),
    .S_AXI_WREADY     (S_AXI_WREADY),
    .S_AXI_BID        (S_AXI_BID),
    .S_AXI_BRESP      (S_AXI_BRESP),
    .S_AXI_BVALID     (S_AXI_BVALID),
    .S_AXI_BREADY     (S_AXI_BREADY),
    .S_AXI_ARID       (S_AXI_ARID), 
    .S_AXI_ARADDR     (S_AXI_ARADDR), 
    .S_AXI_ARLEN      (S_AXI_ARLEN), 
    .S_AXI_ARSIZE     (S_AXI_ARSIZE), 
    .S_AXI_ARBURST    (S_AXI_ARBURST),
    .S_AXI_ARLOCK     (S_AXI_ARLOCK), 
    .S_AXI_ARCACHE    (S_AXI_ARCACHE),
    .S_AXI_ARPROT     (S_AXI_ARPROT), 
    .S_AXI_ARQOS      (S_AXI_ARQOS), 
    .S_AXI_ARVALID    (S_AXI_ARVALID),
    .S_AXI_ARREADY    (S_AXI_ARREADY),
    .S_AXI_RID        (S_AXI_RID), 
    .S_AXI_RDATA      (S_AXI_RDATA), 
    .S_AXI_RRESP      (S_AXI_RRESP), 
    .S_AXI_RLAST      (S_AXI_RLAST), 
    .S_AXI_RVALID     (S_AXI_RVALID), 
    .S_AXI_RREADY     (S_AXI_RREADY) 
  );
  
  imo_controller imoc(
    .clk(clk),
    .rst(rst),
    
    .imo_req_valid(imo_req_valid),
    .imo_req_ack(imo_req_ack),
    .imo_req_inst(imo_req_inst),
    
    .imo_resp_data(imo_resp_data),
    .imo_resp_valid(imo_resp_valid),
    
    .arb_cmd(imo_arb_cmd),
    .arb_addr(imo_arb_addr),
    .arb_valid(imo_arb_valid),
    .arb_ack(imo_arb_ack),
    
    .rng_fifo_full(rng_fifo_full),
    .rng_valid(rng_valid),
    .rng_bits(rng_bits),
    
    .cr_waddr(cr_waddr),
    .cr_wdata(cr_wdata),
    .cr_wvalid(cr_wvalid)  
  );


  perops_controller poc(
    .clk(clk),
    .rst(rst | ~init_calib_complete),
    
    .phy_rddata(phy_rd_data),
    .phy_rdvalid(phy_rddata_valid & phy_rd_flag[`RNG_READ_OFS]),
    
    .arb_cmd(poc_arb_cmd),
    .arb_addr(poc_arb_addr),
    .arb_valid(poc_arb_valid),
    .arb_ack(poc_arb_ack),
    
    .rng_fifo_full(rng_fifo_full),
    .rng_valid(rng_valid),
    .rng_bits(rng_bits), 
    
    .rng_prd(rng_prd),
    .rng_addr(rng_addr),
    .rng_idx1(rng_idx1),
    .rng_idx2(rng_idx2),
    .rng_idx3(rng_idx3),
    .rng_idx4(rng_idx4)
  );
   
  scheduler scd(
    .clk(clk),
    .rst(rst),
    
    .axi_rack(arb_axi_rack),
    .axi_wack(arb_axi_wack),
    .axi_rdaddr(axi_arb_rdaddr),
    .axi_wraddr(axi_arb_wraddr),
    .axi_wren(axi_arb_wren),
    .axi_rden(axi_arb_rden),
    
    .imo_addr(imo_arb_addr),
    .imo_cmd(imo_arb_cmd),
    .imo_valid(imo_arb_valid),
    .imo_ack(imo_arb_ack),
    
    .poc_addr(poc_arb_addr),
    .poc_cmd(poc_arb_cmd),
    .poc_valid(poc_arb_valid),
    .poc_ack(poc_arb_ack),
    
    .rc_t1(rc_t1),
    .rc_t2(rc_t2),
    .rlrd_t1(rlrd_t1),
    .rng_boost_enable(rng_boost_enable),
    .rng_fifo_full(rng_fifo_full),
    
    // PHY Converter
    .phy_cmd(scd_phy_cmd),
    .phy_row(scd_phy_row),
    .phy_bank(scd_phy_bank),
    .phy_col(scd_phy_col),
    
    .rd_flag(scd_rd_flag),
    .rd_en(scd_rd_en) 
  );
   
  scd_phy_conv phy_conv
  (
    .clk(clk),
    .rst(rst),
    .init_calib_complete(init_calib_complete),
  
    .scd_cmd(scd_phy_cmd), 
    .scd_row(scd_phy_row),
    .scd_bank(scd_phy_bank),
    .scd_col(scd_phy_col),
  
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
    .idle(idle),
    .phy_mc_ctl_full(phy_mc_ctl_full),
    .phy_mc_cmd_full(phy_mc_cmd_full),
    .phy_mc_data_full(phy_mc_data_full),
    .calib_rd_data_offset_0(calib_rd_data_offset_0),
    .calib_rd_data_offset_1(calib_rd_data_offset_1),
    .calib_rd_data_offset_2(calib_rd_data_offset_2),
    .wd_fifo_rden(wd_fifo_rden)
  );
    
  wire [511:0] wdata_din = poc_arb_valid ? {512{1'b0}} : axi_arb_wrdata;
  wire [63:0] wdata_mask_din = poc_arb_valid ? 64'h0 : axi_arb_wrdata_mask;  
    
  wrdata_fifo wdf (
    .clk(clk),      // input wire clk
    .rst(rst),    // input wire srst
    .din(wdata_din),      // input wire [511 : 0] din
    .wr_en(arb_axi_wack & axi_arb_wren
        || (poc_arb_cmd[`INT_RNG_OFS] && poc_arb_ack)),  // input wire wr_en
    .rd_en(wd_fifo_rden),  // input wire rd_en
    .dout(mc_wrdata),    // output wire [511 : 0] dout
    .full(),    // output wire full
    .empty()  // output wire empty
  );
  
  wrmask_fifo wmf (
    .clk(clk),      // input wire clk
    .rst(rst),    // input wire srst
    .din(wdata_mask_din),      // input wire [511 : 0] din
    .wr_en((arb_axi_wack && axi_arb_wren)
        || (poc_arb_cmd[`INT_RNG_OFS] && poc_arb_ack)),  // input wire wr_en
    .rd_en(wd_fifo_rden),  // input wire rd_en
    .dout(mc_wrdata_mask),    // output wire [511 : 0] dout
    .full(),    // output wire full
    .empty()  // output wire empty  
  );
  
  cr_file crf(
    .clk(clk),
    .rst(rst),
    
    .cr_waddr(cr_waddr),
    .cr_wdata(cr_wdata),
    .cr_wvalid(cr_wvalid),

    .rc_t1(rc_t1),
    .rc_t2(rc_t2),
    .rlrd_t1(rlrd_t1),
    
    .rng_prd(rng_prd),
    .rng_addr(rng_addr),
    .rng_idx1(rng_idx1),
    .rng_idx2(rng_idx2),
    .rng_idx3(rng_idx3),
    .rng_idx4(rng_idx4),
    .rng_boost_enable(rng_boost_enable)
    );
  
endmodule
