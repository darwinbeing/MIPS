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
  IF_addr_out,
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

// Instruction address
output [31:0] IF_addr_out;

// PC output
output [31:0] IF_PC_out;

// Output of PC plus 4 adder
wire [31:0] PC_plus4;

// PC register input
wire [31:0] PC_sel;

// PC register write enable
wire IF_PCWrite;

// PC register
reg [31:0] PC;

// Host path
//assign HS_PC = PC_sel;

// A simple dedicated adder
assign PC_plus4 = PC + 32'd4;

// 
assign IF_PCWrite = ~pcwe;

// PC select
assign PC_sel = pcwe ? PC : Pstomp ? bra_tgt : PC_plus4;
//assign PC_sel = pcwe ? PC : Pstomp ? 32'h7c : PC_plus4;

// PC output/instruction address
// PC register out -> ARAM
// PC MUX sel  out -> SRAM
assign IF_addr_out = PC_sel;

// PC output
assign IF_PC_out = PC;

// 
assign IF_inst_out = IF_inst_in;

always @ (posedge clk)
begin
  if (rst)
    PC <= 32'hFFFF_FFFC;  
  else if (IF_PCWrite)
    PC <= PC_sel;
end

endmodule
    
