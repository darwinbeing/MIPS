//`include "MIPS1000_defines.v"
module PPS_Fetch
(
  clk,
  rst,
  Pstomp,
  bra_tgt,
  
  // PC write enable
  pcwe,

  // Memory Interface
  IF_inst_in,
  IF_PC_out,
  IF_inst_out
);

input clk;
input rst;
input Pstomp;
input [31:0] bra_tgt;
input pcwe;

// Host Path
//output [31:0] HS_PC;

// Instruction 
output [31:0] IF_inst_out;

// Memory Interface
input [31:0] IF_inst_in;

// PC output
output [31:0] IF_PC_out;

// Output of PC plus 4 adder
wire [31:0] PC_plus4;

// PC register input
wire [31:0] PC_sel;

// PC register write enable
//wire IF_PCWrite;

// PC register
reg [31:0] PC;

// A simple dedicated adder
assign PC_plus4 = PC + 32'd4;

// 
//assign IF_PCWrite = ~pcwe;

// PC select
assign PC_sel = Pstomp ? bra_tgt : PC_plus4;

// PC output
assign IF_PC_out = PC;

// 
assign IF_inst_out = IF_inst_in;

always @ (posedge clk)
begin
  if (rst)
    PC <= 32'h0;
  else //if (IF_PCWrite)
    PC <= PC_sel;
end

endmodule
    
