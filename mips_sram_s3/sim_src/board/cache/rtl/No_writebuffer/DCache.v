`include "cache.h"
          
module DCache (
        // Asynchronous Driver Bus
        DStrobe,
        DRD,
        DWR,
        DAddress,
        DData,
        DReady,

        // Synchronous Memory Bus
        MStrobe,
        MRW,
        MBE,
        MGrant,
        MAddress,
        MData,

        // Memory Interface
        mSDR_TxD,
        mSDR_RxD,

        Reset,
        Clk );

input           DStrobe;
input                DRD;
input   [`DATASLICE] DWR;
input   [`ADDR] DAddress;
inout   [`DATA] DData;
output          DReady;

output          MStrobe;
output          MRW;
output  [`DATASLICE] MBE;
input           MGrant;
output  [`ADDR] MAddress;
inout   [`DATA] MData;
input           mSDR_TxD;
input           mSDR_RxD;
input           Reset;
input           Clk;

// Bidirectional buses
wire            DDataOE;        // Driver Data Output Enable
wire            MDataOE;        // Memory Data Output Enable
wire            MAddrOE;        // Memory Data Output Enable
wire    [7:0]   RamFill;
wire            TagWrite;
wire            CpuWrite;
wire    [`DATA] DDataOut;
wire    [`DATA] DData;
wire    [15:0] BTData;
wire    [`DATA] MData;
wire    [`DTAG] TagRamTag;
wire    [`DATA] DataRamDataOut0, DataRamDataOut1; // Two RAM banks
wire    [`DATA] DataRamDataOut;
wire    [`DATA] RamDataIn;
wire    [`DATA] DataRamDataIn;

assign DData = DDataOE ? DataRamDataOut : {`DATAWIDTH{1'bz}};
assign MData = MDataOE ? {16'hz, BTData} : {`DATAWIDTH{1'bz}};
assign BTData  = mSDR_TxD ? DData[31:16] : DData[15:0];
assign MBE   = DWR;

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
wire    [1 : 0] Mask = DRD ? 2'b00 /* cache-line aligned read */ : //2'b11 /* unaligned write */;
                             2'b10; /* half-aligned 2'b10 */ 

wire    [`ADDR] MAddress = MAddrOE ? {1'b0, DAddress[31:1]} & 
                           {30'h3FFF_FFFF, Mask} : 32'hz; 

wire    [7:0] RamWrite = CpuWrite ? (DAddress[2] ? {DWR, 4'b0} : {4'b0, DWR}) : 8'b0;
wire    [7:0] DataRamWrite = RamWrite | RamFill;
wire          DataTagWrite = TagWrite;


// Cache write data select
DataMux #(`DATAWIDTH) CacheDataInputMux1 (
        .S      (CacheDataSelect),
        .A      (MData),
        .B      (DData),
        .Z      (RamDataIn));
      
DataMux #(`DATAWIDTH) CacheDataInputMux2 (
        .S      (CacheDataSelect),
        .A      ({RamDataIn[15:0], RamDataIn[15:0]}),
        .B      (RamDataIn),
        .Z      (DataRamDataIn));

// RAM bank select
DataMux #(`INSNWIDTH) RamDataMux (
        .S      (DAddress[2]),
        .A      (DataRamDataOut1),
        .B      (DataRamDataOut0),
        .Z      (DataRamDataOut) );

// RAM write data
DataMux DDataMux (
        .S      (DDataSelect),
        .A      (DData),
        .B      (MData),
        .Z      (DataRamDataIn) );

TagRam #(`DCACHESIZE, `DC_INDEXSIZE, `DTAGSIZE) 
  TagRam (
        .Address        (DAddress[`DINDEX]),
        .TagIn          (DAddress[`DTAG]),
        .TagOut         (TagRamTag),
        .Write          (DataTagWrite),
        .Reset          (Reset),
        .Clk            (Clk) );

ValidRam #(`DCACHESIZE, `DC_INDEXSIZE)
  ValidRam (
        .Address        (DAddress[`DINDEX]),
        .ValidIn        (1'b1),
        .ValidOut       (Valid),
        .Write          (DataTagWrite),
        .Reset          (Reset),
        .Clk            (Clk) );

DataRam DataRam_D00 (
        .Address        (DAddress[`DINDEX]),
        .DataIn         (DataRamDataIn[7:0]),
        .DataOut        (DataRamDataOut0[7:0]),
        .Write          (DataRamWrite[0]),
        .Clk            (Clk) );

DataRam DataRam_D01 (
        .Address        (DAddress[`DINDEX]),
        .DataIn         (DataRamDataIn[15:8]),
        .DataOut        (DataRamDataOut0[15:8]),
        .Write          (DataRamWrite[1]),
        .Clk            (Clk) );
DataRam DataRam_D02 (
        .Address        (DAddress[`DINDEX]),
        .DataIn         (DataRamDataIn[23:16]),
        .DataOut        (DataRamDataOut0[23:16]),
        .Write          (DataRamWrite[2]),
        .Clk            (Clk) );

DataRam DataRam_D03 (
        .Address        (DAddress[`DINDEX]),
        .DataIn         (DataRamDataIn[31:24]),
        .DataOut        (DataRamDataOut0[31:24]),
        .Write          (DataRamWrite[3]),
        .Clk            (Clk) );

DataRam DataRam_D10 (
        .Address        (DAddress[`DINDEX]),
        .DataIn         (DataRamDataIn[7:0]),
        .DataOut        (DataRamDataOut1[7:0]),
        .Write          (DataRamWrite[4]),
        .Clk            (Clk) );

DataRam DataRam_D11 (
        .Address        (DAddress[`DINDEX]),
        .DataIn         (DataRamDataIn[15:8]),
        .DataOut        (DataRamDataOut1[15:8]),
        .Write          (DataRamWrite[5]),
        .Clk            (Clk) );

DataRam DataRam_D12 (
        .Address        (DAddress[`DINDEX]),
        .DataIn         (DataRamDataIn[23:16]),
        .DataOut        (DataRamDataOut1[23:16]),
        .Write          (DataRamWrite[6]),
        .Clk            (Clk) );

DataRam DataRam_D13 (
        .Address        (DAddress[`DINDEX]),
        .DataIn         (DataRamDataIn[31:24]),
        .DataOut        (DataRamDataOut1[31:24]),
        .Write          (DataRamWrite[7]),
        .Clk            (Clk) );

Comparator Comparator (
        .Tag1   (DAddress[`DTAG]),
        .Tag2   (TagRamTag),
        .Match  (Match) );

DCacheControl DCacheControl (
        .DStrobe        (DStrobe),
        .DRD            (DRD),
        .DWR            (DWR),
        .DReady         (DReady),
        .Match          (Match),
        .Valid          (Valid),
        .TagWrite       (TagWrite),
        .RamWrite       (RamFill),
        .CpuWrite       (CpuWrite),
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
