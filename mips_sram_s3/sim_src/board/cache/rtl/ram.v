//
// Ram Modules: TagRam, ValidRam, DataRam
// 
// Modification: The memory is read at the positive clock edge and 
//               written at the negative clock edge
//
// For debugging purpose, change posedge --> posedge 
`include "cache.h"


module TagRam (Address, TagIn, TagOut, Write, Reset, Clk);
parameter CACHESIZE = `DCACHESIZE;
parameter INDEX     = `DC_INDEXSIZE;
parameter TAG       = `DTAGSIZE;
input   [INDEX - 1 : 0] Address;
input       [TAG-1 : 0] TagIn;
output      [TAG-1 : 0] TagOut;
input                   Write;
input                   Reset;
input                   Clk;

reg     [TAG-1 : 0]  TagOut;
reg     [TAG-1 : 0]  TagRam [0:CACHESIZE-1];

integer i;

always @ (posedge Clk)          // Write
   if (Write) begin
//      $display($time, " TagRam> store addr %d  tag %d", Address, TagIn);
      TagRam[Address] <= TagIn;
   end
   else if (Reset)                      // Resegg
      for (i=0; i<CACHESIZE; i=i+1)
         TagRam[i] <= {TAG{1'b0}};

always @ (posedge Clk) begin    // Read
   TagOut <= TagRam[Address];
//   $display($time, " TagRam> tag of %d = %d", Address, TagOut);
end
endmodule /* TagRam */


module ValidRam (Address, ValidIn, ValidOut, Write, Reset, Clk);

parameter CACHESIZE = `DCACHESIZE;
parameter INDEX     = `DC_INDEXSIZE;
input   [INDEX - 1 : 0] Address;
input                   ValidIn;
output                  ValidOut;
input                   Write;
input                   Reset;
input                   Clk;

reg                     ValidOut;
reg                     ValidBits [0:CACHESIZE-1];

integer i;

always @ (posedge Clk)          // Write or Reset
   if (Write && !Reset) begin           // Write
//      $display($time, " ValidRam> write valid bit (%b) of %d", ValidIn, Address);
      ValidBits[Address] <= ValidIn;
   end
   else if (Reset)                      // Resegg
      for (i = 0; i < CACHESIZE; i = i + 1)
         ValidBits[i] <= `ABSENT;

always @ (posedge Clk) begin    // Read
   ValidOut <= ValidBits[Address];
//   $display($time, " ValidRam> valid bit of %d = %d", Address, ValidOut);
end

endmodule /* ValidRam */



module DataRam (Address, DataIn, DataOut, Write, Clk);
parameter CACHESIZE = `DCACHESIZE;
parameter INDEX = `DC_INDEXSIZE;
input   [INDEX - 1 : 0] Address;
input   [`BYTE]         DataIn;
output  [`BYTE]         DataOut;
input                   Write;
input                   Clk;

reg     [`BYTE]         DataOut;
reg     [`BYTE]         DataRam[0 : CACHESIZE-1];

  function [7:0] check;
    input [INDEX - 1 : 0] Wa;
    input [7:0] Wd;
    integer i;
    $display($time,, "RTL: checking DC write data %h", Wd);
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

always @ (posedge Clk) begin
   if (Write) begin             // Write
//      $display($time, " DataRam> write %d to %d", DataIn, Address);
      DataRam[Address] <= check(Address, DataIn);
   end
end

always @ (posedge Clk)          // Read
   DataOut <= DataRam[Address];

endmodule /* DataRam */

