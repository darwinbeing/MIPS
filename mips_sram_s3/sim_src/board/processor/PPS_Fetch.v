//`include "MIPS1000_defines.v"
module PPS_Fetch
(
  input clk,
  input rst,

  // pipeline stall
  input data_ready,
  input inst_ready,
  input data_read,
  input data_write,

  input Pstomp,
  input [31:0] bra_tgt,

  // Instruction 
  output [31:0] IF_inst_out,

  // Memory Interface
  input [31:0] IF_inst_in,

  // PC output
  output [31:0] IF_PC_out
);

// Output of PC plus 4 adder
wire [31:0] PC_plus4;

// PC register input
wire [31:0] PC_sel;

wire PC_en;

// PC register
reg [31:0] PC;

// A simple dedicated adder
assign PC_plus4 = PC + 32'd4;

// PC select
assign PC_sel = Pstomp ? bra_tgt : PC_plus4;

// PC output
assign IF_PC_out = PC;

// Instruction output 
assign IF_inst_out = IF_inst_in;

// PC update enable
assign PC_en = (data_read | data_write) ?  data_ready : inst_ready;
//assign PC_en = data_ready | ~memop & inst_ready;

always @ (posedge clk)
begin
  if (rst)
    //PC <= 32'hF000_0000; // with DMA 
    PC <= 32'h0000_0000; // without DMA raw
  else if (PC_en)
    PC <= PC_sel;
end

endmodule
    
