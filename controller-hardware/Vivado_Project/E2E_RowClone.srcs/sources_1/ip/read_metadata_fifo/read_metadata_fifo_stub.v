// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (lin64) Build 1577090 Thu Jun  2 16:32:35 MDT 2016
// Date        : Tue Sep  7 13:02:54 2021
// Host        : jalapeno running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/read_metadata_fifo/read_metadata_fifo_stub.v
// Design      : read_metadata_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z045ffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_1_1,Vivado 2016.2" *)
module read_metadata_fifo(clk, srst, din, wr_en, rd_en, dout, full, empty)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[5:0],wr_en,rd_en,dout[5:0],full,empty" */;
  input clk;
  input srst;
  input [5:0]din;
  input wr_en;
  input rd_en;
  output [5:0]dout;
  output full;
  output empty;
endmodule
