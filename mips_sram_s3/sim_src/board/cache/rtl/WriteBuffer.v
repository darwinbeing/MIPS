`include "MIPS1000_defines.v"
`include "cache.h"

//-----------------------------------------------------------
// 4-entry 1-bit wide write buffer validbits
//-----------------------------------------------------------
module wb_val_B1 (
  input clk,
  input rst,
  input en,
  input write,
  input read,
  input [1:0] addr,
  output  sfull,  // special signal
  input   valid_in,
  output  valid_out
);

  reg wb_val[0 : 3];

  always @ (posedge clk) begin
    if (rst) begin
      wb_val[0] <= 1'b0;
      wb_val[1] <= 1'b0;
      wb_val[2] <= 1'b0;
      wb_val[3] <= 1'b0;
    end
    else if (en & write) begin
      wb_val[addr] <= valid_in;
    end
  end

  //assign valid_out = en & read ? wb_val[addr] : 1'b0;
  assign valid_out = wb_val[addr];
  assign sfull = (wb_val[0] & wb_val[1] & wb_val[2] & wb_val[3]);

endmodule 


module wb_tagval_B1 (
  input clk,
  input rst,
  input en,
  input write,
  input read,
  input [1:0] addr,
  input   valid_in,
  output  valid_out
);

  reg wb_val[0 : 3];

  always @ (posedge clk) begin
    if (rst) begin
      wb_val[0] <= 1'b0;
      wb_val[1] <= 1'b0;
      wb_val[2] <= 1'b0;
      wb_val[3] <= 1'b0;
    end
    else if (en & write) begin
      wb_val[addr] <= valid_in;
    end
  end

  assign valid_out = wb_val[addr];

endmodule 



//-----------------------------------------------------------
// 4-entry 27-bit wide write buffer tag
//-----------------------------------------------------------
module wb_tag_B27 (
  input         clk,
  input         rst,
  input         en,
  input         write,
  input         read,
  input  [1:0]  addr,
  input  [26:0] tag_in,
  output [26:0] tag_out
);

reg [31 : 2+1+2] wb_tag [0 : 3];

always @ (posedge clk) begin
  if (rst) begin
    wb_tag[0] <= 27'b0;
    wb_tag[1] <= 27'b0;
    wb_tag[2] <= 27'b0;
    wb_tag[3] <= 27'b0;
  end
  else if (en & write) begin
    wb_tag[addr] <= tag_in;
  end
end

//assign tag_out = en & read ? wb_tag[addr] : 27'hz;
assign tag_out = wb_tag[addr];

endmodule 

//-------------------------------------------
// 4-entry 8-bit wide ram
//-------------------------------------------
module wb_mem_B8 (
  input clk,
  input en,
  input write,
  input read,
  input [1:0] addr,
  inout [7:0] data
);

  reg [7 : 0] wb_mem [0 : 3];

