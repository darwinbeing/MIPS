`include "cache.h"

//===================================================================================
// TagWrite: update ValidRam, TagRam is updated when asserted
// RamWrite: update DataRam with the pattern values of RamWrite (memory -> cache)
// CpuWrite: update DataRam when asserted (cpu -> cache)
// CacheDataSelect: select cpu data or memory data
//===================================================================================
module DCacheControl (
  DStrobe,
  DRD,
  DWR,
  DReady,
  Match,
  Valid,
  TagWrite,
  RamWrite,
  CpuWrite,
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
input                DRD;
input  [`DATASLICE] DWR;
output          DReady;
input           Match;
input           Valid;
output          TagWrite;
output [`WRMASK]   RamWrite;
output          CpuWrite;
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


parameter       FILL_MASK_SIZE = `NBYTES * `BSIZE;

wire            RD;
wire            WR;
reg    [12:0]   vector;
wire            DReadyEnable;
wire            WSCLoad;
wire            MStrobe;
wire            MRW;
wire            MDataOE;
wire            CpuWrite;
wire            FillEnable;
wire            Ready;
wire            CacheDataSelect;
wire            DDataSelect;
wire            Miss;
wire            DDataOE;

reg     [3:0]   State;
reg     [3:0]   NextState;
reg     [2:0]   NextCount;
reg     [2:0]   Count;
reg [`WRMASK]   FillMask;

`ifdef vbs
  reg [`IC_INDEXSIZE - 1 : 0] index;
