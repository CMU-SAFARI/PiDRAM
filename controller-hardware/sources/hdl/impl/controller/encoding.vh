// IMO inst encodings
`define IMO_OP_OFS        112
`define IMO_OP_SZ         16

`define IMO_COPY_OFS      0
`define IMO_RLRD_OFS      1
`define IMO_RNG_OFS       2
`define IMO_RNGBUFSZ_OFS  3
`define IMO_WR_CR         4

// Internal command encodings
`define INT_CMD_SZ      7
`define INT_RD_OFS      0
`define INT_WR_OFS      1
`define INT_COPY_OFS    2
`define INT_RLRD_OFS    3
`define INT_RNG_OFS     4
`define INT_REF_OFS     5
`define INT_ZQS_OFS     6

// Internal MISC encodings
`define REGULAR_READ_OFS  0
`define RNG_READ_OFS      1
`define GARBAGE_READ_OFS  2
// DDR command encodings
`define ADDR_SZ 30
`define BANK_SZ 3
`define ROW_SZ  14
`define COL_SZ  10

`define DEC_DDR_CMD_SZ  7
`define DDR_NOP         0
`define DDR_ACT         1
`define DDR_PRE         2
`define DDR_READ        4
`define DDR_WRITE       8
`define DDR_ZQS         16
`define DDR_REF         32
`define DDR_PRE_ALL     64    
