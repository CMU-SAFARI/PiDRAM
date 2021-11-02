`timescale 1ns / 1ps
`include "parameters.vh"
`include "encoding.vh"
module tb_scheduler();

  reg                           clk              ;
  reg                           rst              ;
                                                 
  // To AXI4 converter                           
  wire                          axi_rack         ;
  wire                          axi_wack         ;
  reg [29:0]                    axi_rdaddr       ;
  reg [29:0]                    axi_wraddr       ;
  reg                           axi_wren         ;
  reg                           axi_rden         ;
                                                 
  // In-memory operations controller             
  reg [59:0]                    imo_addr         ;
  reg [`INT_CMD_SZ-1:0]         imo_cmd          ;
  reg                           imo_valid        ;
  wire                          imo_ack          ;
                                                 
  // Periodic operations controller              
  reg [59:0]                    poc_addr         ;
  reg [`INT_CMD_SZ-1:0]         poc_cmd          ;
  reg                           poc_valid        ;
  wire                          poc_ack          ;
                                                 
  // Configurable timing parameters              
  reg  [3:0]                    rc_t1       = 4'd5    ;
  reg  [3:0]                    rc_t2       = 4'd5    ;
  reg  [3:0]                    rlrd_t1     = 4'd3    ;
                                                 
  // PHY Converter                               
  wire [`DEC_DDR_CMD_SZ*4-1:0]  phy_cmd          ;
  wire [`ROW_SZ*4-1:0]          phy_row          ;
  wire [`BANK_SZ*4-1:0]         phy_bank         ;
  wire [`COL_SZ*4-1:0]          phy_col          ;
                                                 
  wire [5:0]                    rd_flag          ;
  wire                          rd_en            ;

  reg           trcd_start  [7:0] , trp_start  [7:0] , tras_start [7:0] , twr_start [7:0] , twtr_start , trc_start [7:0], tras_global_start , twr_global_start , trtp_global_start , trc_global_start , trrd_start , tccd_start , trfc_start , trtp_start [7:0];
  wire          trcd_done   [7:0] , trp_done   [7:0] , tras_done  [7:0] , twr_done  [7:0] , twtr_done  , trc_done  [7:0], tras_global_done  , twr_global_done  , trtp_global_done  , trc_global_done  , trrd_done  , tccd_done  , trfc_done  , trtp_done  [7:0];
  wire  [1:0]   trcd_ofs    [7:0] , trp_ofs    [7:0] , tras_ofs   [7:0] , twr_ofs   [7:0] , twtr_ofs   , trc_ofs   [7:0], tras_global_ofs   , twr_global_ofs   , trtp_global_ofs   , trc_global_ofs   , trrd_ofs   , tccd_ofs   , trfc_ofs   , trtp_ofs   [7:0];
  reg   [1:0]   trcd_slot   [7:0] , trp_slot   [7:0] , tras_slot  [7:0] , twr_slot  [7:0] , twtr_slot  , trc_slot  [7:0], tras_global_slot  , twr_global_slot  , trtp_global_slot  , trc_global_slot  , trrd_slot  , tccd_slot  , trfc_slot  , trtp_slot  [7:0];
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRCD))
  trcd_ctr [7:0] (.clk(clk), .rst(rst), .start(trcd_start), .slot(trcd_slot), .offset(trcd_ofs), .done(trcd_done));

  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRFC))
  trfc_ctr       (.clk(clk), .rst(rst), .start(trfc_start), .slot(trfc_slot), .offset(trfc_ofs), .done(trfc_done));
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRP))
  trp_ctr [7:0] (.clk(clk), .rst(rst), .start(trp_start), .slot(trp_slot), .offset(trp_ofs), .done(trp_done));
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRAS))
  tras_ctr [7:0] (.clk(clk), .rst(rst), .start(tras_start), .slot(tras_slot), .offset(tras_ofs), .done(tras_done));
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRTP))
  trtp_ctr [7:0] (.clk(clk), .rst(rst), .start(trtp_start), .slot(trtp_slot), .offset(trtp_ofs), .done(trtp_done));

  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRTP))                                  
  twr_ctr [7:0] (.clk(clk), .rst(rst), .start(twr_start), .slot(twr_slot), .offset(twr_ofs), .done(twr_done));
    
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tWTR))
  twtr_ctr (.clk(clk), .rst(rst), .start(twtr_start), .slot(twtr_slot), .offset(twtr_ofs), .done(twtr_done));  
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRC))
  trc_ctr [7:0] (.clk(clk), .rst(rst), .start(trc_start), .slot(trc_slot), .offset(trc_ofs), .done(trc_done));  
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRRD))
  trrd_ctr (.clk(clk), .rst(rst), .start(trrd_start), .slot(trrd_slot), .offset(trrd_ofs), .done(trrd_done));
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tCCD))
  tccd_ctr (.clk(clk), .rst(rst), .start(tccd_start), .slot(tccd_slot), .offset(tccd_ofs), .done(tccd_done));
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRAS))
  tras_global_ctr (.clk(clk), .rst(rst), .start(tras_global_start), .slot(tras_global_slot), .offset(tras_global_ofs), .done(tras_global_done));  
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tWR))
  twr_global_ctr (.clk(clk), .rst(rst), .start(twr_global_start), .slot(twr_global_slot), .offset(twr_global_ofs), .done(twr_global_done));
  
  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRTP))
  trtp_global_ctr (.clk(clk), .rst(rst), .start(trtp_global_start), .slot(trtp_global_slot), .offset(trtp_global_ofs), .done(trtp_global_done));

  timing_counter #(.nCK_PER_CLK(`nCK_PER_CLK), .DDR_PRD(`DDR_CK_PRD), .TP(`tRC))
  trc_global_ctr (.clk(clk), .rst(rst), .start(trc_global_start), .slot(trc_global_slot), .offset(trc_global_ofs), .done(trc_global_done));  
 
 
  always begin
    clk = ~clk;
    #5;
  end
 
  //=============================================================
  //                    Periodic Refresh
  //=============================================================
  
  always begin
    #835.1;
    
    while(1) begin
      poc_addr      =   0;
      poc_cmd[5]    =   1;
      poc_valid     =   1;
      #9.0;
      if (!poc_ack) begin
        do #10; while (!poc_ack);
      end
      #2;
      poc_valid     =   0;
      poc_cmd[5]    =   0;     
      @(posedge clk);
      #780.1;
    end
  end
  
  //=============================================================
  //                    Periodic RNG
  //=============================================================
  
  
  always begin
    #1505.1;
    
    while(1) begin
      poc_addr      =   30'h00800000;
      poc_cmd[4]    =   0;
      poc_valid     =   0; // TODO: this is off
      #9.0;
      if (!poc_ack) begin
        do #10; while (!poc_ack);
      end
      #2;
      poc_valid     =   0;
      poc_cmd[4]    =   0;
      @(posedge clk);
      #2300.1;
    end
  end
  
  
  //=============================================================
  //                    Data Copy
  //=============================================================
  
  
  always begin
    #3505.1;
    
    while(1) begin
      imo_addr      =   {30'h01800000,30'h00800000};
      imo_cmd       =   7'd4;
      imo_valid     =   0; // TODO: This is off
      #9.0;
      if (!imo_ack) begin
        do #10; while (!imo_ack);
      end
      #2;
      imo_valid     =   0;     
      @(posedge clk);
      #10000.1;
    end
  end  
  
  

  //=============================================================
  //                    Reads and Writes
  //=============================================================
  integer i;
  initial begin
    clk           =   0;
    rst           =   1;
    axi_rden      =   0;
    axi_wren      =   0;
    imo_valid     =   0;
    imo_cmd       =   0;
    poc_valid     =   0;
    poc_cmd       =   0;
    #55.1;
    rst           =   0;
    #50;
    // TEST 1 - B2B READs to same row with 20 ns in between
    axi_rdaddr    =   30'b0;  
    axi_rden      =   1'b1;
    #9.0; // rack is combinationally set, so we wait a little
    if (!axi_rack) begin
      do #10; while (!axi_rack);
    end
    #2;
    axi_rden      =   1'b0;
    @(posedge clk);
    #20;
    axi_rden      =   1'b1;
    #9.0;
    if (!axi_rack) begin
      do #10; while (!axi_rack);
    end
    #2;
    axi_rden      =   1'b0;
    @(posedge clk);
    #500.1;
    $display("TEST 1 Passed");
    // TEST 2 - B2B WRITEs to same row with 20 ns in between
    axi_wraddr    =   30'h00800000;  
    axi_wren      =   1'b1;
    #9.0;
    if (!axi_wack) begin
      do #10; while (!axi_wack);
    end
    #2;
    axi_wren      =   1'b0;
    @(posedge clk);
    #20.1;
    axi_wren      =   1'b1;
    #9.0;
    if (!axi_wack) begin
      do #10; while (!axi_wack);
    end
    #2;
    axi_wren      =   1'b0;
    @(posedge clk);
    #500.1;
    $display("TEST 2 Passed");  
    // TEST 3 - (i) READ all banks consecutively, 
    // (ii) force precharge in each bank, (iii) then read again
    axi_rdaddr    =   30'b0;  
    for (i = 0 ; i < 8 ; i = i+1) begin
      axi_rden      =   1'b1;
      #9.0;
      if (!axi_rack) begin
        do #10; while (!axi_rack);
      end
      #2;
      axi_rden = 1'b0;
      @(posedge clk);
      #10.1;
      axi_rdaddr  = axi_rdaddr + 30'h00002000;
    end
    @(posedge clk);
    #100.1;
    axi_rdaddr    =   30'hff000000;  
    //for (i = 0 ; i < 1024 ; i = i+1) begin
    while(1) begin
      axi_rden      =   1'b1;
      #9.0;
      if (!axi_rack) begin
        do #10; while (!axi_rack);
      end
      #2;
      axi_rden = 1'b0;
      @(posedge clk);
      //@(posedge clk);
      #10.1;
      axi_rdaddr  = axi_rdaddr + 30'h00002000;
      // less random:
      //axi_rdaddr  = axi_rdaddr + 30'h00000080;
      axi_wren      =   1'b1;
      #9.0;
      if (!axi_wack) begin
        do #10; while (!axi_wack);
      end
      #2;
      axi_wren = 1'b0;
      @(posedge clk);
      //@(posedge clk);
      #10.1;
      axi_wraddr  = axi_wraddr + 30'h00010340;
      // less random:
      //axi_rdaddr  = axi_rdaddr + 30'h00000080;
    end
    #500;
    $display("TEST 3 Passed");  
    //$finish;
  end

  // This block checks for timing variations
  // TODO: we need counters per bank
  integer bank;
  integer slot;
  reg [2:0] ddr_bank [4:0];
  always @(posedge clk) begin
    // initialize timer control signals
    for (bank = 0 ; bank < 8 ; bank = bank + 1) begin
      tras_start  [bank]  =   1'b0;
      trcd_start  [bank]  =   1'b0;
      trp_start   [bank]  =   1'b0;
      trtp_start  [bank]  =   1'b0;
      twr_start   [bank]  =   1'b0;
      trc_start   [bank]  =   1'b0;
    end
    trfc_start            =   1'b0;
    twtr_start            =   1'b0;
    trrd_start            =   1'b0;
    tccd_start            =   1'b0;
    tras_global_start     =   1'b0;
    twr_global_start      =   1'b0;
    trtp_global_start     =   1'b0;
    trc_global_start      =   1'b0;
    for (slot = 0 ; slot < 4 ; slot = slot + 1) begin
      ddr_bank[slot] = phy_bank[slot*`BANK_SZ +: `BANK_SZ];
      case(phy_cmd[`DEC_DDR_CMD_SZ*slot +: `DEC_DDR_CMD_SZ])
        `DDR_ACT: begin
          // check tRP counter
          assert((trp_done[ddr_bank[slot]] == 1'b1) && (trp_ofs[ddr_bank[slot]] <= slot)) else $warning("ACT violated tRP");
          // check tRRD counter
          assert((trrd_done == 1'b1) && (trrd_ofs <= slot)) else $warning("ACT violated tRRD");
          // check tRC counter
          assert((trc_done[ddr_bank[slot]] == 1'b1) && (trc_ofs[ddr_bank[slot]] <= slot)) else $warning("ACT violated tRC");
          
          // set tRRD counter
          trrd_slot = slot;
          trrd_start = 1'b1;
          // set tRC counter
          trc_slot[ddr_bank[slot]] = slot;
          trc_start[ddr_bank[slot]] = 1'b1;
          trc_global_start = 1'b1;
          trc_global_slot = slot;
          // set tRAS counter
          tras_slot[ddr_bank[slot]] = slot;
          tras_start[ddr_bank[slot]] = 1'b1;
          tras_global_slot = slot;
          tras_global_start = 1'b1;
          // set tRCD counter
          trcd_slot[ddr_bank[slot]] = slot;
          trcd_start[ddr_bank[slot]] = 1'b1;
        end
        `DDR_PRE: begin
          // check tRAS counter
          assert((tras_done[ddr_bank[slot]] == 1'b1) && (tras_ofs[ddr_bank[slot]] <= slot)) else $warning("PRE violated tRAS");
          // check tRRD counter
          assert((trrd_done == 1'b1) && (trrd_ofs <= slot)) else $warning("PRE violated tRRD");
          // check tWR counter
          assert((twr_done[ddr_bank[slot]] == 1'b1) && (twr_ofs[ddr_bank[slot]] <= slot)) else $warning("PRE violated tWR");
          // check tRTP counter
          assert((trtp_done[ddr_bank[slot]] == 1'b1) && (trtp_ofs[ddr_bank[slot]] <= slot)) else $warning("PRE violated tRTP");
          
          // set tRRD counter
          trrd_slot = slot;
          trrd_start = 1'b1;          
          // set tRP counter 
          trp_slot[ddr_bank[slot]] = slot;
          trp_start[ddr_bank[slot]] = 1'b1;                 
        end
        `DDR_PRE_ALL: begin
          // check tRAS global counter
          assert((tras_global_done == 1'b1) && (tras_global_ofs <= slot)) else $warning("PRE violated tRAS");
          // check tRRD counter
          assert((trrd_done == 1'b1) && (trrd_ofs <= slot)) else $warning("PRE violated tRRD");
          // check tWR counter
          assert((twr_global_done == 1'b1) && (twr_global_ofs <= slot)) else $warning("PRE violated tRWR");
          // check tRTP counter
          assert((trtp_global_done == 1'b1) && (trtp_global_ofs <= slot)) else $warning("PRE violated tRTP");
          
          // set tRRD counter
          trrd_slot = slot;
          trrd_start = 1'b1;          
          // set tRP counter for all banks
          for (bank = 0 ; bank < 8 ; bank = bank+1) begin 
            trp_slot[bank] = slot;
            trp_start[bank] = 1'b1;
          end            
        end
        `DDR_READ: begin
          // check if slot number is odd
          assert(slot % 2 == 1) else $warning("READ NOT ISSUED FROM ODD SLOT");
          // check tRCD
          assert((trcd_done[ddr_bank[slot]] == 1'b1) && (trcd_ofs[ddr_bank[slot]] <= slot)) else $warning("READ violated tRCD");
          // check tCCD
          assert((tccd_done == 1'b1) && (tccd_ofs <= slot)) else $warning("READ violated tCCD");
          // check tWTR
          assert((twtr_done == 1'b1) && (twtr_ofs <= slot)) else $warning("READ violated tWTR");

          // set RTP
          trtp_slot[ddr_bank[slot]] = slot;
          trtp_start[ddr_bank[slot]] = 1'b1;
          trtp_global_slot = slot;
          trtp_global_start = 1'b1;                      
          // set CCD
          tccd_slot = slot;
          tccd_start = 1'b1;   
        end
        `DDR_WRITE: begin
          // check if slot number is odd
          assert(slot % 2 == 1) else $warning("WRITE NOT ISSUED FROM ODD SLOT");
          // check tRCD
          assert((trcd_done[ddr_bank[slot]] == 1'b1) && (trcd_ofs[ddr_bank[slot]] <= slot)) else $warning("WRITE violated tRCD");
          // check tCCD
          assert((tccd_done == 1'b1) && (tccd_ofs <= slot)) else $warning("WRITE violated tCCD");

          // set WR
          twr_slot[ddr_bank[slot]] = slot;
          twr_start[ddr_bank[slot]] = 1'b1;
          twr_global_slot = slot;
          twr_global_start = 1'b1;         
          // set WTR
          twtr_slot = slot;
          twtr_start = 1'b1;
          // set CCD
          tccd_slot = slot;
          tccd_start = 1'b1;    
        end
        `DDR_ZQS: begin
        // Not Implemented
        end
        `DDR_REF: begin
          assert(trc_global_done) else $warning("REF violated tRC");
          for (bank = 0 ; bank < 8 ; bank = bank + 1) begin
            assert(trp_done[bank]) else $warning("REF violated tRP");
          end
          
          trfc_start  = 1'b1;
          trfc_slot   = slot;
        end      
      endcase 
    
    end
    // TODO: check if two CAS commands within command packet
  end


  scheduler scd(
    .clk,
    .rst,
    .axi_rack,
    .axi_wack,
    .axi_rdaddr,
    .axi_wraddr,
    .axi_wren,
    .axi_rden,
    .imo_addr,
    .imo_cmd,
    .imo_valid,
    .imo_ack,
    .poc_addr,
    .poc_cmd,
    .poc_valid,
    .poc_ack,
    .rc_t1,
    .rc_t2,
    .rlrd_t1, 
    .phy_cmd,
    .phy_row,
    .phy_bank,
    .phy_col,
    .rd_flag,
    .rd_en  
  );
    
endmodule