`include "cache.h"

//===================================================================================
// TagWrite: update ValidRam, TagRam is updated when asserted
// RamFill: update DataRam with the pattern values of RamFill (memory -> cache)
// CpuWrite: update DataRam when asserted (cpu -> cache)
// CacheDataSelect: select cpu data or memory data
//===================================================================================
module DCacheControl (
  input           DStrobe,
  input                DRD,
  input                DWR,
  input  [`DATASLICE] DBE,
  output          DReady,
  input           Match,
  input           Valid,
  output          TagWrite,
  output [`WRMASK]   RamFill,
  output          CpuWrite,
  output          CacheDataSelect,
  output          DDataSelect,
  output          Hit,	    //NEW--Added for set-associative cache
  output          Miss,	    //NEW--Added for set-associative cache
  output          MDataOE,
  output          DDataOE,
  output          MAddrOE,
  input           MGrant,
  output          MStrobe,
  output          MRW,
  output reg [2 : 0] Count,
  output reg      MergeData,
  input           mSDR_TxD,
  input           mSDR_RxD,
  input           Reset,
  input           Clk,

  output reg      wb_write    ,
  output reg      wb_read     ,
  output reg      wb_mem_en   ,
  output reg      wb_val_en   ,
  output reg      wb_tag_en   ,
  output reg      wb_qread    ,
  output reg      wb_addr_sel ,
  output [5:0]    wb_flush_cnt ,
  output reg      wb_flush    ,
  output reg [3:0] wb_mbe    ,

  input           wb_full     ,
  input  [3:0]    wb_data_valid,
  input           wb_tag_match ,
  input           wb_tagval_in,
  output reg      wb_tagval_out
);

parameter       FILL_MASK_SIZE = `NBYTES * `BSIZE;

wire            RD;
wire            WR;
reg    [12:0]   vector;
wire            DReadyEnable;
wire            WSCLoad;
wire            FillEnable;
wire            Ready;

reg     [3:0]   State;
reg     [3:0]   NextState;
reg     [2:0]   NextCount;
reg [`WRMASK]   FillMask;

`ifdef vbs
  reg [`IC_INDEXSIZE - 1 : 0] index;
