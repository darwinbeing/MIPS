`include "cache.h"
          
module DCache (
        // Asynchronous Driver Bus
        DStrobe,
        DRD,
        DWR,
        DBE,
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
input                DWR;
input   [`DATASLICE] DBE;
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
wire            CacheDataSelect;
wire            DDataSelect;
wire            MergeData;
wire    [`DATA] DDataOut;
wire    [`DATA] DData;
wire    [15:0] BTData;
wire    [31:0] BTData_int;
wire     [2:0] Count;
wire    [`DATA] MData;
wire    [`DTAG] TagRamTag;
wire    [`DATA] DataRamDataOut0, DataRamDataOut1; // Two RAM banks
wire    [`DATA] DataRamDataOut;
wire    [`DATA] RamDataIn;
wire    [`DATA] DataRamDataIn;
wire        Valid;
wire        Match;
wire        Hit;
wire        Miss;


wire        wb_qread;
wire        wb_read;
wire        wb_write;
wire        wb_full;
wire        wb_flush;
wire        wb_tag_match;
wire        wb_tag_valid;
wire        wb_valid;
wire  [3:0] wb_data_valid;
wire  [5:0] wb_flush_cnt;
wire [31:0] wb_mem_addr;
wire [31:0] wb_data;
wire [31:0] wb_addr;
wire [31:0] flush_addr;
wire [31:0] masked_addr1;
wire [31:0] masked_addr2;
wire  [3:0] State;
wire  [7:0] MergeData_hi, MergeData_lo;
wire [31:0] wb_addr_mask;
wire [15:0] WBDataOut;
wire [15:0] MergeDataIn;
wire  [3:0] wb_mbe;
wire        valid_hi, valid_lo;
wire        wb_mem_en;
wire        wb_flush_once;
wire        wb_tagval_in;
wire        wb_val_en;
wire        wb_tag_en;
wire        wb_tagv_en;
wire        wb_tagval_out;


wire WBReadSelect = wb_qread;
//wire MAddrSelect  = wb_addr_sel;

// CPU read
//assign DData = DDataOE ? DataRamDataOut : {`DATAWIDTH{1'bz}};
assign DData  = WBReadSelect ? wb_data : 
                     DDataOE ? DataRamDataOut : {`DATAWIDTH{1'bz}};

// SDR burst data write
assign MData  = MDataOE ? {16'hz, BTData} : {`DATAWIDTH{1'bz}};

//------------------------------------------------------------
// Burst Write timing
//
// 00(lh0)  00(lh1)  01(lh2) 10(lh3)  (cache output)
//         +-------------------------------+
// ________|                               |__________
//
//------------------------------------------------------------
assign BTData = mSDR_TxD ? 
               (Count[0] ? BTData_int[15:0] :   // lb2
                           BTData_int[31:16]) : // lb1, lb3 
                           BTData_int[15:0];    // lb0 

// Read WB
assign BTData_int = wb_data;

// Write WB
assign wb_data = (~wb_flush & wb_write & wb_mem_en) ? DData : 32'hz;

// lower memory byte enable
assign MBE = wb_flush ? wb_data_valid : DBE;


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

//wire    [1 : 0] Mask = DRD ? 2'b00 /* cache-line aligned read */ : //2'b11 /* unaligned write */;
//                             2'b10; /* half-aligned 2'b10 */ 
wire    [1 : 0] Mask = 2'b00;
wire    [`ADDR] MAddress = wb_flush /*MAddrSelect*/ ? {1'b0, wb_mem_addr[31:1]} & {30'h3FFF_FFFF, Mask} : 
                           MAddrOE ? {1'b0, DAddress[31:1]} & {30'h3FFF_FFFF, Mask} :
                           32'hz; 

wire    [7:0] RamWrite = CpuWrite ? (DAddress[2] ? {DBE, 4'b0} : {4'b0, DBE}) : 8'b0;
wire    [7:0] DataRamWrite = RamWrite | RamFill;
wire          DataTagWrite = TagWrite;

//================================================================================
// Read-WB on tag hit and valid miss (merge data from WB and SDR)
// 
// For a cache line: hb3-hb2-hb1-hb0 - lb3-lb2-lb1-lb0
// Count = 00: select lb1, lb0 ; Count = 01: select lb3, lb2 
// Count = 10: select hb1, hb0 ; Count = 11: select hb3, hb2 
//================================================================================

// only consider blocksize two
assign wb_addr_mask = mSDR_TxD ? (Count > 0) ? 32'h4 : 32'h0 : 
                      mSDR_RxD ? (Count[1] ? 32'h4 : 32'h0) : 32'h0;

wire [31:0] aligned_addr = DAddress & 32'hFFFFFFFB;

/* flush one entry or all entires */
assign flush_addr = wb_flush_cnt[5] ? aligned_addr : wb_flush_cnt;

/* for flush */ 
assign masked_addr1 = wb_addr_mask | flush_addr ; 

/* for load merge */ 
assign masked_addr2 = wb_addr_mask | aligned_addr;

// wb read address
assign wb_addr = wb_flush ? masked_addr1 :  
                 CacheDataSelect ? masked_addr2 : DAddress;

		 //--------------------------------------------------------
// Burst Read timing (lb0: lower byte 0)
//
//         00(lh0)  01(lh1)  10(lh2) 11(lh3)  
//         +--------------------------------+
// ________|                                |_______
//--------------------------------------------------------

assign valid_lo     = MergeData & (Count[0] ? wb_data_valid[2] : wb_data_valid[0]);
assign valid_hi     = MergeData & (Count[0] ? wb_data_valid[3] : wb_data_valid[1]);

// Select WB read data 
assign WBDataOut    = Count[0] ? wb_data[31:16] /* lb1, lb3 */ : wb_data[15:0]; 
assign MergeData_hi = valid_hi ? WBDataOut[15 : 8] : RamDataIn[15 : 8];
assign MergeData_lo = valid_lo ? WBDataOut[ 7 : 0] : RamDataIn[7 : 0];
assign MergeDataIn  = {MergeData_hi, MergeData_lo};

// Cache write data select (refill or write)
DataMux #(`DATAWIDTH) CacheDataInputMux1 (
        .S      (CacheDataSelect),
        .A      (MData),
        .B      (DData),
        .Z      (RamDataIn));
      
DataMux #(`DATAWIDTH) CacheDataInputMux2 (
        .S      (CacheDataSelect),
        .A      ({MergeDataIn[15:0], MergeDataIn[15:0]}), // use low 16-bit data
        .B      (RamDataIn),
        .Z      (DataRamDataIn));


// RAM bank select
DataMux #(`INSNWIDTH) RamDataMux (
        .S      (DAddress[2]),
        .A      (DataRamDataOut1),
        .B      (DataRamDataOut0),
        .Z      (DataRamDataOut) );

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
        .Reset          (Reset),
        .Clk            (Clk),
        .DStrobe        (DStrobe),
        .DRD            (DRD),
        .DWR            (DWR),
        .DBE            (DBE),
        .DReady         (DReady),
        .Match          (Match),
        .Valid          (Valid),
        .TagWrite       (TagWrite),
        .RamFill        (RamFill),
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
        .Count          (Count),
        .State          (State),
        .mSDR_TxD       (mSDR_TxD),
        .mSDR_RxD       (mSDR_RxD),
        .wb_qread       (wb_qread    ),
        .wb_flush       (wb_flush  ),
        .wb_flush_once  (wb_flush_once  ),
        .wb_full        (wb_full   ),
        //.wb_addr_sel    (wb_addr_sel ),
        .wb_flush_cnt   (wb_flush_cnt   ),
        .wb_tagval_in   (wb_tagval_in ),
        .wb_tag_match   (wb_tag_match   ),
        .wb_valid       (wb_valid)
      );

