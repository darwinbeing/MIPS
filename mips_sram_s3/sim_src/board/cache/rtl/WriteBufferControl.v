`include "cache.h"

//========================================================
// Generate WB control signas based on the cache states
//========================================================
module WriteBufferControl (
  input               Reset,
  input               Clk,
  input               RD,
  input               WR,
  input  [`DATASLICE] DBE,
  input      [2 : 0]  Count,
  input               Hit,
  input               mSDR_TxD,
  input               mSDR_RxD,
  input      [3 : 0]  State,

  input               wb_full     ,
  input      [3 : 0]  wb_data_valid,
  input               wb_tag_match,
  input               wb_tagval_in,

  output     [5 : 0]  wb_flush_cnt,
  output reg          MergeData,
  output reg          wb_write ,
  output reg          wb_read  ,
  output reg          wb_mem_en,
  output reg          wb_val_en,
  output reg          wb_tag_en,
  output reg          wb_tagv_en,
  output reg          wb_qread ,
  //output reg          wb_addr_sel ,
  output reg          wb_flush,
  output reg          wb_flush_once,
  output reg [3:0]    wb_mbe,
  output reg          wb_tagval_out,
  output reg          wb_valid
);

//============================== 
// 
//============================== 
reg [5:0] NextFlushCount;
reg [5:0] FlushCount;
reg       NextMergeData;
//reg       NextMAddrSelect;
//reg       MAddrSelect;
reg       wb_conflict;

