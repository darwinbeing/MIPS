`include "MIPS1000_defines.v"
`include "cache.h"

//============================================================================================
// Data Cache control with a write buffer 
//============================================================================================
module DCacheControl (
  input                Reset,
  input                Clk,
  input                DStrobe,
  input                DRD,
  input                DWR,
  input  [`DATASLICE]  DBE,
  output               DReady,
  input                Match,           // Data Cache tag match
  input                Valid,           // Data Cache tag match and valid
  output               TagWrite,        // update ValidRam, TagRam is updated when asserted
  output [`WRMASK]     RamFill,         // update DataRam with the pattern values of RamFill (memory -> cache)
  output               CpuWrite,        // CpuWrite: update DataRam when asserted (cpu -> cache)
  output               CacheDataSelect, // CacheDataSelect: select cpu data or memory data
  output               DDataSelect,
  output               Hit,	    //NEW--Added for set-associative cache
  output               Miss,	    //NEW--Added for set-associative cache
  output               MDataOE,
  output               DDataOE,
  output               MAddrOE,
  input                MGrant,
  output               MStrobe,
  output               MRW,         // write: MRW low ; read: MRW high
  output reg [2 : 0]   Count,
  output reg [3 : 0]   State,

  input                mSDR_TxD,
  input                mSDR_RxD,
  input                wb_qread    ,   // Read data from write buffer
  input                wb_flush    ,   // flush write buffer data to sdram
  input                wb_flush_once,  // flush write buffer data(one entry) to sdram
  input                wb_full     ,   // write buffer is full
  input  [5:0]         wb_flush_cnt,   // counting the current write buffer entry
  input                wb_tag_match,   // write buffer tag match
  input                wb_tagval_in,   // write buffer tag valid
  input                wb_valid        // write buffer read data valid
);

parameter       FILL_MASK_SIZE = `NBYTES * `BSIZE;

wire            RD;
wire            WR;
reg    [12:0]   vector;
wire            DReadyEnable;
wire            WSCLoad;
wire            FillEnable;
wire            Ready;

