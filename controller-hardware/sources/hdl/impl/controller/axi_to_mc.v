`timescale 1ns / 1ps
`include "parameters.vh"

// I/O definitions taken from demofull.v 

////////////////////////////////////////////////////////////////////////////////
//  Atb: This description is not valid anymore.
//
// Filename: 	demofull.v
//
// Project:	WB2AXIPSP: bus bridges and other odds and ends
//
// Purpose:	Demonstrate a formally verified AXI4 core with a (basic)
//		interface.  This interface is explained below.
//  
// Performance: This core has been designed for a total throughput of one beat
//		per clock cycle.  Both read and write channels can achieve
//	this.  The write channel will also introduce two clocks of latency,
//	assuming no other latency from the master.  This means it will take
//	a minimum of 3+AWLEN clock cycles per transaction of (1+AWLEN) beats,
//	including both address and acknowledgment cycles.  The read channel
//	will introduce a single clock of latency, requiring 2+ARLEN cycles
//	per transaction of 1+ARLEN beats.
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2019-2020, Gisselquist Technology, LLC
//
// This file is part of the WB2AXIP project.
//
// The WB2AXIP project contains free software and gateware, licensed under the
// Apache License, Version 2.0 (the "License").  You may not use this project,
// or this file, except in compliance with the License.  You may obtain a copy
// of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
// License for the specific language governing permissions and limitations
// under the License.
//
////////////////////////////////////////////////////////////////////////////////
module axi_to_mc #(
	parameter integer C_S_AXI_ID_WIDTH	= 6,
	parameter integer C_S_AXI_DATA_WIDTH	= 64,
	parameter integer C_S_AXI_ADDR_WIDTH	= 32,
	// Some useful short-hand definitions
	localparam	AW = C_S_AXI_ADDR_WIDTH,
	localparam	DW = C_S_AXI_DATA_WIDTH,
	localparam	IW = C_S_AXI_ID_WIDTH,

	parameter [0:0]	OPT_NARROW_BURST = 1
	) (
		// Users to add ports here
  
    input wire arb_wack,
    input wire arb_rack,
    input wire [511:0] arb_rddata,
    output wire [511:0] arb_wrdata,
    output wire [63:0] arb_wrdata_mask,
    output reg  [29:0] arb_rdaddr,
    output reg  [29:0] arb_wraddr,
    output reg arb_wren,
    output reg arb_rden,
    input wire arb_rdvalid,
		//
		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write Address ID
		input wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_AWID , //****COVERED****
		// Write address
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR, //****COVERED****
		// Burst length. The burst length gives the exact number of
		// transfers in a burst
		input wire [7 : 0] S_AXI_AWLEN, //****COVERED****
		// Burst size. This signal indicates the size of each transfer
		// in the burst
		input wire [2 : 0] S_AXI_AWSIZE, //****Assume 8****
		// Burst type. The burst type and the size information,
		// determine how the address for each transfer within the burst
		// is calculated.
		input wire [1 : 0] S_AXI_AWBURST, //****Assume 0****
		// Lock type. Provides additional information about the
		// atomic characteristics of the transfer.
		input wire  S_AXI_AWLOCK, //****NONEED****
		// Memory type. This signal indicates how transactions
		// are required to progress through a system.
		input wire [3 : 0] S_AXI_AWCACHE, //****NONEED****
		// Protection type. This signal indicates the privilege
		// and security level of the transaction, and whether
		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT, //****NONEED****
		// Quality of Service, QoS identifier sent for each
		// write transaction.
		input wire [3 : 0] S_AXI_AWQOS, //****NONEED****
		// Region identifier. Permits a single physical interface
		// on a slave to be used for multiple logical interfaces.
		// Write address valid. This signal indicates that
		// the channel is signaling valid write address and
		// control information.
		input wire  S_AXI_AWVALID, //****COVERED****
		// Write address ready. This signal indicates that
		// the slave is ready to accept an address and associated
		// control signals.
		output wire  S_AXI_AWREADY, //****COVERED****
		// Write Data
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA, //****COVERED****
		// Write strobes. This signal indicates which byte
		// lanes hold valid data. There is one write strobe
		// bit for each eight bits of the write data bus.
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB, //****NOT-COVERED****
		// Write last. This signal indicates the last transfer
		// in a write burst.
		input wire  S_AXI_WLAST, //****COVERED****
		// Optional User-defined signal in the write data channel.
		// Write valid. This signal indicates that valid write
		// data and strobes are available.
		input wire  S_AXI_WVALID, //****COVERED****
		// Write ready. This signal indicates that the slave
		// can accept the write data.
		output wire  S_AXI_WREADY, //****COVERED****
		// Response ID tag. This signal is the ID tag of the
		// write response.
		output wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_BID, //****COVERED****
		// Write response. This signal indicates the status
		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP, //****COVERED****
		// Optional User-defined signal in the write response channel.
		// Write response valid. This signal indicates that the
		// channel is signaling a valid write response.
		output wire  S_AXI_BVALID, //****COVERED****
		// Response ready. This signal indicates that the master
		// can accept a write response.
		input wire  S_AXI_BREADY, //****COVERED****
		// Read address ID. This signal is the identification
		// tag for the read address group of signals.
		input wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_ARID, //****COVERED****
		// Read address. This signal indicates the initial
		// address of a read burst transaction.
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR, //****COVERED****
		// Burst length. The burst length gives the exact number of
		// transfers in a burst
		input wire [7 : 0] S_AXI_ARLEN, //****COVERED****
		// Burst size. This signal indicates the size of each transfer
		// in the burst
		input wire [2 : 0] S_AXI_ARSIZE, //****Assume its fixed to 8****
		// Burst type. The burst type and the size information,
		// determine how the address for each transfer within the
		// burst is calculated.
		input wire [1 : 0] S_AXI_ARBURST, //****Assume its fixed****
		// Lock type. Provides additional information about the
		// atomic characteristics of the transfer.
		input wire  S_AXI_ARLOCK, //****DO WE NEED THIS?****
		// Memory type. This signal indicates how transactions
		// are required to progress through a system.
		input wire [3 : 0] S_AXI_ARCACHE, //****DO WE NEED THIS?****
		// Protection type. This signal indicates the privilege
		// and security level of the transaction, and whether
		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT, //****DO WE NEED THIS?****
		// Quality of Service, QoS identifier sent for each
		// read transaction.
		input wire [3 : 0] S_AXI_ARQOS, //****DO WE NEED THIS?****
		// Region identifier. Permits a single physical interface
		// on a slave to be used for multiple logical interfaces.
		// Optional User-defined signal in the read address channel.
		// Write address valid. This signal indicates that
		// the channel is signaling valid read address and
		// control information.
		input wire  S_AXI_ARVALID, //****COVERED****
		// Read address ready. This signal indicates that
		// the slave is ready to accept an address and associated
		// control signals.
		output wire  S_AXI_ARREADY, //****COVERED****
		// Read ID tag. This signal is the identification tag
		// for the read data group of signals generated by the slave.
		output wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_RID, //****COVERED****
		// Read Data
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA, //****COVERED****
		// Read response. This signal indicates the status of
		// the read transfer.
		output wire [1 : 0] S_AXI_RRESP, //****COVERED****
		// Read last. This signal indicates the last transfer
		// in a read burst.
		output wire  S_AXI_RLAST, //****COVERED****
		// Optional User-defined signal in the read address channel.
		// Read valid. This signal indicates that the channel
		// is signaling the required read data.
		output wire  S_AXI_RVALID, //****COVERED****
		// Read ready. This signal indicates that the master can
		// accept the read data and response information.
		input wire  S_AXI_RREADY //****COVERED****
  );
	
	// This is a very simple AXI slave designed to
	// communicate the rocket-chip with our memory controller.
	// We have a few assumptions on requests
	//   i. Burst length will be <= 8
	//   ii. Bursts will start&finish in the same cache block
	//   iii. More assumptions on other AXI4 control signals
	//         listed in module I/O definitions
	
	
	//--------------------------------------------------------
	//-------------------AR & R CHANNELS----------------------
	//--------------------------------------------------------
	localparam R_IDLE_S = 0;
	localparam R_REQ_S  = 1;
	localparam R_WAIT_S = 2;
	localparam R_RESP_S = 3;
	
	reg[3:0] r_state_r, r_state_ns;
	
	reg [7:0] arlen_r, arlen_ns;
	reg [AW-1:0] araddr_r, araddr_ns;
	reg [IW-1:0] arid_r, arid_ns;
	// Where in rddata_r this burst's data reside
  reg [8:0] r_burst_offset_r, r_burst_offset_ns; 
	reg [511:0] rddata_r, rddata_ns;

  (*dont_touch = "true"*) reg [39:0] ar_transaction_ctr;
  (*dont_touch = "true"*) reg [39:0] r_transaction_ctr;

	// AR&R CHANNEL
  always @(*) begin
    r_state_ns = r_state_r;
    arlen_ns  = arlen_r;
    araddr_ns = araddr_r;
    arid_ns   = arid_r;
    rddata_ns = rddata_r;
    r_burst_offset_ns = r_burst_offset_r;
    arb_rden = 1'b0;
    // Mask non-zero column-offsets
    arb_rdaddr  = araddr_r & {{27{1'b1}},3'b0};
    case(r_state_r)
    R_IDLE_S: begin
      if(S_AXI_ARREADY & S_AXI_ARVALID) begin
        arlen_ns    = S_AXI_ARLEN;
        araddr_ns   = S_AXI_ARADDR;
        arid_ns     = S_AXI_ARID;
        r_burst_offset_ns = S_AXI_ARADDR[3+:3];      
        r_state_ns  = R_REQ_S;
      end    
    end
    R_REQ_S: begin
      arb_rden    = 1'b1;
      if(arb_rack)
        r_state_ns = R_WAIT_S; 
    end
    R_WAIT_S: begin
      if(arb_rdvalid) begin // MC responds with cache block
        rddata_ns  = arb_rddata;
        r_state_ns = R_RESP_S; 
      end
    end
    R_RESP_S: begin
      // The idea here is to advance the state
      // when rocket-chip can accept our data 
      if(S_AXI_RREADY) begin
        if(arlen_r == 0)
          r_state_ns = R_IDLE_S;
        else
          arlen_ns = arlen_r - 1;
        r_burst_offset_ns = r_burst_offset_r + 1;
      end
    end
    endcase
  end
  
  always @(posedge S_AXI_ACLK) begin
    if(~S_AXI_ARESETN) begin
      r_state_r <= R_IDLE_S;
      arlen_r   <= 0;
      r_transaction_ctr <= 0;
      ar_transaction_ctr <= 0;
    end
    else begin
      if(S_AXI_ARREADY && S_AXI_ARVALID)
        ar_transaction_ctr <= ar_transaction_ctr + 1;
      else
        ar_transaction_ctr <= ar_transaction_ctr;
      if(S_AXI_RREADY && S_AXI_RVALID)
        r_transaction_ctr <= r_transaction_ctr + 1;
      else
        r_transaction_ctr <= r_transaction_ctr;      
      r_state_r <= r_state_ns;
      arlen_r   <= arlen_ns;
      araddr_r  <= araddr_ns;
      arid_r    <= arid_ns;
      rddata_r  <= rddata_ns;
      r_burst_offset_r <= r_burst_offset_ns;
    end
  end
  
  assign S_AXI_ARREADY = r_state_r == R_IDLE_S;
  assign S_AXI_RID     = arid_r;
  assign S_AXI_RDATA   = rddata_r[r_burst_offset_r << 6 +: 64];
  assign S_AXI_RLAST   = arlen_r == 0; // Will this cause problems?
  assign S_AXI_RVALID  = r_state_r == R_RESP_S;	
  assign S_AXI_RRESP   = 0;
  
	//--------------------------------------------------------
  //-------------------WR & W CHANNELS----------------------
  //--------------------------------------------------------
	localparam W_IDLE_S = 0;
  localparam W_ACC_S  = 1; // accumulate wr burst
  localparam W_REQ_S  = 2;
  localparam W_RESP_S = 3;
  
  reg[3:0] w_state_r, w_state_ns;
  
  reg bvalid_r, bvalid_ns;
  reg [7:0] awlen_r, awlen_ns;
  reg [AW-1:0] awaddr_r, awaddr_ns;
  reg [IW-1:0] awid_r, awid_ns;
  // Where in rddata_r this burst's data reside
  reg [8:0] w_burst_offset_r, w_burst_offset_ns; 
  reg [511:0] wrdata_r, wrdata_ns;
  reg [63:0] wrdata_mask_r, wrdata_mask_ns;

  // AR&R CHANNEL
  always @(*) begin
    w_state_ns = w_state_r;
    bvalid_ns = bvalid_r;
    awlen_ns  = awlen_r;
    awaddr_ns = awaddr_r;
    awid_ns   = awid_r;
    wrdata_ns = wrdata_r;
    arb_wren = 1'b0;
    w_burst_offset_ns = w_burst_offset_r;
    wrdata_mask_ns = wrdata_mask_r;
    arb_wraddr  = awaddr_r & {{27{1'b1}},3'b0}; 
    case(w_state_r)
    W_IDLE_S: begin
      if(S_AXI_AWREADY & S_AXI_AWVALID) begin
        awlen_ns    = S_AXI_AWLEN;
        awaddr_ns   = S_AXI_AWADDR;
        awid_ns     = S_AXI_AWID;
        w_burst_offset_ns = S_AXI_AWADDR[3+:3];      
        w_state_ns  = W_ACC_S;
        wrdata_mask_ns = {64{1'b1}};
      end    
    end
    W_ACC_S: begin
      // We accumulate bursts in wrdata reg
      if(S_AXI_WVALID) begin
        if(S_AXI_WLAST) begin
          w_state_ns = W_REQ_S;
        end
        w_burst_offset_ns = w_burst_offset_r + 1;
        wrdata_ns[w_burst_offset_r << 6 +: 64] = S_AXI_WDATA;
        wrdata_mask_ns[w_burst_offset_r << 3 +: 8] = 8'b0; 
      end
    end
    W_REQ_S: begin
      arb_wren    = 1'b1;
      if(arb_wack) begin
        w_state_ns = W_RESP_S;
        bvalid_ns = 1'b1;
      end
    end
    W_RESP_S: begin
      if(S_AXI_BREADY) begin
        bvalid_ns = 1'b0;
        w_state_ns = W_IDLE_S;
      end
    end
    endcase
  end
  
  always @(posedge S_AXI_ACLK) begin
    if(~S_AXI_ARESETN) begin
      w_state_r <= W_IDLE_S;
      bvalid_r  <= 1'b0;
      wrdata_r  <= 0;
    end
    else begin
      w_state_r <= w_state_ns;
      awlen_r   <= awlen_ns;
      awaddr_r  <= awaddr_ns;
      awid_r    <= awid_ns;
      wrdata_r  <= wrdata_ns;
      w_burst_offset_r <= w_burst_offset_ns;
      bvalid_r  <= bvalid_ns;
      wrdata_mask_r <= wrdata_mask_ns;
    end
  end
  
  assign S_AXI_AWREADY = w_state_r == W_IDLE_S;
  assign S_AXI_WID     = awid_r;
  assign S_AXI_WREADY  = w_state_r == W_ACC_S; 
       
  assign S_AXI_BVALID  = bvalid_r;
  assign S_AXI_BID     = awid_r; 
  assign S_AXI_BRESP   = 0;
 
  assign arb_wrdata       = wrdata_r;
  assign arb_wrdata_mask  = wrdata_mask_r;

endmodule