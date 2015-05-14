`include "cache.h"

module ICache (
        // CPU signals
        DStrobe,
        DRW,
        DAddress,
        DData,
        DReady,

        // Memory signals
        mSDR_TxD,
        mSDR_RxD,
        Miss,

        // Synchronous Memory Bus
        MStrobe,
        MGrant,
        MRW,
        MAddress,
        MData,


        Reset,
        Clk );

input           DStrobe;
input   [`ADDR] DAddress;
inout   [`INSN] DData;
output          DReady;
input           DRW;

output          Miss;
output          MGrant;
output          MStrobe;
output          MRW;
output  [`ADDR] MAddress;
inout   [`INSN] MData;
input           mSDR_TxD;
input           mSDR_RxD;
input           Reset;
input           Clk;

// Bidirectional buses
wire            DDataOE;        // Driver Data Output Enable
wire            MDataOE;        // Memory Data Output Enable
wire            MAddrOE;        // Memory Data Output Enable
wire    [7:0]   RamWrite;
wire            TagWrite;

wire    [`INSN] DataRamDataOut0, DataRamDataOut1; // Two RAM banks
wire    [`INSN] RamDataIn, DataRamDataIn;
wire    [`ITAG]  TagRamTag;

wire    [`INSN] DataRamDataOut;
wire    [`INSN] DData = DDataOE ? DataRamDataOut : {`INSNWIDTH{1'bz}};
wire    [`INSN] MData = MDataOE ? DData : {`INSNWIDTH{1'bz}};

//===================================================================================
// cpu byte address -> sdram halfword address
// For SC_BL = 4, // mask LSB 2 bits so the sdram block access 
// sequence is 0, 1, 2, 3. 
//
// A1 A0
// 0 0 0-1-2-3 0-1-2-3
// 0 1 1-2-3-0 1-0-3-2
// 1 0 2-3-0-1 2-3-0-1
// 1 1 3-0-1-2 3-2-1-0
//===================================================================================
wire    [`ADDR] MAddress = MAddrOE ? {1'b0, DAddress[31:1]} & 
                                      32'hFFFF_FFFC /* aligned read */: 32'hz;
wire    [7:0] DataRamWrite = RamWrite;


// Cache write data select
DataMux #(`INSNWIDTH) CacheDataInputMux1 (
        .S      (CacheDataSelect),
        .A      (MData),
        .B      (DData),
        .Z      (RamDataIn));
 
// Cache write data select
DataMux #(`DATAWIDTH) CacheDataInputMux2 (
        .S      (CacheDataSelect),
        .A      ({RamDataIn[15:0], RamDataIn[15:0]}),
        .B      (RamDataIn),
        .Z      (DataRamDataIn));

// read: RAM bank select
DataMux #(`INSNWIDTH) RamDataMux (
        .S      (DAddress[2]),
        .A      (DataRamDataOut1),
        .B      (DataRamDataOut0),
        .Z      (DataRamDataOut) );

TagRam #(`ICACHESIZE, `IC_INDEXSIZE, `ITAGSIZE) 
  TagRam (
        .Address        (DAddress[`IINDEX]),
        .TagIn          (DAddress[`ITAG]),
        .TagOut         (TagRamTag),
        .Write          (TagWrite),
        .Reset          (Reset),
        .Clk            (Clk) );

ValidRam #(`ICACHESIZE, `IC_INDEXSIZE)
  ValidRam (
        .Address        (DAddress[`IINDEX]),
        .ValidIn        (1'b1),
        .ValidOut       (Valid),
        .Write          (TagWrite),
        .Reset          (Reset),
        .Clk            (Clk) );

DataRam DataRam_D00 (
        .Address        (DAddress[`IINDEX]),
        .DataIn         (DataRamDataIn[7:0]),
        .DataOut        (DataRamDataOut0[7:0]),
        .Write          (DataRamWrite[0]),
        .Clk            (Clk) );

DataRam DataRam_D01 (
        .Address        (DAddress[`IINDEX]),
        .DataIn         (DataRamDataIn[15:8]),
        .DataOut        (DataRamDataOut0[15:8]),
        .Write          (DataRamWrite[1]),
        .Clk            (Clk) );
DataRam DataRam_D02 (
        .Address        (DAddress[`IINDEX]),
        .DataIn         (DataRamDataIn[23:16]),
        .DataOut        (DataRamDataOut0[23:16]),
        .Write          (DataRamWrite[2]),
        .Clk            (Clk) );

DataRam DataRam_D03 (
        .Address        (DAddress[`IINDEX]),
        .DataIn         (DataRamDataIn[31:24]),
        .DataOut        (DataRamDataOut0[31:24]),
        .Write          (DataRamWrite[3]),
        .Clk            (Clk) );

DataRam DataRam_D10 (
        .Address        (DAddress[`IINDEX]),
        .DataIn         (DataRamDataIn[7:0]),
        .DataOut        (DataRamDataOut1[7:0]),
        .Write          (DataRamWrite[4]),
        .Clk            (Clk) );

DataRam DataRam_D11 (
        .Address        (DAddress[`IINDEX]),
        .DataIn         (DataRamDataIn[15:8]),
        .DataOut        (DataRamDataOut1[15:8]),
        .Write          (DataRamWrite[5]),
        .Clk            (Clk) );

DataRam DataRam_D12 (
        .Address        (DAddress[`IINDEX]),
        .DataIn         (DataRamDataIn[23:16]),
        .DataOut        (DataRamDataOut1[23:16]),
        .Write          (DataRamWrite[6]),
        .Clk            (Clk) );

DataRam DataRam_D13 (
        .Address        (DAddress[`IINDEX]),
        .DataIn         (DataRamDataIn[31:24]),
        .DataOut        (DataRamDataOut1[31:24]),
        .Write          (DataRamWrite[7]),
        .Clk            (Clk) );

Comparator #(`ITAGSIZE) Comparator (
        .Tag1   (DAddress[`ITAG]),
        .Tag2   (TagRamTag),
        .Match  (Match) );

ICacheControl ICacheControl (
        .DStrobe        (DStrobe),
        .DRW            (DRW),
        .DReady         (DReady),
        .Match          (Match),
        .Valid          (Valid),
        .TagWrite       (TagWrite),
        .RamWrite       (RamWrite),
        .CacheDataSelect(CacheDataSelect),
        .DDataSelect    (DDataSelect),
        .Hit            (Hit),
        .Miss           (Miss),
        .MDataOE        (MDataOE),
        .DDataOE        (DDataOE),
        .MAddrOE        (MAddrOE),
        .MGrant         (MGrant),
        .MStrobe        (MStrobe),
        .MRW            (MRW),
        .mSDR_TxD       (mSDR_TxD),
        .mSDR_RxD       (mSDR_RxD),
        .Reset          (Reset),
        .Clk            (Clk) );

endmodule