reg     [3:0]   NextState;
reg     [2:0]   NextCount;
reg [`WRMASK]   FillMask;

// synthesis translate_off
// performance counters
integer read_dc_miss_count;
integer write_dc_miss_count;
integer read_wb_miss_count;
integer write_wb_miss_count;

integer read_dc_count;
integer write_dc_count;
integer read_wb_count;
integer write_wb_count;
integer read_mem_count;
integer write_mem_count;
integer flush_wb_count;

initial begin
  read_dc_miss_count = 0;
  write_dc_miss_count = 0;
  read_wb_miss_count = 0;
  write_wb_miss_count = 0;
  read_dc_count = 0;
  write_dc_count = 0;
  read_wb_count = 0;
  write_wb_count = 0;
  read_mem_count = 0;
  write_mem_count = 0;
  flush_wb_count = 0;
end

always @ (posedge Clk) begin
  if (State == `STATE_WRITE) begin
    write_dc_count++;
    write_wb_count++;
  end
    
  if (State == `STATE_WRITE) begin
    if (!Hit) write_dc_miss_count++;
  end

  if (State == `STATE_READ) begin
    read_dc_count++;
    if (!Hit) begin
      read_dc_miss_count++;
      read_wb_count++;
    end
  end

  if (State == `STATE_READWB && 
      NextState == `STATE_WRITEMISS) begin
    write_wb_miss_count++;
  end

  if (State == `STATE_READWB && 
      NextState == `STATE_READMISS) begin
    read_wb_miss_count++;
  end

  if (State == `STATE_READMISS &&
      NextState == `STATE_READMEM) begin
    read_mem_count++;
  end

  if ((State == `STATE_WRITEMISS ||
       State == `STATE_WRITEHIT)  &&
       NextState == `STATE_WRITEMEM) begin
    write_mem_count++;
    if (wb_flush) flush_wb_count++;
  end
end

always @ (posedge Clk) 
  if (TestBench.DUT_BEH.Processor.PC == 32'h14) begin
   $display("DC read count  = %d", read_dc_count);
   $display("DC read miss   = %d", read_dc_miss_count);
   $display("WB read count  = %d", read_wb_count);
   $display("WB read miss   = %d", read_wb_miss_count);

   $display("DC write count = %d", write_dc_count);
   $display("DC write miss  = %d", write_dc_miss_count);
   $display("WB write count = %d", write_wb_count);
   $display("WB write miss  = %d", write_wb_miss_count);

   $display("MEM write count= %d", write_mem_count);
   $display("MEM read count = %d", read_mem_count);
   $display("WB flush count = %d", flush_wb_count);

   $stop;
  end
// synthesis translate_on


`ifdef vbs
  reg [`IC_INDEXSIZE - 1 : 0] index;
`endif


assign WR = DWR;  
assign RD = DRD; 

//-------------------------------------------------------------------------------
// Also assert DReady when load data is found in the write buffer
// and bypassing data cache
//-------------------------------------------------------------------------------
assign DReady = DReadyEnable | Ready | wb_qread; 

assign Hit = Match & Valid;  

// synthesis translate_off
always @ (posedge Clk) begin
  if (WR && RD) begin
     $display($stime,, "Error: Simultaneous Cache reads & writes not supported.");
     $stop;
  end
end
// synthesis translate_on

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
       if (wb_full || wb_flush) begin 
         NextState = `STATE_WRITEMISS;
       end
       else if (DStrobe && RD) begin
         //==============================================================
         // synthesis translate_off
         if (`vbs) $display($time,, "dc_ctrl > Processor Read Addr %h", 
           TestBench.DUT_RTL.DCache.DAddress);

         // synthesis translate_on
         //==============================================================
         NextState = `STATE_READ;
       end 
       else if (DStrobe && WR) begin
         //==============================================================
         // synthesis translate_off
         if (`vbs) 
           $display($time,, "dc_ctrl > Processor Write Addr %h", 
           TestBench.DUT_RTL.DCache.DAddress);

         // synthesis translate_on
         //==============================================================
         NextState = `STATE_WRITE;
       end
       else begin
         //==============================================================
         // synthesis translate_off
         if (`vbs) $display($time,, "dc_ctrl > IDLE");
         // synthesis translate_on
         //==============================================================
         NextState = `STATE_IDLE;
       end
     end
     `STATE_READ:
     begin
       //==============================================================
       // synthesis translate_off
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
       // synthesis translate_on
       //==============================================================
         if (Hit) begin
           NextState = `STATE_IDLE;
         end
         else begin 
           NextState = `STATE_READWB;
         end
     end

      `STATE_READWB:
      begin
        //==============================================================
        // synthesis translate_off
        if (`vbs) $display(" dc_ctrl> READWB", $time);
        // synthesis translate_on
        //==============================================================
        if (!wb_tagval_in) begin
        //--------------------------------------------------------
        // tag invalid
        // write: write data/tag to write buffer, no sdram write
        // read : sdram read
        //--------------------------------------------------------
          if (WR) begin 
            NextState = `STATE_WRITEDATA;
          end

          if (RD) begin
            NextState = `STATE_READMISS;
          end
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
                //NextState = `STATE_READDATA;
                NextState = `STATE_IDLE; // quick read (combinational)
              else begin
                NextState = `STATE_READMISS; 
              end
            end
          end
          else begin 
            //--------------------------------------------------------
            // tag mismatch & tag valid
            // write: sdram write and then write buffer write
            // read : sdram write and then sdram read
            //--------------------------------------------------------
            NextState = `STATE_WRITEMISS;
            /*
            if (WR) begin 
              NextState = `STATE_WRITEMISS;
            end
            if (RD)
             NextState = `STATE_READMISS; 
            */
          end
        end
      end

     `STATE_READMISS:
     begin
       //==============================================================
       // synthesis translate_off
         if (`vbs) $display($time,, "dc_ctrl> Read Miss Granted" );
       // synthesis translate_on
       //============================================================
       if (MGrant) begin
         NextState = `STATE_READMEM; 
       end
       else begin
       //==============================================================
       // synthesis translate_off
         if (`vbs) $display($time,, "dc_ctrl> Waiting for Bus grant");
       // synthesis translate_on
       //==============================================================
         NextState = `STATE_READMISS;
       end
     end

     `STATE_READMEM:
     begin
       //==============================================================
       // synthesis translate_off
         if (`vbs) 
           $display($time,, "dc_ctrl > Burst Read data: %h",
                             TestBench.DUT_RTL.DCache.MData);
       // synthesis translate_on
       //==============================================================
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
       //==============================================================
       // synthesis translate_off
       #2; // Read stable data
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
           $display($time,, "dc_ctrl > Processor Load Data: %h", 
                                  TestBench.DUT_RTL.DCache.DData);
       // synthesis translate_on
       //==============================================================
       NextState = `STATE_IDLE;
     end

     `STATE_WRITE: 
     begin
       //==============================================================
       // synthesis translate_off
       if (`vbs) begin
         $write($time,, "dc_ctrl > Write ");
         $display("%s", Hit ? "Hit" : "Miss");
       end
       // synthesis translate_on
       //==============================================================
         NextState = `STATE_READWB;
     end

     `STATE_WRITEHIT:
     begin
       if (MGrant) begin
       //==============================================================
       // synthesis translate_off
         index = TestBench.DUT_RTL.DCache.DAddress[`IINDEX];
         $display($time,, "dc_ctrl > Write Hit updated at cache Index - ", 
         "%h Tag- %h <> ValidRam- %b TagRam- %h DataRam %h%h%h%h %h%h%h%h",  
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
         if (`vbs) $display($time,, "dc_ctrl> Write Hit Granted");
       // synthesis translate_on
       //==============================================================
         NextState  = `STATE_WRITEMEM;
       end
       else begin
       //==============================================================
       // synthesis translate_off
         if (`vbs) $display($time,, "dc_ctrl> Waiting for Bus grant");
       // synthesis translate_on
       //==============================================================
         NextState = `STATE_WRITEHIT;
       end
     end

     `STATE_WRITEMISS: 
     begin
       if (MGrant) begin
       //==============================================================
       // synthesis translate_off
         if (`vbs) $display($time,, "dc_ctrl> Write Miss Granted");
       // synthesis translate_on
       //==============================================================
         NextState  = `STATE_WRITEMEM;
       end
       else begin
       //==============================================================
       // synthesis translate_off
         if (`vbs) $display($time,, "dc_ctrl> Waiting for Bus grant");
       // synthesis translate_on
       //==============================================================
         NextState = `STATE_WRITEMISS;
       end
     end

     `STATE_WRITEMEM:
     begin
       if (mSDR_TxD) begin
       //==============================================================
       // synthesis translate_off
         if (`vbs) 
           $display($time,, "dc_ctrl > Burst Write data: %h",
                             TestBench.DUT_RTL.DCache.MData);
       // synthesis translate_on
       //==============================================================
         NextState = `STATE_WRITEMEM;
         NextCount = Count + 3'b1;
       end
       else if (Count == `BURST_COUNT)
       begin
         NextState = wb_flush_once ? `STATE_READWB : 
                     wb_flush ? `STATE_IDLE : `STATE_WRITEDATA;
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
       //==============================================================
       // synthesis translate_off
       if (`vbs) $display($time, "dc_ctrl> WRITEDATA");
       // synthesis translate_on
       //==============================================================
       NextState = `STATE_IDLE;
     end
     default:
       NextState = `STATE_IDLE;
  endcase
end

assign  TagWrite         = vector[12] & RD & ~wb_qread;
assign  Miss             = vector[11];    //NEW--Added for 4-way cache 
assign  WSCLoad          = vector[10];
assign  DReadyEnable     = vector[9] & Hit;
assign  Ready            = vector[8];
assign  FillEnable       = mSDR_RxD;             // data cache rams fill
assign  CpuWrite         = vector[7] & Hit;      // cpu write cache on write hit 
assign  MStrobe          = vector[6] | wb_flush; // memory strobe
assign  MRW              = vector[5];
assign  CacheDataSelect  = mSDR_RxD; 
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

 //=========================================================================================
 // 
 // Without write buffer, valid/tag write occurs at STATE_READ for read miss.
 //
 // With write buffer, the valid/tag write occurs at STATE_READWB for cache and write buffer
 // read miss.
 //
 //=========================================================================================
 
always @ (State) begin
  case (State)
    `STATE_IDLE:      vector = `Pt_Idle;
    `STATE_READ:      vector = `Pt_DReadyEnable /*| `Pt_TagWrite */ | `Pt_DDataOE ; 
    `STATE_READMISS:  vector = `Pt_Miss  | `Pt_WSCLoad | `Pt_MStrobe | `Pt_MRW; 
    `STATE_READMEM:   vector = `Pt_Miss  | `Pt_MRW | `Pt_MAddrOE ;
    `STATE_READDATA:  vector = `Pt_Ready | `Pt_DDataOE ;

    `STATE_READWB:    vector = `Pt_TagWrite;


    `STATE_WRITE:     vector =  /* `Pt_DReadyEnable | `Pt_TagWrite |*/  `Pt_CpuWrite;
    `STATE_WRITEHIT:  vector = `Pt_WSCLoad | /*`Pt_MRW |*/ `Pt_MStrobe;
    `STATE_WRITEMISS: vector = `Pt_Miss | `Pt_WSCLoad | /*`Pt_MRW |*/ `Pt_MStrobe;
    `STATE_WRITEMEM:  vector = `Pt_Miss | `Pt_MDataOE | `Pt_MAddrOE;
    `STATE_WRITEDATA: vector = `Pt_Ready /*| `Pt_MDataOE*/; 
    default :         vector = `Pt_Idle;
  endcase
end

endmodule /* FSM control */
