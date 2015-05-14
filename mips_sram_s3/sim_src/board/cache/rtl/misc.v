//
// Miscellaneous Building Blocks: Comparator, DataMux
//
`include "cache.h"

module Comparator (Tag1, Tag2, Match);
parameter TAG = `DTAGSIZE;
input   [TAG-1 : 0]  Tag1;
input   [TAG-1 : 0]  Tag2;
output               Match;

wire            Match = Tag1 == Tag2;  


//always @ (Tag1 or Tag2) begin
//   #1 $display($time, " Tag1 %d   Tag2 %d   Match %b", Tag1, Tag2, Match);
//end
endmodule /* Comparator */   


module DataMux (S, A, B, Z);
parameter DATAWIDTH = `DATAWIDTH;
input                     S;      // Select line
input   [DATAWIDTH-1 : 0] A;      // A input bus
input   [DATAWIDTH-1 : 0] B;      // B input bus
output  [DATAWIDTH-1 : 0] Z;      // output bus

wire    [DATAWIDTH-1 : 0] Z = S ? A : B;

endmodule /* DataMux */

module DataMux4 (S, A, B, C, D, Z);
parameter DATAWIDTH = `DATAWIDTH;
input   [1 : 0]           S;      // Select line
input   [DATAWIDTH-1 : 0] A;      // A input bus
input   [DATAWIDTH-1 : 0] B;      // B input bus
input   [DATAWIDTH-1 : 0] C;      // B input bus
input   [DATAWIDTH-1 : 0] D;      // B input bus
output  [DATAWIDTH-1 : 0] Z;      // output bus
reg     [DATAWIDTH-1 : 0] Z;      // output bus

always @ (S, A, B, C, D) begin
 case (S)
   2'b00: Z = A;
   2'b01: Z = B;
   2'b10: Z = C;
   2'b11: Z = D;
 endcase
end

endmodule /* DataMux */