// synthesis translate_off
  function [7:0] check;
    input [1:0] Wa;
    input [7:0] Wd;
    integer i;
    $display($time,, "RTL: checking WB write data %h", Wd);
    if (Wd === 8'bx || Wd === 8'bz) begin
      if (Wd === 8'bx)
        $display($time,, "Warning: write data at entry %d is X", Wa);
      else begin
        $display($time,, "Error: write data at entry %d is Z", Wa);
      	$stop;
      end
    end
    check = Wd;
  endfunction
// synthesis translate_on

  always @ (posedge clk) begin
    if (en & write) begin
      //wb_mem[addr] <= check(addr, data);
      wb_mem[addr] <= data;
    end
  end

  assign data = (read & en) ? wb_mem[addr] : 8'hz;

endmodule 

//-----------------------------------------------------------
// top-level write-buffer
//-----------------------------------------------------------
module WriteBuffer (
  input         clk,
  input         rst,
  input         ten,
  input         tven,
  input         ven,
  input         men,
  input         wb_read,
  input         wb_write,
  input         wb_flush,
  input  [3:0]  wb_mbe,
  input  [31:0] wb_addr,
  output        wb_full,
  output [31:0] wb_mem_addr,
  input         wb_tagval_in,
  output        wb_tagval_out,
  output        wb_tag_match,
  inout  [31:0] wb_data,
  output  [3:0] wb_data_valid
);

//wire [7:0]  valid;
wire [7:0]  valid_in, valid_out;
wire [7:0]  read, write;
wire [7:0]  mem_write, val_write;
wire [7:0]  pattern;
wire [8:0]  sfull;
wire [26:0] wb_tag_in, wb_tag_out;
wire       word_sel;
wire       wdata_sel;
wire [1:0] line_sel;
wire [31:0] wb_data0, wb_data1;
integer i;


//======================================================
// WB internal datapath and control path
//======================================================

// write buffer line select
assign line_sel = wb_addr[4:3];

// write buffer upper/lower ram word select
assign word_sel = wb_addr[2];

// all the 1-bit validbit are valid
assign wb_full  = & sfull[7:0]; 

// read tag match
assign wb_tag_match = (wb_tag_out == wb_addr[31 : 2+1+2]);

// write tag
assign wb_tag_in = wb_addr[31: 2+1+2];

// write/read or data valid pattern
assign pattern = word_sel ? {wb_mbe, 4'b0} : {4'b0, wb_mbe};

// 8-bit read/write vector
assign read      = {8{wb_read}} & pattern;

assign mem_write = wb_flush ? 8'b0 : {8{wb_write}} & pattern;
assign val_write = wb_flush ? 8'hff : {8{wb_write}} & pattern;
assign wdata_sel = ~wb_flush & wb_write & men;

// conflict writeback address
//assign wb_mem_addr = wb_flush ? {wb_tag_out, wb_addr[4:3], 3'b0} : 32'hz;
assign wb_mem_addr = wb_flush ? {wb_tag_out, wb_addr[4:3], 3'b0} : 32'h0;

// data read/write
assign wb_data  = wb_read ? (word_sel ? wb_data1 : wb_data0) : 32'hz;
assign wb_data1 = wdata_sel ? wb_data : 32'hz;
assign wb_data0 = wdata_sel ? wb_data : 32'hz;

// valid read/write
assign wb_data_valid = word_sel ? valid_out[7:4] : valid_out[3:0];
assign valid_in = wb_flush ? 8'b0 : pattern;

//======================================================
// WB RAMS
//======================================================

// write buffer byte ram
wb_mem_B8 wb_m7 (clk, men, mem_write[7], read[7], line_sel, wb_data1[31 : 24]);
wb_mem_B8 wb_m6 (clk, men, mem_write[6], read[6], line_sel, wb_data1[23 : 16]);
wb_mem_B8 wb_m5 (clk, men, mem_write[5], read[5], line_sel, wb_data1[15 : 8] );
wb_mem_B8 wb_m4 (clk, men, mem_write[4], read[4], line_sel, wb_data1[ 7 : 0] );
wb_mem_B8 wb_m3 (clk, men, mem_write[3], read[3], line_sel, wb_data0[31 : 24]);
wb_mem_B8 wb_m2 (clk, men, mem_write[2], read[2], line_sel, wb_data0[23 : 16]);
wb_mem_B8 wb_m1 (clk, men, mem_write[1], read[1], line_sel, wb_data0[15 : 8] );
wb_mem_B8 wb_m0 (clk, men, mem_write[0], read[0], line_sel, wb_data0[ 7 : 0] ); 

// write buffer tag 
wb_tag_B27 wb_t  (clk, rst, ten, wb_write, wb_read, line_sel, wb_tag_in, wb_tag_out);

// write buffer tag valid
wb_tagval_B1  wb_tv (clk, rst, tven, wb_write, wb_read, line_sel, wb_tagval_in, wb_tagval_out);

// write buffer byte ram valid
wb_val_B1 wb_v7 (clk, rst, ven, val_write[7], read[7], line_sel, sfull[7], valid_in[7], valid_out[7]);
wb_val_B1 wb_v6 (clk, rst, ven, val_write[6], read[6], line_sel, sfull[6], valid_in[6], valid_out[6]);
wb_val_B1 wb_v5 (clk, rst, ven, val_write[5], read[5], line_sel, sfull[5], valid_in[5], valid_out[5]);
wb_val_B1 wb_v4 (clk, rst, ven, val_write[4], read[4], line_sel, sfull[4], valid_in[4], valid_out[4]);
wb_val_B1 wb_v3 (clk, rst, ven, val_write[3], read[3], line_sel, sfull[3], valid_in[3], valid_out[3]);
wb_val_B1 wb_v2 (clk, rst, ven, val_write[2], read[2], line_sel, sfull[2], valid_in[2], valid_out[2]);
wb_val_B1 wb_v1 (clk, rst, ven, val_write[1], read[1], line_sel, sfull[1], valid_in[1], valid_out[1]);
wb_val_B1 wb_v0 (clk, rst, ven, val_write[0], read[0], line_sel, sfull[0], valid_in[0], valid_out[0]);


// synthesis translate_off
//======================================================
// WB debug
//======================================================
always @ (posedge clk)
  if (| write) begin
    $display("write buffer write: entry %d tagval = %b tag = %h ", 
            line_sel, wb_tagval_in, wb_tag_in);
    $display("data = %b-%h %b-%h %b-%h %b-%h %b-%h %b-%h %b-%h %b-%h", 
      valid_in[7], wb_data1[31:24], 
      valid_in[6], wb_data1[23:16],
      valid_in[5], wb_data1[15:8],
      valid_in[4], wb_data1[7:0],
      valid_in[3], wb_data0[31:24], 
      valid_in[2], wb_data0[23:16],
      valid_in[1], wb_data0[15:8],
      valid_in[0], wb_data0[7:0]);
  end

always @ (negedge clk)
  if (| write && (men || ten || ven)) begin
    #20;
    $display("--------------------------------------------------------------------");
    $display("RTL write buffer contents: ");
    for (i = 0; i < 4; i = i + 1) begin
      $display("%b-%h -- %b-%h %b-%h %b-%h %b-%h %b-%h %b-%h %b-%h %b-%h", 
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_tv.wb_val[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_t.wb_tag[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_v7.wb_val[i], 
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_m7.wb_mem[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_v6.wb_val[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_m6.wb_mem[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_v5.wb_val[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_m5.wb_mem[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_v4.wb_val[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_m4.wb_mem[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_v3.wb_val[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_m3.wb_mem[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_v2.wb_val[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_m2.wb_mem[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_v1.wb_val[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_m1.wb_mem[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_v0.wb_val[i],
      TestBench.DUT_RTL.DCache.WriteBuffer.wb_m0.wb_mem[i]);
    end
    $display("--------------------------------------------------------------------");
  end
// synthesis translate_on

endmodule 


