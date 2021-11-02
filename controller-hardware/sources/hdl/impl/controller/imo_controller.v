`timescale 1ns / 1ps
`include "encoding.vh"


module imo_controller(
  input                         clk,
  input                         rst,
  
  (*dont_touch = "TRUE"*) input                         imo_req_valid,
  (*dont_touch = "TRUE"*) output                        imo_req_ack,
  (*dont_touch = "TRUE"*) input [127:0]                 imo_req_inst,
  
  output [511:0]                imo_resp_data,
  output                        imo_resp_valid,
  
  output reg [`INT_CMD_SZ-1:0]  arb_cmd,
  output reg                    arb_valid,
  output reg [59:0]             arb_addr,
  input                         arb_ack,
  
  output                        rng_fifo_full,
  
  input                         rng_valid,
  input  [3:0]                  rng_bits,
  
  output reg [3:0]                   cr_waddr,
  output reg [31:0]                  cr_wdata,
  output reg                         cr_wvalid
  );

  reg [127:0] imo_req_inst_ns, imo_req_inst_r;
  reg         imo_req_ack_ns, imo_req_ack_r;
  
  reg [511:0] imo_resp_data_ns, imo_resp_data_r;
  reg imo_resp_valid_ns, imo_resp_valid_r;
  
  assign imo_req_ack    = imo_req_ack_r;
  assign imo_resp_data  = imo_resp_data_r;
  assign imo_resp_valid = imo_resp_valid_r;

  localparam IDLE_S = 0;
  localparam HNDL_S = 1;
  localparam RESP_S = 2;
  localparam WAIT_S = 3;
    
  reg [3:0] state_r, state_ns;
    
  wire [`IMO_OP_SZ-1:0] opcode    = imo_req_inst_r[`IMO_OP_OFS +: `IMO_OP_SZ];
  wire is_read_rng_available      = opcode[`IMO_RNGBUFSZ_OFS];
  wire is_read_rng                = opcode[`IMO_RNG_OFS];
  wire is_write_cr                = opcode[`IMO_WR_CR];
  wire [`IMO_OP_SZ-1:0] opcode_ns = imo_req_inst[`IMO_OP_OFS +: `IMO_OP_SZ];
  wire fast_response              = opcode_ns[`IMO_RNGBUFSZ_OFS] | opcode_ns[`IMO_RNG_OFS] | opcode_ns[`IMO_WR_CR]; 
  wire is_rlrd                    = opcode[`IMO_RLRD_OFS];
  wire is_copy                    = opcode[`IMO_COPY_OFS];

  wire [31:0] rn;
  (*dont_touch = "TRUE"*) reg         rd_rn;
  (*dont_touch = "TRUE"*) wire [7:0]  rn_word_count;

  reg  [3:0]  wait_ctr;

  always @* begin
    imo_resp_data_ns  = imo_resp_data_r; // ???
    state_ns          = state_r; 
    imo_req_ack_ns    = 1'b0;
    imo_resp_valid_ns = 1'b0;
    arb_valid         = 1'b0;
    arb_addr          = 60'bx;
    arb_cmd           = {`INT_CMD_SZ{1'bx}};
    cr_wvalid         = 1'b0;
    cr_waddr          = 4'bx;
    cr_wdata          = 32'bx;
    rd_rn             = 1'b0;     
    imo_req_inst_ns   = imo_req_inst_r;
    case(state_r)
      IDLE_S: begin
        if(imo_req_valid) begin
          imo_req_inst_ns = imo_req_inst;
          if(fast_response) begin
            state_ns = RESP_S;
            imo_req_ack_ns = 1'b1;
            imo_resp_valid_ns = 1'b1;
            if(opcode_ns[`IMO_RNGBUFSZ_OFS]) begin
              imo_resp_data_ns  = rn_word_count;
            end
            else if(opcode_ns[`IMO_RNG_OFS]) begin
              rd_rn             = 1'b1;
              imo_resp_data_ns  = rn;
            end
            else if(opcode_ns[`IMO_WR_CR]) begin
              cr_wvalid     = 1'b1;
              cr_waddr      = imo_req_inst[32+:4];
              cr_wdata      = imo_req_inst[0+:32];
            end            
          end
          else begin
            imo_req_ack_ns      = 1'b1;
            state_ns            = HNDL_S;
          end
        end
      end // IDLE_S
      HNDL_S: begin
        if(is_rlrd) begin
          arb_cmd   = 1 << (`INT_RLRD_OFS);
          arb_addr  = imo_req_inst_r[29:0];
          arb_valid = 1'b1;
          if(arb_ack)
            state_ns = RESP_S;  
        end
        if(is_copy) begin
          arb_cmd   = 1 << (`INT_COPY_OFS);  
          arb_addr  = {imo_req_inst_r[61:32],imo_req_inst_r[29:0]};
          arb_valid = 1'b1;
          if(arb_ack)
            state_ns = RESP_S;
        end
      end
      RESP_S: begin
        state_ns      = IDLE_S;
        if (!fast_response) begin
          imo_resp_valid_ns       = 1'b1;
          imo_resp_data_ns[511]   = 1'b1;
        end
      end // RESP_S
    endcase
  end
  
  always @(posedge clk) begin
    if(rst) begin
      state_r <= IDLE_S;
      imo_resp_valid_r <= 1'b0;
      imo_req_ack_r <= 1'b0;
    end
    else begin
      state_r <= state_ns;
      imo_resp_data_r <= imo_resp_data_ns;
      imo_resp_valid_r <= imo_resp_valid_ns;
      imo_req_inst_r <= imo_req_inst_ns;
      imo_req_ack_r <= imo_req_ack_ns;
    end
  end

  rng_fifo rngfifo
  (
    .full(rng_fifo_full),
    .din(rng_bits),
    .wr_en(rng_valid),
    
    .empty(),
    .dout(rn),
    .rd_en(rd_rn),
    
    .rst(rst),
    .wr_clk(clk),
    .rd_clk(clk),
    
    .rd_data_count(rn_word_count)
  );

endmodule
