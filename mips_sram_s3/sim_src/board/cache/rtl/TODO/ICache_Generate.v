///////////////////////////////////////////////////////////////////
//
//
//  Use generate statements to generate cache RAM blocks.
//
//  
///////////////////////////////////////////////////////////////////
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
wire            TagWrite;

wire    [`INSN] DataRamDataOut0, DataRamDataOut1; // RAM banks 1 0
wire    [`INSN] DataRamDataOut2, DataRamDataOut3; // RAM banks 3 2
wire    [`INSN] RamDataIn, DataRamDataIn;
wire    [`ITAG] TagRamTag;

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
wire    [7:0]   RamWrite;
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


genvar i;
generate
  case (BLOCK_SIZE)
    //-------------------------------------------------------------
    // 1
    //-------------------------------------------------------------
    6'd1:
    begin
      for (i = 0; i < 4; i = i + 1)
        begin: DataRam_D0 // inames: DataRamD0[0].p, DataRamD0[1].p ...
          DataRam p 
          (
            .Address        (DAddress[`IINDEX]),
            .DataIn         (DataRamDataIn[i * 8 + 7 : i * 8]),
            .DataOut        (DataRamDataOut0[i * 8 + 7 : i * 8]),
            .Write          (DataRamWrite[i]),
            .Clk            (Clk)
          );
        end
    end

    //-------------------------------------------------------------
    // 2
    //-------------------------------------------------------------
    6'd2:
    begin
      for (i = 0; i < 4; i = i + 1)
        begin: DataRam_D0
          DataRam p 
          (
            .Address        (DAddress[`IINDEX]),
            .DataIn         (DataRamDataIn[i * 8 + 7 : i * 8]),
            .DataOut        (DataRamDataOut0[i * 8 + 7 : i * 8]),
            .Write          (DataRamWrite[i]),
            .Clk            (Clk)
          );
        end

      for (i = 0; i < 4; i = i + 1)
        begin: DataRam_D1
          DataRam p 
          (
            .Address        (DAddress[`IINDEX]),
            .DataIn         (DataRamDataIn[i * 8 + 7 : i * 8]),
            .DataOut        (DataRamDataOut1[i * 8 + 7 : i * 8]),
            .Write          (DataRamWrite[i + 4]),
            .Clk            (Clk)
          );
        end

      // RAM bank select
      DataMux #(`INSNWIDTH) RamDataMux (
              .S      (DAddress[2]),
              .A      (DataRamDataOut1),
              .B      (DataRamDataOut0),
              .Z      (DataRamDataOut) );
    end

    //-------------------------------------------------------------
    // 4
    //-------------------------------------------------------------
    6'd4:
    begin
      for (i = 0; i < 4; i = i + 1)
        begin: DataRam_D0
          DataRam p 
          (
            .Address        (DAddress[`IINDEX]),
            .DataIn         (DataRamDataIn[i * 8 + 7 : i * 8]),
            .DataOut        (DataRamDataOut0[i * 8 + 7 : i * 8]),
            .Write          (DataRamWrite[i]),
            .Clk            (Clk)
          );
        end

      for (i = 0; i < 4; i = i + 1)
        begin: DataRam_D1
          DataRam p 
          (
            .Address        (DAddress[`IINDEX]),
            .DataIn         (DataRamDataIn[i * 8 + 7 : i * 8]),
            .DataOut        (DataRamDataOut1[i * 8 + 7 : i * 8]),
            .Write          (DataRamWrite[i + 4]),
            .Clk            (Clk)
          );
        end

      for (i = 0; i < 4; i = i + 1)
        begin: DataRam_D2
          DataRam p 
          (
            .Address        (DAddress[`IINDEX]),
            .DataIn         (DataRamDataIn[i * 8 + 7 : i * 8]),
            .DataOut        (DataRamDataOut2[i * 8 + 7 : i * 8]),
            .Write          (DataRamWrite[i + 8]),
            .Clk            (Clk)
          );
        end

      for (i = 0; i < 4; i = i + 1)
        begin: DataRam_D3
          DataRam p 
          (
            .Address        (DAddress[`IINDEX]),
            .DataIn         (DataRamDataIn[i * 8 + 7 : i * 8]),
            .DataOut        (DataRamDataOut3[i * 8 + 7 : i * 8]),
            .Write          (DataRamWrite[i + 12]),
            .Clk            (Clk)
          );
        end

      DataMux4 #(`INSNWIDTH) RamDataMux 
      (
        .S      (DAddress[3:2]),
        .A      (DataRamDataOut0),
        .B      (DataRamDataOut1),
        .C      (DataRamDataOut2),
        .D      (DataRamDataOut3),
        .Z      (DataRamDataOut) 
      );
    end
    default: begin
      $display("Unimplemented cache block size"); $stop;
    end
  endcase
endgenerate


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
