`timescale 1ns / 1ps

module axi_td_new(
  input    clk,
  input    start,
  output [5:0]                         m_axi_awid, //
  output reg[31:0]                        m_axi_awaddr, //
  output reg[7:0]                         m_axi_awlen, //
  output reg[2:0]                         m_axi_awsize,//
  output reg[1:0]                         m_axi_awburst, //
  output                              m_axi_awlock, //
  output [3:0]                         m_axi_awcache, //
  output [2:0]                         m_axi_awprot, //
  output [3:0]                         m_axi_awqos, //
  output reg                              m_axi_awvalid, //
  input                               m_axi_awready, //
  output reg[63:0]                        m_axi_wdata,
  output [7:0]                         m_axi_wstrb, //
  output reg                              m_axi_wlast,
  output reg                              m_axi_wvalid,
  input                               m_axi_wready,
  input  [5:0]                        m_axi_bid,
  input  [1:0]                        m_axi_bresp,
  input                               m_axi_bvalid,
  output reg                             m_axi_bready,
  output [5:0]                         m_axi_arid, // 
  output reg[31:0]                        m_axi_araddr, 
  output reg[7:0]                         m_axi_arlen, 
  output reg[2:0]                         m_axi_arsize, 
  output reg[1:0]                         m_axi_arburst,
  output                              m_axi_arlock,//
  output[3:0]                         m_axi_arcache,//
  output[2:0]                         m_axi_arprot, //
  output[3:0]                         m_axi_arqos, //
  output reg                              m_axi_arvalid,
  input                               m_axi_arready,
  input  [5:0]                        m_axi_rid, 
  input  [63:0]                       m_axi_rdata, 
  input  [1:0]                        m_axi_rresp, 
  input                               m_axi_rlast,
  input                               m_axi_rvalid, 
  output reg                              m_axi_rready
  );
  
  
  assign m_axi_arlock = 1'b0;
  assign m_axi_arcache = 4'b0;
  assign m_axi_arprot = 3'b0; 
  assign m_axi_arqos = 4'b0; 
  
  assign m_axi_awlock = 1'b0;
  assign m_axi_awcache = 4'b0;
  assign m_axi_awprot = 3'b0; 
  assign m_axi_awqos = 4'b0; 
  
  assign m_axi_arid = 0;
  assign m_axi_awid = 0;
  
  assign m_axi_wstrb = 8'b1;
  
  initial begin
    
    m_axi_bready  = 1'b1;
    m_axi_awvalid = 1'b0;
    m_axi_arvalid = 1'b0;
    m_axi_rready  = 1'b0;
    m_axi_wvalid  = 1'b0;
    m_axi_wlast   = 1'b0;
  
    wait (start);
    
    m_axi_awaddr = {$urandom,$urandom};
  
    m_axi_araddr = {$urandom,$urandom};
    m_axi_rready = 1'b1;

    while (1) begin

      m_axi_arvalid = 1'b1;
      m_axi_arlen   = 8'd7;
      m_axi_arsize  = 3'd3; // 8 bytes per beat
      m_axi_arburst = 2'b0; 
      
      @(posedge clk);
  
      wait (m_axi_arready);
      
      m_axi_arvalid = 1'b0;
      
      wait (m_axi_rlast);
      
      @(posedge clk);
      //m_axi_araddr = m_axi_araddr + 32'd64;
      m_axi_araddr = {$urandom,$urandom};
      
      m_axi_awvalid = 1'b1;
      m_axi_awlen   = 8'd7;
      m_axi_awsize  = 3'd3; // 8 bytes per beat
      m_axi_awburst = 2'b0;       
      
      @(posedge clk);
  
      wait (m_axi_awready);
      
      m_axi_awvalid = 1'b0;
      
      m_axi_wvalid  = 1'b1;
      wait (m_axi_wready);
      @(posedge clk);

      m_axi_wvalid  = 1'b1;
      wait (m_axi_wready);
      @(posedge clk);

      m_axi_wvalid  = 1'b1;
      wait (m_axi_wready);
      @(posedge clk);

      m_axi_wvalid  = 1'b1;
      wait (m_axi_wready);
      @(posedge clk);

      m_axi_wvalid  = 1'b1;
      wait (m_axi_wready);
      @(posedge clk);

      m_axi_wvalid  = 1'b1;
      wait (m_axi_wready);
      @(posedge clk);

      m_axi_wvalid  = 1'b1;
      wait (m_axi_wready);
      @(posedge clk);

      m_axi_wvalid  = 1'b1;
      m_axi_wlast   = 1'b1;
      wait (m_axi_wready);
      @(posedge clk);
      m_axi_wvalid  = 1'b0;
      m_axi_wlast   = 1'b0;

      @(posedge clk);
      //m_axi_araddr = m_axi_araddr + 32'd64;
      m_axi_awaddr = {$urandom,$urandom};      
    end
  end
  
endmodule
