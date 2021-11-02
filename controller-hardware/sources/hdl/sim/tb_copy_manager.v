`timescale 1ns / 1ps
`include "encoding.vh"

module tb_copy_manager(
  input                      clk,
  input                      rst,
  input                      init_calib_complete,

  // IMO (Rocket-Chip) Controller <-> Memory Controller 
  output reg                imo_req_valid,
  input                     imo_req_ack,
  output reg [127:0]        imo_req_inst,
  
  input [511:0]             imo_resp_data,
  input                     imo_resp_valid
  );
  
  localparam IDLE_S         = 0;
  localparam TIMINGPARAMS_S = 1;
  localparam RNGPARAMS_S    = 2;
  localparam RNGPARAMS2_S   = 3;
  localparam RNGPARAMS3_S   = 4;
  localparam RLRD_S         = 5;
  localparam COPY_S         = 6;
  localparam RDRNGSIZE_S    = 7;
  localparam RDRNGBITS_S    = 8;
  localparam FIN_S          = 9;
  localparam RNGPARAMS4_S   = 10;


  reg[5:0] state_r, state_ns;

  always @* begin
    state_ns      = state_r;
    imo_req_valid = 0;
    imo_req_inst  = 0;
    case(state_r)
      IDLE_S: begin
        if(init_calib_complete) begin;
          state_ns = TIMINGPARAMS_S;
          //state_ns = IDLE_S;
        end
      end
      TIMINGPARAMS_S: begin
        imo_req_valid = 1'b1;
        imo_req_inst[`IMO_OP_OFS +: 16] = 1 << `IMO_WR_CR;
        imo_req_inst[32+:4] = 0;
        imo_req_inst[0+:12] = 12'h313;
        if(imo_req_ack) begin
          state_ns = RNGPARAMS_S;
        end
      end
      RNGPARAMS3_S: begin
        imo_req_valid = 1'b1;
        imo_req_inst[`IMO_OP_OFS +: 16] = 1 << `IMO_WR_CR;
        imo_req_inst[32+:4] = 4'b0001;
        imo_req_inst[0+:32] = 32'd10; // 10 ns * 10 = 100ns
        if(imo_req_ack) begin
          state_ns = RNGPARAMS4_S;
        end
      end
      RNGPARAMS4_S: begin
        imo_req_valid = 1'b1;
        imo_req_inst[`IMO_OP_OFS +: 16] = 1 << `IMO_WR_CR;
        imo_req_inst[32+:4] = 4'd5;
        imo_req_inst[0+:32] = 32'd1; // boost enable
        if(imo_req_ack) begin
          state_ns = RLRD_S;
        end
      end      
      RNGPARAMS_S: begin
        imo_req_valid = 1'b1;
        imo_req_inst[`IMO_OP_OFS +: 16] = 1 << `IMO_WR_CR;
        imo_req_inst[32+:4] = 4'b0010;
        imo_req_inst[0+:32] = 32'h01010080; // bank 1 ? row X col 16?
        if(imo_req_ack) begin
          state_ns = RNGPARAMS2_S;
        end
      end
      RNGPARAMS2_S: begin
        imo_req_valid = 1'b1;
        imo_req_inst[`IMO_OP_OFS +: 16] = 1 << `IMO_WR_CR;
        imo_req_inst[32+:4] = 4'b0011;
        imo_req_inst[0+:8] = 32'h11; // bit 17
        imo_req_inst[16+:8] = 32'h81; // bit X
        if(imo_req_ack) begin
          state_ns = RNGPARAMS3_S;
        end
      end
      RLRD_S: begin
        imo_req_valid = 1'b1;
        imo_req_inst[`IMO_OP_OFS +: 16] = 1 << `IMO_RLRD_OFS;
        imo_req_inst[0+:32] = 32'h000000; // firts row and column
        if(imo_req_ack) begin
          state_ns = COPY_S;
        end
      end
      COPY_S: begin
        imo_req_valid = 1'b1;
        imo_req_inst[`IMO_OP_OFS +: 16] = 1 << `IMO_COPY_OFS;
        imo_req_inst[0+:32] = 32'h00002000; // row1
        imo_req_inst[32+:32] = 32'h00006000; // row3
        if(imo_req_ack) begin
          state_ns = RDRNGSIZE_S;
        end       
      end
      RDRNGSIZE_S: begin
        imo_req_valid = 1'b1;
        imo_req_inst[`IMO_OP_OFS +: 16] = 1 << `IMO_RNGBUFSZ_OFS;
        if(imo_req_ack) begin
          state_ns = RDRNGBITS_S;
        end       
      end
      RDRNGBITS_S: begin
        imo_req_valid = 1'b1;
        imo_req_inst[`IMO_OP_OFS +: 16] = 1 << `IMO_RNG_OFS;
        if(imo_req_ack) begin
          state_ns = FIN_S;
        end       
      end
    endcase
  end

  always @(posedge clk) begin
    if(rst) begin
      state_r     <= IDLE_S;
    end
    else begin
      state_r     <= state_ns;
    end
  end
  
endmodule