//============================================================================
// Write Buffer control
//============================================================================
assign wb_flush_cnt = FlushCount;
//assign wb_addr_sel = MAddrSelect;

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
  wb_mbe        = DBE;
  wb_write      = 1'b0;
  wb_read       = 1'b0;
  wb_qread      = 1'b0;
  wb_mem_en     = 1'b0;
  wb_val_en     = 1'b0;
  wb_tag_en     = 1'b0;
  wb_tagv_en    = 1'b0;
  wb_tagval_out = 1'b0;
  wb_conflict   = 1'b0;

  case (State)
    `STATE_IDLE:
    begin
      if (wb_full || wb_flush) begin
      //=====================================================================
      // synthesis translate_off
      if (`vbs) $display($time,, "wb_ctrl > WB full");
      // synthesis translate_on
      //=====================================================================
      /*
        wb_write  = 1'b1;
        wb_tag_en = 1'b1;
        wb_tagval_out = 1'b0;  // clear tag valid
        */
      end
    end

    // For cache read miss and write, access write buffer tag
    // to check write-buffer hit 
    `STATE_READ:
    begin
      //=====================================================================
      // synthesis translate_off
      if (`vbs) begin
        if (!Hit) $display($time,, "wb_ctrl > Read WB tag on cache read miss");
      end
      // synthesis translate_on
      //=====================================================================
      wb_read     = ~Hit;
      wb_val_en   = ~Hit;
      wb_tag_en   = ~Hit;
      wb_tagv_en  = ~Hit;
    end

    `STATE_WRITE:
    begin
      //=====================================================================
      // synthesis translate_off
      if (`vbs) $display($time,, "wb_ctrl > Enable WB read on write %s",
                          Hit ? "hit" : "miss");
      // synthesis translate_on
      //=====================================================================
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
        //=====================================================================
        // synthesis translate_off
        if (`vbs) $display($time,, "wb_ctrl > WB tag invalid");
        // synthesis translate_on
        //=====================================================================
        wb_write  = WR;
        wb_val_en = WR;
        wb_tag_en = WR;
        wb_tagv_en= WR;
        wb_mem_en = WR; 
        wb_tagval_out = 1'b1;
      end

      else begin 
//--------------------------------------------------------
// tag match & tag valid
// write: write buffer write(may overwrite old contents) no sdram write
// read : 
//   if load data valid, then 
//     read write buffer bypassing sdram read
//   else 
//     sdram read and merge data with write buffer
//--------------------------------------------------------
        if (wb_tag_match) begin
          if (WR)  begin
            //=================================================================
            // synthesis translate_off
            if (`vbs) $display($time,, "wb_ctrl > WB write on tag match & valid");
            // synthesis translate_on
            //=================================================================
            wb_write  = 1'b1;
            wb_val_en = 1'b1;
            wb_mem_en = 1'b1;
          end

          if (RD) begin
            if (wb_valid) begin 
            //=================================================================
            // synthesis translate_off
            if (`vbs) $display($time,, "wb_ctrl > WB read on tag match & valid");
            // synthesis translate_on
            //=================================================================
            // bypass SDRAM read and no cache fill
              wb_qread  = 1'b1; 
              wb_read   = 1'b1;
              //wb_val_en = 1'b1;
              wb_mem_en = 1'b1;
            end
          end
        end

//--------------------------------------------------------
// tag mismatch & tag valid
// write: sdram write, then write buffer write
// read : sdram read (of course no flush ??)
//--------------------------------------------------------
        else begin // tag mismatch
          //=================================================================
          // synthesis translate_off
          if (`vbs) $display($time,, "wb_ctrl > WB tag mismatch & valid");
          // synthesis translate_on
          //=================================================================
          //if (WR) 
          wb_conflict = 1'b1;
        end
      end
    end

     `STATE_WRITEMEM:
     begin
       wb_read   = 1'b1;       // enable ram data read
       wb_mem_en = 1'b1;
       wb_mbe    = wb_data_valid;

       if (Count == `BURST_COUNT) begin
         wb_read   = 1'b0;     // done with ram read
         wb_val_en = 1'b1;     // enable clear ram valids
         //wb_tag_en = 1'b1;
         wb_tagv_en= 1'b1;
         wb_tagval_out = 1'b0;  
         wb_write  = 1'b1;     // clear tag valid
       end
     end

     `STATE_READMEM:
     begin
       if (mSDR_RxD)
       begin
         wb_read = 1'b1;
         wb_mem_en = 1'b1; 
         wb_mbe    = {4{MergeData}};
       end
     end
    default:;
  endcase
end

always @ (posedge Clk) begin
  if (Reset)
  begin
    FlushCount <= 6'b0;
    MergeData  <= 1'b0;
  end
  else begin
    FlushCount <= NextFlushCount;
    MergeData  <= NextMergeData;
  end
end

always @ (posedge Clk) begin
  if (Reset) begin
    wb_flush <= 1'b0;
    wb_flush_once <= 1'b0;
  end
  else if (wb_full || wb_conflict) begin
    wb_flush <= 1'b1;
    wb_flush_once <= wb_conflict;
  end
  else begin
    if (wb_flush && !wb_flush_once && 
        FlushCount == 6'b0 && Count == `BURST_COUNT)
      wb_flush <= 1'b0;

    if (wb_flush && wb_flush_once && Count == `BURST_COUNT) begin
      wb_flush      <= 1'b0;
      wb_flush_once <= 1'b0;
    end
  end
end

always @ (*) begin

  NextFlushCount = FlushCount;
  NextMergeData  = MergeData;

  case (State)
    `STATE_IDLE:
     begin
       if (wb_full || wb_flush) begin
         if (wb_full) NextFlushCount = 6'b011_000;
       end
     end

     `STATE_READWB:
     begin
       // valid and match tag and invalid data
       if (RD && wb_tagval_in && wb_tag_match && !wb_valid) begin
         NextMergeData  = 1'b1;
       end

       // flush write-buffer entry for valid and unmatch tag
       if (wb_tagval_in && ~wb_tag_match) begin
         NextFlushCount = 6'b100_000;
       end
     end

     `STATE_READDATA:
     begin
       NextMergeData  = 1'b0;
     end

     `STATE_WRITEMEM:
     begin
       if (wb_flush && Count == `BURST_COUNT) begin
         if (wb_flush_once)
           NextFlushCount = 6'b0; // though we can skip clearing
         else 
           NextFlushCount = FlushCount - 6'b001_000;
       end
     end

     default:;
  endcase
end

endmodule 
