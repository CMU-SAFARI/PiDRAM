`timescale 1ns / 1ps
`include "encoding.vh"
`include "parameters.vh"

module perops_controller(
  input clk,
  input rst,
  
  input [511:0]        phy_rddata,
  input                phy_rdvalid,
  
  // To command arbiter
  output [`INT_CMD_SZ-1:0]  arb_cmd,
  output [59:0]             arb_addr,
  output                    arb_valid,
  input                     arb_ack,
  
  // RNG I/O
  input                rng_fifo_full,
  output               rng_valid,
  output [3:0]         rng_bits, 

  // D-RaNGe parameters
  input [31:0]         rng_prd,
  input [`ADDR_SZ-1:0] rng_addr,
  input [8:0]          rng_idx1,
  input [8:0]          rng_idx2,
  input [8:0]          rng_idx3,
  input [8:0]          rng_idx4
  );
    
  // Periodic RNG controller signals
  reg        per_rng_req;
    
  reg [1:0]  rng_state_r, rng_state_ns;
  reg [31:0] rng_ctr_r, rng_ctr_ns;
  
  reg [3:0]  rng_bits_r, rng_bits_ns;
  reg        rng_valid_r, rng_valid_ns;
  
  wire [`INT_CMD_SZ-1:0] rng_cmd_op     = 1 << `INT_RNG_OFS;
  wire [59:0]            rng_cmd_addr   = rng_addr;
  
  assign rng_valid = rng_valid_r;
  assign rng_bits  = rng_bits_r;
  
  // Periodic REF controller signals
  reg        per_ref_req;
    
  reg [1:0]  ref_state_r, ref_state_ns;
  reg [31:0] ref_ctr_r, ref_ctr_ns;
  
  wire [`INT_CMD_SZ-1:0] ref_cmd_op     = 1 << `INT_REF_OFS;
  
  // refresh has higher priority
  assign arb_valid  = per_rng_req | per_ref_req; // TODO: Turn this on
  assign arb_cmd    = per_ref_req ? ref_cmd_op : rng_cmd_op;
  assign arb_addr   = rng_cmd_addr;
  wire per_ref_ack  = arb_ack;
  wire per_rng_ack  = arb_ack & ~per_ref_req;
  
  // ################## Periodic RNG Controller ##################
  localparam RNG_WAIT_S = 0;
  localparam RNG_REQ_S  = 1;
  localparam RNG_RESP_S = 2;
  
  
  
  always @* begin
    rng_state_ns  = rng_state_r;
    rng_ctr_ns    = rng_ctr_r == 0 ? rng_ctr_r : rng_ctr_r - 1;
    rng_valid_ns  = phy_rdvalid;
    rng_bits_ns   = {phy_rddata[rng_idx1],phy_rddata[rng_idx2],phy_rddata[rng_idx3],phy_rddata[rng_idx4]};
    per_rng_req   = 1'b0;
    case(rng_state_r)
      RNG_WAIT_S: begin
        // if period == 0, stop rng requests
        if ((rng_prd > 0) && (rng_ctr_r == 0) && !rng_fifo_full) begin
          rng_ctr_ns = rng_prd;
          rng_state_ns = RNG_REQ_S;
        end
      end
      RNG_REQ_S: begin
        per_rng_req = 1'b1;
        if(per_rng_ack) begin
          rng_state_ns = RNG_WAIT_S;
        end
        
      end
//      RNG_RESP_S: begin
//        if(phy_rdvalid) begin
//          rng_state_ns  = RNG_WAIT_S;
//          // TODO: maybe this should come one cycle later?
//          rng_bits_ns   = {phy_rddata[rng_idx1],phy_rddata[rng_idx2],phy_rddata[rng_idx3],phy_rddata[rng_idx4]};
//          rng_valid_ns  = 1'b1;
//        end
//      end
    endcase
  end
  
  always @(posedge clk) begin
    if(rst) begin
      rng_ctr_r <= 0;
      rng_bits_r <= 0;
      rng_valid_r <= 0;
      rng_state_r <= RNG_WAIT_S;
    end
    else begin
      rng_state_r <= rng_state_ns;
      rng_ctr_r <= rng_ctr_ns;      
      rng_bits_r <= rng_bits_ns;      
      rng_valid_r <= rng_valid_ns;      
    end
  end
  
  // ################## Periodic REFRESH Controller ##################
  localparam REF_WAIT_S = 0;
  localparam REF_REQ_S  = 1;
  localparam REF_RESP_S = 2;
  
  always @* begin
    ref_state_ns  = ref_state_r;
    ref_ctr_ns    = ref_ctr_r == 0 ? ref_ctr_r : ref_ctr_r - 1;
    per_ref_req   = 1'b0;
    case(ref_state_r)
      REF_WAIT_S: begin
        if (ref_ctr_r == 0) begin
          ref_ctr_ns = `REF_PRD;
          ref_state_ns = REF_REQ_S;
        end
      end
      REF_REQ_S: begin
        per_ref_req = 1'b1;
        if(per_ref_ack) begin
          ref_state_ns = REF_WAIT_S;
        end
      end
    endcase
  end
  
  always @(posedge clk) begin
    if(rst) begin
      rng_ctr_r <= 0;
      rng_bits_r <= 0;
      rng_valid_r <= 0;
      rng_state_r <= RNG_WAIT_S;
      
      ref_ctr_r <= 0;
      ref_state_r <= REF_WAIT_S;
    end
    else begin
      rng_state_r <= rng_state_ns;
      rng_ctr_r <= rng_ctr_ns;      
      rng_bits_r <= rng_bits_ns;      
      rng_valid_r <= rng_valid_ns;    
      
      ref_ctr_r <= ref_ctr_ns;
      ref_state_r <= ref_state_ns;
    end
  end
  
endmodule