`endif

//============================== 
// 4-entry WB
//============================== 
reg     [5:0]   NextFlushCount;
reg     [5:0]   FlushCount;
reg             NextMergeData;
reg             NextMAddrSelect;
reg             MAddrSelect;
reg             wb_valid;


assign WR = DWR;  // Write asserted
assign RD = DRD;    // Read asserted
assign DReady = (DReadyEnable & (RD | WR)) | Ready | wb_qread;

assign Hit = Match & Valid;  

assign wb_flush_cnt = FlushCount;
assign wb_addr_sel = MAddrSelect;


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
    FlushCount <= 6'b0;
    MergeData  <= 1'b0;
    MAddrSelect <= 1'b0;
  end
  else
  begin
    State <= NextState;
    Count <= NextCount;
    FlushCount <= NextFlushCount;
    MergeData  <= NextMergeData;
    MAddrSelect <= NextMAddrSelect; 
  end
end

always @ (*) begin
  NextState = State; 
  NextCount = Count;
  NextFlushCount = FlushCount;
  NextMergeData  = MergeData;
  NextMAddrSelect = MAddrSelect;
  case (State)
     `STATE_IDLE: 
     begin
       if (wb_full) begin 
         NextState = `STATE_WRITEMISS;
         NextMAddrSelect = 1'b1;
         NextFlushCount <= 6'b0;
       end
       else if (wb_flush & (FlushCount != 6'b100_000)) begin
         NextState = `STATE_WRITEMISS;
       end
       else begin
         NextMAddrSelect = 1'b0;

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
           NextState = `STATE_READWB;
         end
     end

      `STATE_READWB:
      begin
        if (`vbs) $display(" dc_ctrl> READWB", $time);
        if (!wb_tagval_in) begin
        //--------------------------------------------------------
        // tag invalid
        // write: write data/tag to write buffer, no sdram write
        // read : sdram read
        //--------------------------------------------------------
          if (WR) NextState = `STATE_WRITEDATA;
          if (RD) NextState = `STATE_READMISS;
        end
        else begin 
          if (wb_tag_match) begin
          //--------------------------------------------------------
          // tag match & tag valid
          // write: write buffer write(may overwrite old contents)
          // read : 
          //   if data valid, then 
          //     read write buffer bypassing sdram read
          //   else 
          //     sdram read and merge data with write buffer
          //--------------------------------------------------------
            if (WR)  begin
              NextState = `STATE_WRITEDATA;
            end
            if (RD) begin 
              if (wb_valid) 
                NextState = `STATE_IDLE;
              else begin
                NextState = `STATE_READMISS; 
                NextMergeData  = 1'b1;
              end
            end
          end
          else begin 
            //--------------------------------------------------------
            // tag mismatch & tag valid
            // write: sdram write, then write buffer write
            // read : sdram read
            //--------------------------------------------------------
            if (WR) begin 
              NextState = `STATE_WRITEMISS;
              NextMAddrSelect = 1'b1;
            end
            if (RD)
             NextState = `STATE_READMISS; 
          end
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
       NextMergeData  = 1'b0;
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
       /*
       if (Hit) begin
         NextState = `STATE_WRITEHIT;
       end
       else begin
         NextState = `STATE_WRITEMISS;
       end
       */
         NextState = `STATE_READWB;
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
       if (`vbs) $display($time, "dc_ctrl> WRITEDATA");
       if (`vbs) $display($time, "dc_ctrl> Clear WB count = %d", FlushCount);
        if (wb_flush) begin
          NextFlushCount <= FlushCount + 6'b001_000;
        end
        else begin
          NextMAddrSelect = 1'b0;
        end

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
assign  CpuWrite         = vector[7] & Hit; // write on cache write hit 
assign  MStrobe          = vector[6] | wb_flush;     // memory strobe
assign  MRW              = vector[5];
assign  CacheDataSelect  = /*vector[4]; */mSDR_RxD; 
assign  DDataSelect      = vector[3] & Hit;
assign  DDataOE          = vector[2] & Hit;
assign  MDataOE          = vector[1];
assign  MAddrOE          = vector[0];

// Cache byte write enable only when FillEnable is high 
assign RamFill = {FILL_MASK_SIZE{FillEnable}} & FillMask;

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


//============================================================================
// Write Buffer control
//============================================================================

always @ (*) begin
  if (wb_read) begin
    case (DBE)
      4'b0001: wb_valid = wb_data_valid[0];
      4'b0010: wb_valid = wb_data_valid[1];
      4'b0100: wb_valid = wb_data_valid[2];
      4'b1000: wb_valid = wb_data_valid[3];
      4'b0011: wb_valid = wb_data_valid[1] & wb_data_valid[0];
      4'b1100: wb_valid = wb_data_valid[3] & wb_data_valid[2];
      4'b1111: wb_valid = wb_data_valid[3] & wb_data_valid[2] & 
                          wb_data_valid[1] & wb_data_valid[0];
      default: wb_valid = 1'b0;
    endcase
  end
  else wb_valid = 1'b0;
end

always @ (*) begin
  wb_mbe      = DBE;
  wb_write    = 1'b0;
  wb_read     = 1'b0;
  wb_qread    = 1'b0;
  wb_mem_en   = 1'b0;
  wb_val_en   = 1'b0;
  wb_tag_en   = 1'b0;
  wb_tagval_out = 1'b0;

  case (State)
    `STATE_IDLE:
    begin
      if (wb_full || wb_flush & FlushCount != 6'b100_000) begin
      //=====================================================
      if (`vbs) $display($time,, "dc_ctrl > WB full");
      //=====================================================
        wb_write  = 1'b1;
        wb_tag_en = 1'b1;
        wb_tagval_out = 1'b0;  // clear tag valid
      end
    end

    // For read miss and write miss/hit, access write buffer to check
    // write-buffer hit 
    `STATE_READ:
    begin
      //=====================================================
      if (`vbs) $display($time,, "dc_ctrl > Enable WB read");
      //=====================================================
      wb_read     = ~Hit;
      wb_val_en   = ~Hit;
      wb_tag_en   = ~Hit;
    end

    `STATE_WRITE:
    begin
      //=====================================================
      if (`vbs) $display($time,, "dc_ctrl > Enable WB read");
      //=====================================================
      wb_read     = 1'b1; 
      wb_val_en   = 1'b1;  
      wb_tag_en   = 1'b1;
    end

    `STATE_READWB :
    begin
//--------------------------------------------------------
// tag invalid
// write: write data/tag to write buffer, no sdram write
// read : sdram read
//--------------------------------------------------------
      if (!wb_tagval_in) begin
        //=====================================================
        if (`vbs) $display($time,, "dc_ctrl > WB tag invalid");
        //=====================================================
        wb_write  = WR;
        wb_val_en = WR;
        wb_tag_en = WR;
        wb_mem_en = WR; 
        wb_tagval_out = 1'b1;
      end

      else begin 
//--------------------------------------------------------
// 3: tag match & tag valid
// write: write buffer write(may overwrite old contents)
// read : 
//   if data valid, then 
//     read write buffer bypassing sdram read
//   else 
//     sdram read and merge data with write buffer
//--------------------------------------------------------
        if (wb_tag_match) begin
          if (WR)  begin
            //=================================================================
            if (`vbs) $display($time,, "dc_ctrl > WB write: tag match & valid");
            //=================================================================
            wb_write  = 1'b1;
            wb_val_en = 1'b1;
            wb_mem_en = 1'b1;
          end

          if (RD) begin
            if (wb_valid) begin 
            //=================================================================
            if (`vbs) $display($time,, "dc_ctrl > WB read: tag match & valid");
            //=================================================================
            // bypass SDRAM read and no cache fill
              wb_qread  = 1'b1; 
              wb_read   = 1'b1;
              wb_val_en = 1'b1;
              wb_mem_en = 1'b1;
            end
          end
        end

//--------------------------------------------------------
// tag mismatch & tag valid
// write: sdram write, then write buffer write
// read : sdram read
//--------------------------------------------------------
        else begin // tag mismatch
          //=================================================================
          if (`vbs) $display($time,, "dc_ctrl > WB tag mismatch & valid");
          //=================================================================
          // SDR write first 
          
        end
      end
    end

     `STATE_WRITEMEM:
     begin
        wb_read = 1'b1;     // enable data read
        wb_mem_en = 1'b1; 

        if (wb_flush &&  (Count == 2'b00 || Count == 2'b10)) begin
          wb_write = 1'b1; 
          wb_val_en = 1'b1;
          wb_mbe = 4'b1111; // clear data valid bits
        end
        else begin
          wb_mbe = wb_data_valid;
        end
     end


     `STATE_READMEM:
     begin
       if (mSDR_RxD)
       begin
         wb_read = 1'b1;
         wb_mem_en = 1'b1; 
       end
     end

  default:;
  endcase
end

always @ (posedge Clk) begin
  if (Reset)
    wb_flush <= 1'b0;
  else if (wb_full)
    wb_flush <= 1'b1;
  else if (wb_flush & FlushCount == 6'b100_000)
    wb_flush <= 1'b0;
end

endmodule /* FSM control */