`endif

assign WR = | DWR;  // Write asserted
assign RD = DRD;    // Read asserted
wire DReady = (DReadyEnable & (RD | WR)) | Ready;

assign Hit = Match & Valid;  

// Memory read/write checker
always @ (posedge Clk) begin
  if (WR && RD) begin
     $display($stime,, "Error: Simultaneous Cache reads & writes not supported.");
     $stop;
  end
end

// Next State registers
always @ (posedge Clk) begin
  if (Reset)
  begin
    State <= `STATE_IDLE;
    Count <= 3'b0;
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
           $display($time,, "dc_ctrl > Processor Read Addr %h", 
           TestBench.DUT_RTL.DCache.DAddress);
         //=====================================================
         NextState = `STATE_READ;
       end
       else if (DStrobe && WR) begin
         //=====================================================
         if (`vbs) 
           $display($time,, "dc_ctrl > Processor Write Addr %h", 
           TestBench.DUT_RTL.DCache.DAddress);
         //=====================================================
         NextState = `STATE_WRITE;
       end
       else begin
         if (`vbs) $display($time,, "dc_ctrl > IDLE");
         NextState = `STATE_IDLE;
       end
     end
     `STATE_READ:
     begin
       //=====================================================
       if (`vbs) begin
         $write($time,, "dc_ctrl> Read ");
         $write("%s", Match & Valid ? "Hit" : "Miss");
         index = TestBench.DUT_RTL.DCache.DAddress[`IINDEX];
         $display(" at cache Index - %h Tag- %h <> ValidRam- %b TagRam- %h", 
                    index,
                    TestBench.DUT_RTL.DCache.DAddress[`ITAG],
                    TestBench.DUT_RTL.DCache.ValidRam.ValidBits[index],
                    TestBench.DUT_RTL.DCache.TagRam.TagRam[index]);
       end
       //=====================================================
         if (Hit) begin
           NextState = `STATE_IDLE;
         end
         else begin 
           NextState = `STATE_READMISS;
         end
     end

     `STATE_READMISS:
     begin
       //=====================================================
         if (`vbs) $display($time,, "dc_ctrl> Read Miss Granted" );
       //=====================================================
       if (MGrant) begin
         NextState = `STATE_READMEM; //`STATE_GRANT;
       end
       else begin
       //=====================================================
         if (`vbs) $display($time,, "dc_ctrl> Waiting for Bus grant");
       //=====================================================
         NextState = `STATE_READMISS;
       end
     end

     `STATE_READMEM:
     begin
       //=====================================================
         if (`vbs) 
           $display($time,, "dc_ctrl > Burst Read data: %h",
                             TestBench.DUT_RTL.DCache.MData);
       //=====================================================
       if (mSDR_RxD)
       begin
         NextState = `STATE_READMEM;
         NextCount = Count + 3'b1;
       end
       else if (Count == `BURST_COUNT)
       begin
         NextState = `STATE_READDATA;
         NextCount = 3'b0;
       end
       else
       begin
         NextState = `STATE_READMEM;
         NextCount = 3'b0;
       end
     end

     `STATE_READDATA:
     begin
       //=====================================================
       #2; // Read stable data
       if (`vbs) begin
         index = TestBench.DUT_RTL.DCache.DAddress[`IINDEX];
         $display($time,, "dump > DCache Refilled Data: %b %h  %h%h%h%h %h%h%h%h", 
           TestBench.DUT_RTL.DCache.ValidRam.ValidBits[index], 
           TestBench.DUT_RTL.DCache.TagRam.TagRam[index], 
           TestBench.DUT_RTL.DCache.DataRam_D13.DataRam[index], 
           TestBench.DUT_RTL.DCache.DataRam_D12.DataRam[index], 
           TestBench.DUT_RTL.DCache.DataRam_D11.DataRam[index], 
           TestBench.DUT_RTL.DCache.DataRam_D10.DataRam[index], 
           TestBench.DUT_RTL.DCache.DataRam_D03.DataRam[index], 
           TestBench.DUT_RTL.DCache.DataRam_D02.DataRam[index], 
           TestBench.DUT_RTL.DCache.DataRam_D01.DataRam[index], 
           TestBench.DUT_RTL.DCache.DataRam_D00.DataRam[index]);
       end
       if (`vbs) $display($time,, "dc_ctrl > Processor Load Data: %h", 
                                  TestBench.DUT_RTL.DCache.DData);
       //=====================================================
       NextState = `STATE_IDLE;
     end

     `STATE_WRITE: 
     begin
       //=====================================================
       if (`vbs) begin
         $write($time,, "dc_ctrl > Write ");
         $display("%s", Hit ? "Hit" : "Miss");
       end
       //=====================================================
       if (Hit) begin
         NextState = `STATE_WRITEHIT;
       end
       else begin
         NextState = `STATE_WRITEMISS;
       end
     end

     `STATE_WRITEHIT:
     begin
       if (MGrant) begin
         index = TestBench.DUT_RTL.DCache.DAddress[`IINDEX];
         $display($time,, "dc_ctrl > Write Hit updated at cache Index - %h Tag- %h <> ValidRam- %b TagRam- %h DataRam %h%h%h%h %h%h%h%h",  
                      index,
                      TestBench.DUT_RTL.DCache.DAddress[`ITAG],
                      TestBench.DUT_RTL.DCache.ValidRam.ValidBits[index],
                      TestBench.DUT_RTL.DCache.TagRam.TagRam[index],
                      TestBench.DUT_RTL.DCache.DataRam_D13.DataRam[index], 
                      TestBench.DUT_RTL.DCache.DataRam_D12.DataRam[index], 
                      TestBench.DUT_RTL.DCache.DataRam_D11.DataRam[index], 
                      TestBench.DUT_RTL.DCache.DataRam_D10.DataRam[index], 
                      TestBench.DUT_RTL.DCache.DataRam_D03.DataRam[index], 
                      TestBench.DUT_RTL.DCache.DataRam_D02.DataRam[index], 
                      TestBench.DUT_RTL.DCache.DataRam_D01.DataRam[index], 
                      TestBench.DUT_RTL.DCache.DataRam_D00.DataRam[index]);
       //=====================================================
         if (`vbs) $display($time,, "dc_ctrl> Write Hit Granted");
       //=====================================================
         NextState  = `STATE_WRITEMEM;
       end
       else begin
       //=====================================================
         if (`vbs) $display($time,, "dc_ctrl> Waiting for Bus grant");
       //=====================================================
         NextState = `STATE_WRITEHIT;
       end
     end

     `STATE_WRITEMISS: 
     begin
       if (MGrant) begin
       //=====================================================
         if (`vbs) $display($time,, "dc_ctrl> Write Miss Granted");
       //=====================================================
         NextState  = `STATE_WRITEMEM;
       end
       else begin
       //=====================================================
         if (`vbs) $display($time,, "dc_ctrl> Waiting for Bus grant");
       //=====================================================
         NextState = `STATE_WRITEMISS;
       end
     end

     `STATE_WRITEMEM:
     begin
       if (mSDR_TxD) begin
       //=====================================================
         if (`vbs) 
           $display($time,, "dc_ctrl > Burst Write data: %h",
                             TestBench.DUT_RTL.DCache.MData);
       //=====================================================
         NextState = `STATE_WRITEMEM;
         NextCount = Count + 3'b1;
       end
       else if (Count == `BURST_COUNT)
       begin
         NextState = `STATE_WRITEDATA;
         NextCount = 3'd0;
       end
       else
       begin
         NextState = `STATE_WRITEMEM;
         NextCount = 3'd0;
       end
     end

     `STATE_WRITEDATA:
     begin
       if (`vbs) $display(" ctrl> WRITEDATA", $time);
       NextState = `STATE_IDLE;
     end

     default:
       NextState = `STATE_IDLE;
  endcase
end

// tag write on read miss
// no cache write on miss
assign  TagWrite         = vector[12] & ~Hit; //NEW--Added for 4-way cache  
assign  Miss             = vector[11];    //NEW--Added for 4-way cache 
assign  WSCLoad          = vector[10];
assign  DReadyEnable     = vector[9] & Hit;
assign  Ready            = vector[8];     // signal driver
assign  FillEnable       = /*vector[7] |*/ mSDR_RxD;     // to cache rams
assign  CpuWrite         = vector[7] & Hit; 
assign  MStrobe          = vector[6];     // memory strobe
assign  MRW              = vector[5];
assign  CacheDataSelect  = /*vector[4]; */mSDR_RxD; 
assign  DDataSelect      = vector[3] & Hit;
assign  DDataOE          = vector[2] & Hit;
assign  MDataOE          = vector[1];
assign  MAddrOE          = vector[0];

// Cache byte write enable only when FillEnable is high 
assign RamWrite = {FILL_MASK_SIZE{FillEnable}} & FillMask;

// On miss load cache from LSB to MSB
always @ (posedge Clk) begin
  if (Reset) 
    FillMask <= {FILL_MASK_SIZE{1'b0}};
  else if (mSDR_RxD & MGrant)
    FillMask <= FillMask << 2;
  else if (MGrant)
    FillMask <= {FILL_MASK_SIZE{1'b0}} | 2'b11;
  else
    FillMask <= {FILL_MASK_SIZE{1'b0}};
end

 // write: MRW low and read: MRW high
always @ (State) begin
  case (State)
    `STATE_IDLE:      vector = `Pt_Idle;
    `STATE_READ:      vector = `Pt_DReadyEnable | `Pt_TagWrite | `Pt_DDataOE; 
    `STATE_READMISS:  vector = `Pt_Miss  | `Pt_WSCLoad | `Pt_MStrobe | `Pt_MRW; 
    `STATE_READMEM:   vector = `Pt_Miss  | `Pt_MRW | `Pt_MAddrOE ;
    `STATE_READDATA:  vector = `Pt_Ready | `Pt_DDataOE;

    `STATE_WRITE:     vector =  /* `Pt_DReadyEnable | `Pt_TagWrite |*/  `Pt_CpuWrite;
    `STATE_WRITEHIT:  vector = `Pt_WSCLoad | /*`Pt_MRW |*/ `Pt_MStrobe;
    `STATE_WRITEMISS: vector = `Pt_Miss | `Pt_WSCLoad | /*`Pt_MRW |*/ `Pt_MStrobe;
    `STATE_WRITEMEM:  vector = `Pt_Miss | `Pt_MDataOE | `Pt_MAddrOE;
    `STATE_WRITEDATA: vector = `Pt_Ready | `Pt_MDataOE; 
    default :         vector = `Pt_Idle;
  endcase
end

endmodule /* FSM control */
