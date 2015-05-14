`include "MIPS1000_defines.v"
`include "cache.h"

module ICacheControl (
  DStrobe,
  DRW,
  DReady,
  Match,
  Valid,
  TagWrite,
  RamWrite,
  CacheDataSelect,
  DDataSelect,
  Hit,   //signals a  cache Hit
  Miss, //signals a miss 
  MDataOE,
  DDataOE,
  MAddrOE,
  MGrant, 
  MStrobe, 
  MRW, 
  mSDR_TxD,
  mSDR_RxD,
  Reset, 
  Clk 
);

input           DStrobe;
output          DReady;
input           Match;
input           Valid;
output          TagWrite;
output  [7:0]   RamWrite;
output          CacheDataSelect;
output          DDataSelect;
output          Hit;	    //NEW--Added for set-associative cache
output          Miss;	    //NEW--Added for set-associative cache
output          MDataOE;
output          DDataOE;
output          MAddrOE;
input           MGrant;
output          MStrobe;
output          MRW;
input           mSDR_TxD;
input           mSDR_RxD;
input           Reset;
input           Clk;
input           DRW;


wire            RD;
reg    [12:0]   vector;
wire            DReadyEnable;
wire            WSCLoad;
wire            MStrobe;
wire            MRW;
wire            MDataOE;
wire            Write;
wire            FillEnable;
wire            Ready;
wire            CacheDataSelect;
wire            DDataSelect;
wire            Miss;
wire            DDataOE;

//reg             Hit;
reg     [3:0]   State;
reg     [3:0]   NextState;
reg     [2:0]   NextCount;
reg     [2:0]   Count;
reg     [7:0]   WriteMask;

`ifdef vbs
  reg [`IC_INDEXSIZE - 1 : 0] index;
`endif

assign RD = DRW;  // Read asserted high
assign Hit = Match & Valid;  
wire DReady = (DReadyEnable & RD) | Ready;


always @ (posedge Clk) begin
  if (Reset)
  begin
    State <= `STATE_IDLE;
    Count <= 3'd0;
  end
  else
  begin
    State <= NextState;
    Count <= NextCount;
  end
end

