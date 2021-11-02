`timescale 1ns / 1ps

`include "encoding.vh"

module tb_axi_to_mc(

  );

  reg                         clk                         ;
  reg                         rst                         ;
    
  reg                         arb_axi_rack                ; 
  reg                         arb_axi_wack                ; 
  wire                        axi_arb_rden                ; 
  wire                        axi_arb_wren                ;
  wire      [29:0]            axi_arb_rdaddr              ; 
  wire      [29:0]            axi_arb_wraddr              ;

  wire      [511:0]           axi_arb_wrdata              ;
  wire      [63:0]            axi_arb_wrdata_mask         ;
  reg       [5:0]             phy_rd_flag                 ;
  reg       [511:0]           phy_rddata                  ;
  reg                         phy_rddata_valid            ;
  
  reg       [5:0]             S_AXI_AWID                  ;
  reg       [31:0]            S_AXI_AWADDR                ;
  reg       [7:0]             S_AXI_AWLEN                 ;
  reg       [2:0]             S_AXI_AWSIZE                ;
  reg       [1:0]             S_AXI_AWBURST               ;
  reg                         S_AXI_AWLOCK                ;
  reg       [3:0]             S_AXI_AWCACHE               ;
  reg       [2:0]             S_AXI_AWPROT                ;
  reg       [3:0]             S_AXI_AWQOS                 ;
  reg                         S_AXI_AWVALID               ;
  wire                        S_AXI_AWREADY               ;
  reg       [63:0]            S_AXI_WDATA                 ;
  reg       [7:0]             S_AXI_WSTRB                 ;
  reg                         S_AXI_WLAST                 ;
  reg                         S_AXI_WVALID                ;
  wire                        S_AXI_WREADY                ;
  wire      [5:0]             S_AXI_BID                   ;
  wire      [1:0]             S_AXI_BRESP                 ;
  wire                        S_AXI_BVALID                ;
  reg                         S_AXI_BREADY                ;
  reg       [5:0]             S_AXI_ARID                  ; 
  reg       [31:0]            S_AXI_ARADDR                ; 
  reg       [7:0]             S_AXI_ARLEN                 ; 
  reg       [2:0]             S_AXI_ARSIZE                ; 
  reg       [1:0]             S_AXI_ARBURST               ;
  reg                         S_AXI_ARLOCK                ; 
  reg       [3:0]             S_AXI_ARCACHE               ;
  reg       [2:0]             S_AXI_ARPROT                ; 
  reg       [3:0]             S_AXI_ARQOS                 ; 
  reg                         S_AXI_ARVALID               ;
  wire                        S_AXI_ARREADY               ;
  wire      [5:0]             S_AXI_RID                   ; 
  wire      [63:0]            S_AXI_RDATA                 ; 
  wire      [1:0]             S_AXI_RRESP                 ; 
  wire                        S_AXI_RLAST                 ; 
  wire                        S_AXI_RVALID                ; 
  reg                         S_AXI_RREADY                ;


  always begin
    clk = ~clk;
    #5;
  end
  
  initial begin
    arb_axi_wack = 1'b1;
    arb_axi_rack = 1'b1;
    phy_rddata_valid = 1'b1;
    phy_rd_flag = 1;

    clk = 1'b0;
    rst = 1'b1;
    #50;
    rst = 1'b0;
    #10.1;

    S_AXI_BREADY  = 1'b0;
    S_AXI_AWVALID = 1'b0;
    S_AXI_ARVALID = 1'b0;
    S_AXI_RREADY  = 1'b0;
    S_AXI_WVALID  = 1'b0;
    S_AXI_WLAST   = 1'b0;
  
    S_AXI_AWADDR = {$urandom,$urandom};
  
    S_AXI_ARADDR = {$urandom,$urandom};
    S_AXI_RREADY = 1'b1;

    while (1) begin
    
      S_AXI_ARVALID = 1'b1;
      S_AXI_ARLEN   = 8'd7;
      S_AXI_ARSIZE  = 3'd3; // 8 bytes per beat
      S_AXI_ARBURST = 2'b0; 
      
      @(posedge clk);
      #1;
  
      wait (S_AXI_ARREADY);
      
      S_AXI_ARVALID = 1'b0;
      
      wait (S_AXI_RLAST);
      
      @(posedge clk);
      S_AXI_ARADDR = {$urandom,$urandom};
    end    
    
  end
  
  axi_to_mc amc(
    .arb_rack             (arb_axi_rack),
    .arb_wack             (arb_axi_wack),
    .arb_wrdata           (axi_arb_wrdata),
    .arb_wrdata_mask      (axi_arb_wrdata_mask),
    .arb_rdaddr           (axi_arb_rdaddr),

    .arb_wraddr           (axi_arb_wraddr),
    .arb_wren             (axi_arb_wren),
    .arb_rden             (axi_arb_rden),
    .arb_rddata           (phy_rddata),
    .arb_rdvalid          (phy_rddata_valid & phy_rd_flag[`REGULAR_READ_OFS]),
    .S_AXI_ACLK           (clk),
    .S_AXI_ARESETN        (~rst),
    .S_AXI_AWID           (S_AXI_AWID),
    .S_AXI_AWADDR         (S_AXI_AWADDR),
    .S_AXI_AWLEN          (S_AXI_AWLEN),
    .S_AXI_AWSIZE         (S_AXI_AWSIZE),
    .S_AXI_AWBURST        (S_AXI_AWBURST),
    .S_AXI_AWLOCK         (S_AXI_AWLOCK),
    .S_AXI_AWCACHE        (S_AXI_AWCACHE),
    .S_AXI_AWPROT         (S_AXI_AWPROT),
    .S_AXI_AWQOS          (S_AXI_AWQOS),
    .S_AXI_AWVALID        (S_AXI_AWVALID),
    .S_AXI_AWREADY        (S_AXI_AWREADY),
    .S_AXI_WDATA          (S_AXI_WDATA),
    .S_AXI_WSTRB          (S_AXI_WSTRB),
    .S_AXI_WLAST          (S_AXI_WLAST),
    .S_AXI_WVALID         (S_AXI_WVALID),
    .S_AXI_WREADY         (S_AXI_WREADY),
    .S_AXI_BID            (S_AXI_BID),
    .S_AXI_BRESP          (S_AXI_BRESP),
    .S_AXI_BVALID         (S_AXI_BVALID),
    .S_AXI_BREADY         (S_AXI_BREADY),
    .S_AXI_ARID           (S_AXI_ARID), 
    .S_AXI_ARADDR         (S_AXI_ARADDR), 
    .S_AXI_ARLEN          (S_AXI_ARLEN), 
    .S_AXI_ARSIZE         (S_AXI_ARSIZE), 
    .S_AXI_ARBURST        (S_AXI_ARBURST),
    .S_AXI_ARLOCK         (S_AXI_ARLOCK), 
    .S_AXI_ARCACHE        (S_AXI_ARCACHE),
    .S_AXI_ARPROT         (S_AXI_ARPROT), 
    .S_AXI_ARQOS          (S_AXI_ARQOS), 
    .S_AXI_ARVALID        (S_AXI_ARVALID),
    .S_AXI_ARREADY        (S_AXI_ARREADY),
    .S_AXI_RID            (S_AXI_RID), 
    .S_AXI_RDATA          (S_AXI_RDATA), 
    .S_AXI_RRESP          (S_AXI_RRESP), 
    .S_AXI_RLAST          (S_AXI_RLAST), 
    .S_AXI_RVALID         (S_AXI_RVALID), 
    .S_AXI_RREADY         (S_AXI_RREADY) 
  );    
endmodule
