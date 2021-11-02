`timescale 1ns / 1ps

`include "encoding.vh"


module tb_imoc(

  );

  reg                         clk               ;
  reg                         rst               ;
  
  reg                         imo_req_valid     ;
  reg   [127:0]               imo_req_inst      ;
  reg                         arb_ack           ;
    
  reg                         rng_valid         ;
  reg   [1:0]                 rng_bits          ;

  wire  [511:0]               imo_resp_data     ;
  wire                        imo_resp_valid    ;
  wire                        imo_req_ack       ;
  
  wire  [`INT_CMD_SZ-1:0]     arb_cmd           ;
  wire                        arb_valid         ;
  wire  [59:0]                arb_addr          ;
  
  wire                        rng_fifo_full     ;
  
  wire  [3:0]                 cr_waddr          ;
  wire  [31:0]                cr_wdata          ;
  wire                        cr_wvalid         ;
    
    
  always begin
    clk = ~clk;
    #5;
  end
  
  initial begin
    imo_req_valid                             =   1'b0            ;
    arb_ack                                   =   1'b0            ;
    clk                                       =   1'b0            ;
    rng_valid                                 =   1'b0            ;
    rst                                       =   1'b1            ;
    #50;
    rst                                       =   1'b0            ;
    #10.1;
    imo_req_valid                             =   1'b1            ;
    imo_req_inst                              =   128'b0          ;
    imo_req_inst[`IMO_OP_OFS +: `IMO_OP_SZ]   =   16'd1           ;
    wait(imo_req_ack);
    #1;
    imo_req_valid                             =   1'b0            ;
    @(posedge clk);
    @(posedge clk);
    
    #10.1;
    imo_req_valid                             =   1'b1            ;
    imo_req_inst                              =   128'b0          ;
    imo_req_inst[`IMO_OP_OFS +: `IMO_OP_SZ]   =   16'd2           ;
    wait(imo_req_ack);
    #1;
    imo_req_valid                             =   1'b0            ;
    @(posedge clk);
    @(posedge clk);
    
    #10.1;
    imo_req_valid                             =   1'b1            ;
    imo_req_inst                              =   128'b0          ;
    imo_req_inst[`IMO_OP_OFS +: `IMO_OP_SZ]   =   16'd4           ;
    wait(imo_req_ack);
    #1;

    imo_req_valid                             =   1'b0            ;
    @(posedge clk);
    @(posedge clk);
    
    #10.1;
    imo_req_valid                             =   1'b1            ;
    imo_req_inst                              =   128'b0          ;
    imo_req_inst[`IMO_OP_OFS +: `IMO_OP_SZ]   =   16'd8           ;
    wait(imo_req_ack);
    #1;

    imo_req_valid                             =   1'b0            ;
    @(posedge clk);
    @(posedge clk);

    #10.1;
    imo_req_valid                             =   1'b1            ;
    imo_req_inst                              =   128'b0          ;
    imo_req_inst[`IMO_OP_OFS +: `IMO_OP_SZ]   =   16'd16          ;
    wait(imo_req_ack);
    #1;

    imo_req_valid                             =   1'b0            ;        
  end   
  
  
  always begin
    while(1) begin
      wait(arb_valid);
      #0.1;
      arb_ack = 1'b1;
      @(posedge clk);
      #0.1;
      arb_ack = 1'b0;
      @(posedge clk);
    end
  end  
  
  always begin
    while(1) begin
      @(posedge clk);
      #0.1;
      rng_valid                               =   1'b1            ;
      rng_bits                                =   2'b10           ;
      @(posedge clk);
      #0.1;
      rng_valid                               =   1'b0            ;
      @(posedge clk);
      #2000;
    end
  end
    
  imo_controller imoc(
    .clk             (clk)                          ,
    .rst             (rst)                          ,
    .imo_req_valid   (imo_req_valid)                ,
    .imo_req_ack     (imo_req_ack)                  ,
    .imo_req_inst    (imo_req_inst)                 ,
    .imo_resp_data   (imo_resp_data)                ,
    .imo_resp_valid  (imo_resp_valid)               ,
    .arb_cmd         (arb_cmd)                      ,
    .arb_valid       (arb_valid)                    ,
    .arb_addr        (arb_addr)                     ,
    .arb_ack         (arb_ack)                      ,
    .rng_fifo_full   (rng_fifo_full)                ,
    .rng_valid       (rng_valid)                    ,
    .rng_bits        (rng_bits)                     ,
    .cr_waddr        (cr_waddr)                     ,
    .cr_wdata        (cr_wdata)                     ,
    .cr_wvalid       (cr_wvalid)
  );
  
  
  
  
endmodule
