`timescale 1ns / 1ps

module tb_controller_top(

  );

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
    
  controller_top ctop
  (
        input                     clk,
        input                     rst,
        input                     rcclk,
        input                     rcrst,
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
    
    
    
    
    
    
endmodule