always @ (*) begin
  NextState = State; 
  NextCount = Count;
  case (State)
     `STATE_IDLE: 
     begin
       if (DStrobe && RD) begin
         //=====================================================
         if (`vbs) 
           $display($time,, "ic_ctrl > Processor Read Addr %h", 
           TestBench.DUT_RTL.ICache.DAddress);
         //=====================================================
         NextState = `STATE_READ;
       end
       else begin
         //=====================================================
         if (`vbs) $display($time,, "ic_ctrl> Idle");
         //=====================================================
         NextState = `STATE_IDLE;
       end
     end

     `STATE_READ:
     begin
       //=====================================================
       #2; // Read stable data
       if (`vbs) begin
         $write($time,, "ic_ctrl> Read ");
         $write("%s", Match & Valid ? "Hit" : "Miss");
         index = TestBench.DUT_RTL.ICache.DAddress[`IINDEX];
         $display(" at cache Index - %h Tag- %h <> ValidRam- %b TagRam- %h", 
                    index,
                    TestBench.DUT_RTL.ICache.DAddress[`ITAG],
                    TestBench.DUT_RTL.ICache.ValidRam.ValidBits[index],
                    TestBench.DUT_RTL.ICache.TagRam.TagRam[index]);
       end
       //=====================================================
       if (Match & Valid) begin    // read hit
         NextState = `STATE_IDLE;
       end
       else begin                        // read miss
         NextState = `STATE_READMISS;
       end
     end

     `STATE_READMISS:
     begin
       if (MGrant) begin
       //=====================================================
         if (`vbs) $display($time,, "ic_ctrl> Read Miss Granted" );
       //=====================================================
         NextState = `STATE_READMEM; //`STATE_GRANT;
       end
       else begin
       //=====================================================
         if (`vbs) $display($time,, "ic_ctrl> Waiting: Bus grant");
       //=====================================================
         NextState = `STATE_READMISS;
       end
     end

     /*
     `STATE_GRANT:
     begin
       if (`vbs) $display(" ic_ctrl> READMISS", $time);
       if (CMDACK) begin
         NextState = `STATE_READMEM;
       end
       else begin
         NextState = `STATE_GRANT;
       end
     end
     */

     `STATE_READMEM:
     begin
       if (mSDR_RxD)
       begin
       //=====================================================
         if (`vbs) 
           $display($time,, "ic_ctrl > Burst Read data: %h",
                             TestBench.DUT_RTL.ICache.MData);
       //=====================================================
         NextState = `STATE_READMEM;
         NextCount = Count + 3'b1;
       end
       else if (Count == `BURST_COUNT)
       begin
         NextState = `STATE_READDATA;
         NextCount = 3'd0;
       end
       else
       begin
         NextState = `STATE_READMEM;
         NextCount = 3'd0;
       end
     end

     `STATE_READDATA:
     begin
       //=====================================================
       #2; // Read stable data
       if (`vbs) begin
         index = TestBench.DUT_RTL.ICache.DAddress[`IINDEX];
         $display($time,, "dump > ICache Refilled Data: %b %h  %h%h%h%h %h%h%h%h", 
           TestBench.DUT_RTL.ICache.ValidRam.ValidBits[index], 
           TestBench.DUT_RTL.ICache.TagRam.TagRam[index], 
           TestBench.DUT_RTL.ICache.DataRam_D13.DataRam[index], 
           TestBench.DUT_RTL.ICache.DataRam_D12.DataRam[index], 
           TestBench.DUT_RTL.ICache.DataRam_D11.DataRam[index], 
           TestBench.DUT_RTL.ICache.DataRam_D10.DataRam[index], 
           TestBench.DUT_RTL.ICache.DataRam_D03.DataRam[index], 
           TestBench.DUT_RTL.ICache.DataRam_D02.DataRam[index], 
           TestBench.DUT_RTL.ICache.DataRam_D01.DataRam[index], 
           TestBench.DUT_RTL.ICache.DataRam_D00.DataRam[index]);
       end
       if (`vbs) $display($time,, "ic_ctrl > Processor Read Instruction: %h", 
                                  TestBench.DUT_RTL.ICache.DData);
       //=====================================================
       NextState = `STATE_IDLE;
     end

     default:
       NextState = `STATE_IDLE;
  endcase
end

/*
assign  Miss                 = vector[10];    //NEW--Added for 4-way cache 
assign  WSCLoad              = vector[9];
assign  DReadyEnable         = vector[8];
assign  Ready                = vector[7];     // signal driver
assign  Write                = vector[6];     // to cache rams
assign  MStrobe              = vector[5];     // memory strobe
assign  MRW                  = vector[4];
assign  CacheDataSelect      = vector[3];
assign  DDataSelect          = vector[2];
assign  DDataOE              = vector[1];
assign  MDataOE              = vector[0];
*/

/* No tag write on read hit */
assign  TagWrite             = vector[12] & ~(Match & Valid);    //NEW--Added for 4-way cache 
assign  Miss                 = vector[11];    //NEW--Added for 4-way cache 
assign  WSCLoad              = vector[10];
assign  DReadyEnable         = vector[9] & Match & Valid;
assign  Ready                = vector[8];     
assign  FillEnable           = /*vector[7] |*/ mSDR_RxD; 
assign  MStrobe              = vector[6];     // memory strobe
assign  MRW                  = vector[5];
assign  CacheDataSelect      = /*vector[4]; */mSDR_RxD; 
assign  DDataSelect          = vector[3];
assign  DDataOE              = vector[2] & Match & Valid;
assign  MDataOE              = vector[1];
assign  MAddrOE              = vector[0];

// Effective when mSDR_RxD is asserted high
assign RamWrite = {8{FillEnable}} & WriteMask;

// On miss and request granted, load cache from LSB to MSB
always @ (posedge Clk) begin
  if (Reset) 
    WriteMask <= 8'b0000_0000;
  else if (mSDR_RxD & MGrant)
    WriteMask <= WriteMask << 2;
  else if (MGrant)
    WriteMask <= 8'b0000_0011;
  else
    WriteMask <= 8'b0000_0000;
end

always @ (State) begin
  case (State)
    `STATE_IDLE:      vector = `Pt_Idle;
    `STATE_READ:      vector = `Pt_DReadyEnable | `Pt_TagWrite | `Pt_DDataOE; 
    `STATE_READMISS:  vector = `Pt_Miss | `Pt_WSCLoad | `Pt_MStrobe | `Pt_MRW; 
    `STATE_READMEM:   vector = `Pt_Miss | `Pt_MRW | `Pt_MAddrOE ;
    `STATE_READDATA:  vector = `Pt_Ready | `Pt_DDataOE;
    default :         vector = `Pt_Idle;
  endcase
end

endmodule /* FSM control */