WriteBufferControl WriteBufferControl (
   .Reset          (Reset),
   .Clk            (Clk),
   .RD             (DRD),
   .WR             (DWR),
   .DBE            (DBE),
   .Count          (Count),
   .Hit            (Hit),
   .mSDR_TxD       (mSDR_TxD),
   .mSDR_RxD       (mSDR_RxD),
   .State          (State),

   .wb_full        (wb_full),
   .wb_data_valid  (wb_data_valid),
   .wb_tag_match   (wb_tag_match),
   .wb_tagval_in   (wb_tagval_in),

   .wb_flush_cnt   (wb_flush_cnt),
   .MergeData      (MergeData),
   .wb_write       (wb_write),
   .wb_read        (wb_read),
   .wb_mem_en      (wb_mem_en),
   .wb_val_en      (wb_val_en),
   .wb_tag_en      (wb_tag_en),
   .wb_tagv_en     (wb_tagv_en),
   .wb_qread       (wb_qread ),
   //.wb_addr_sel    (wb_addr_sel ),
   .wb_flush       (wb_flush),
   .wb_flush_once  (wb_flush_once  ),
   .wb_mbe         (wb_mbe),
   .wb_tagval_out  (wb_tagval_out),
   .wb_valid       (wb_valid)
);

   WriteBuffer WriteBuffer (
      .clk            (Clk),
      .rst            (Reset),
      .ten            (wb_tag_en),
      .tven           (wb_tagv_en),
      .ven            (wb_val_en),
      .men            (wb_mem_en),
      .wb_read        (wb_read),
      .wb_write       (wb_write),
      .wb_flush       (wb_flush),
      .wb_mbe         (wb_mbe),
      .wb_addr        (wb_addr),
      .wb_full        (wb_full),
      .wb_tag_match   (wb_tag_match),
      .wb_tagval_in   (wb_tagval_out),
      .wb_tagval_out  (wb_tagval_in),
      .wb_data_valid  (wb_data_valid),
      .wb_mem_addr    (wb_mem_addr),
      .wb_data        (wb_data)
    );

endmodule
