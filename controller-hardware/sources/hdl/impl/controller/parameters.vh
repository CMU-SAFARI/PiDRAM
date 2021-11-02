//`define BYPASS_INIT
`include "util.vh"

`define DDR_CK_PRD          2.5 // 2.5 ns
`define nCK_PER_CLK         4 // 10 ns fabric clk period

`define tREFI               7800 // 7800 ns
`define REF_PRD             `tREFI/(`nCK_PER_CLK*`DDR_CK_PRD)
`define REF_PRD_BITS        `CLOG2(`REF_PRD)

// tRP is 13.125 ns  = 5.25 DDR cycles
// tRCD is 13.125 ns = 5.25 DDR cycles
// tRAS is 48.125 ns = 19.25 DDR cycles

// TODO: These are not as tight as they can be
//`define tRP              13.125
//`define tRAS             48.125
//`define tRCD             13.125
//`define tWTR             40.000
//`define tRRD             10.000
//`define tRC              61.250 // tRP + tRAS
//`define tRFC            350.000 // 
//`define tRTP             10.000 // 4nck
//`define tCCD             10.000 // 4nck
//`define tWR              40.000 // 15 ns

// TODO: These are not as tight as they can be
`define tRP              15
`define tRAS             50
`define tRCD             15
`define tWTR             40.000
`define tRRD             10.000
`define tRC              62.5 // tRP + tRAS
`define tRFC            350.000 // 
`define tRTP             10.000 // 4nck
`define tCCD             10.000 // 4nck
`define tWR              40.000 // 15 ns
