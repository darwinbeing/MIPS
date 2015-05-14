`define BSIZE            2               // word size per block
`define BINDEX           1               // log2(BSIZE) 

`define DCACHESIZE       16
`define DC_INDEXSIZE     4               // determined by cache size
`define DINDEX           2 + `BINDEX + `DC_INDEXSIZE - 1 : 2 +`BINDEX  
`define DTAG             `ADDRWIDTH - 1 : 2 +`BINDEX + `DC_INDEXSIZE // ADDRWIDTH - INDEXWIDTH
`define DTAGSIZE         `ADDRWIDTH - (2 + `BINDEX + `DC_INDEXSIZE) // ADDRWIDTH - INDEXWIDTH

`define ICACHESIZE       16
`define IC_INDEXSIZE     4               // determined by cache size
`define IINDEX           2 + `BINDEX + `IC_INDEXSIZE - 1 : 2 +`BINDEX  
`define ITAG             `ADDRWIDTH - 1 : 2 +`BINDEX + `IC_INDEXSIZE // ADDRWIDTH - INDEXWIDTH
`define ITAGSIZE         `ADDRWIDTH - (2 + `BINDEX + `IC_INDEXSIZE) // ADDRWIDTH - INDEXWIDTH

`define PRESENT         1
`define ABSENT          !`PRESENT

`define WB_INDEXSIZE     2               // determined by write buffer size
`define WB_INDEX         2 + `BINDEX + `WB_INDEXSIZE - 1 : 2 +`BINDEX  


//----------------------------------------
// stdbus.h
//----------------------------------------
`define CLOCKPERIOD     20

`define DATAWIDTH       32
`define DATA            `DATAWIDTH-1:0

`define INSNWIDTH       32
`define INSN            `INSNWIDTH-1:0

`define ADDRWIDTH       32
`define ADDR            `ADDRWIDTH-1:0

`define BYTEWIDTH       8
`define BYTE            `BYTEWIDTH-1:0

`define NBYTES          `INSNWIDTH/`BYTEWIDTH
`define WRMASK          `NBYTES * `BSIZE - 1 : 0

`define INSNSLICE       `NBYTES-1:0 
`define DATASLICE       `NBYTES-1:0 

`define READ            1
`define WRITE           0

`define ENABLE          1
`define DISABLE         0

//----------------------------------------
// control.h
//----------------------------------------
`define STATE_IDLE      0
`define STATE_READ      1
`define STATE_READMISS  2
`define STATE_READMEM   3
`define STATE_READDATA  4
`define STATE_WRITE     5
`define STATE_WRITEHIT  6
`define STATE_WRITEMISS 7
`define STATE_WRITEMEM  8
`define STATE_WRITEDATA 9
`define STATE_READWB    10

//--------------------------------------------
// Cache control patterns
//--------------------------------------------
`define Pt_Idle              13'b0000000000000 
`define Pt_MAddrOE           13'b0000000000001 
`define Pt_MDataOE           13'b0000000000010 
`define Pt_DDataOE           13'b0000000000100 
`define Pt_DDataSelect       13'b0000000001000 
`define Pt_CacheDataSelect   13'b0000000010000 
`define Pt_MRW               13'b0000000100000 
`define Pt_MStrobe           13'b0000001000000 
`define Pt_CpuWrite          13'b0000010000000 
`define Pt_Ready             13'b0000100000000 
`define Pt_DReadyEnable      13'b0001000000000 
`define Pt_WSCLoad           13'b0010000000000 
`define Pt_Miss              13'b0100000000000 
`define Pt_TagWrite          13'b1000000000000 

//----------------------------------------
// memory.h
//----------------------------------------
`define READ_WAITCYCLES         2
`define WRITE_WAITCYCLES        4
`define BURST_COUNT             3'd4

//----------------------------------------
// dbgflags.h
//----------------------------------------
`define vbs     0       // Verbose mode: print some information
`define dbg     0       // Debug mode:   print debug information



