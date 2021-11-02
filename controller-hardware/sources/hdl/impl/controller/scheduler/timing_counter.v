`timescale 1ns / 1ps
`include "util.vh"

module timing_counter #(
  parameter nCK_PER_CLK = 4,
  parameter DDR_PRD     = 2.5,
  parameter TP          = 35)
  (
    input clk,
    input rst,
    input start,
    input [(`CLOG2(nCK_PER_CLK))-1:0] slot, 
    
    output [(`CLOG2(nCK_PER_CLK))-1:0] offset,
    output done
  );
  
  localparam integer CTR_VAL  = (TP-(nCK_PER_CLK*DDR_PRD))/DDR_PRD;
 
  reg [(`CLOG2(TP)):0] counter_r;
  assign done   = counter_r < nCK_PER_CLK;
  assign offset = counter_r[nCK_PER_CLK-1:0] ;
  
  always @(posedge clk) begin
    if(rst) begin
      counter_r <= CTR_VAL;
    end
    else begin
      if(start) begin
        counter_r <= CTR_VAL + slot;      
      end
      else begin
        if(counter_r < nCK_PER_CLK)
          counter_r = 0;
        else
          counter_r = counter_r - nCK_PER_CLK;
      end
    end
    
  end
  
endmodule
