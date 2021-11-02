`timescale 1ns / 1ps
`include "util.vh"

module violated_timing_counter #(parameter nCK_PER_CLK = 4)
  (
    input clk,
    input rst,
    input start,
    input [(`CLOG2(nCK_PER_CLK))-1:0] slot, 
    
    input [3:0] tp,
    
    output [(`CLOG2(nCK_PER_CLK))-1:0] offset,
    output done
  );
  
  wire  [3:0] init_value = tp + slot < 4'd4 ? tp + slot : tp + slot - 4'd4;
  reg   [3:0] counter_r;
  assign done   = counter_r < nCK_PER_CLK;
  assign offset = counter_r[nCK_PER_CLK-1:0] ;
  
  always @(posedge clk) begin
    if(rst) begin
      counter_r <= init_value;
    end
    else begin
      if(start) begin
        counter_r <= init_value;      
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
