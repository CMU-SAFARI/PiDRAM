`timescale 1ns / 1ps
`include "encoding.vh"

module cr_file(
  input clk,
  input rst,

  input [3:0]   cr_waddr,
  input [31:0]  cr_wdata,
  input         cr_wvalid,
  
  // Customizable DDRX timings
  output [3:0]  rc_t1,
  output [3:0]  rc_t2,
  output [3:0]  rlrd_t1,
  
  // D-RaNGe parameters
  output [31:0]         rng_prd,
  output [`ADDR_SZ:0]   rng_addr,
  output [8:0]         rng_idx1,
  output [8:0]         rng_idx2,
  output [8:0]         rng_idx3,
  output [8:0]         rng_idx4,
  output               rng_boost_enable
  );
  
  (*dont_touch = "TRUE"*) reg [31:0] cr_rf [15:0];
  
  assign rc_t1 = cr_rf[0][3:0];
  assign rc_t2 = cr_rf[0][7:4];
  assign rlrd_t1 = cr_rf[0][11:8];
  
  assign rng_prd  = cr_rf[1];
  assign rng_addr = cr_rf[2];
  assign rng_idx1 = cr_rf[3][8:0];
  assign rng_idx2 = cr_rf[3][24:16];
  assign rng_idx3 = cr_rf[4][8:0];
  assign rng_idx4 = cr_rf[4][24:16];
  assign rng_boost_enable = cr_rf[5][0];
  
  integer i;
  
  always @(posedge clk) begin
    if(rst) begin
      // timing register 
      // rc_t1&t2 = 12.5ns
      // tRCD = 10 ns
      cr_rf[0] <= 32'h00000455;
      for (i = 1 ; i < 16 ; i = i+1) begin
        cr_rf[i] <= 0;
      end
    end
    else begin
      for (i = 0 ; i < 16 ; i = i+1) begin
        cr_rf[i] <= cr_wvalid && (cr_waddr == i) ? 
                    cr_wdata : cr_rf[i];
      end
    end
  end
  
endmodule
