`include "MIPS1000_defines.v"
module PPS_Execute
(
  EX_MUXop0_in,
  EX_MUXop1_in,
  EX_MUXop2_in,
  EX_inst_rd_in, 
  EX_aluop_in,
  EX_RegWrite_in,
  EX_memop_in,
  EX_memop_type_in,
  EX_memwr_in,

  EX_ALUOut_out,
  EX_STData_out,
  EX_inst_rd_out, 
  EX_memop_out,
  EX_memop_type_out,
  EX_memwr_out,
  EX_RegWrite_out,
  EX_bflag_out
);

parameter 
          ALU_OP_SIZE = `ALU_CTRL_WIDTH,
          MEM_OP_SIZE = 1,
          MEM_WR_SIZE = 1,
          MEM_OP_TYPE_SIZE = 7,
          OFS_TYPE_SIZE = 2,
          EXE_TYPE_SIZE = 5,
          REG_TYPE_SIZE = 1,
          USE_REG1_SIZE = 1,
          USE_REG2_SIZE = 1,
          IMM1_SEL_SIZE = 1,
          IMM2_SEL_SIZE = 1,
          IMM_EXT_SIZE = 1,
          DATA_AVA_SIZE = 2,
          RWE_SIZE = 1,
          BANK_DES_SIZE = 1,
          DST_ADDR_SEL_SIZE = 2;

input [4:0] EX_inst_rd_in; 
input [RWE_SIZE - 1 : 0] EX_RegWrite_in;
input [ALU_OP_SIZE - 1 : 0] EX_aluop_in;
input [MEM_OP_SIZE - 1 : 0] EX_memop_in; 
input [MEM_WR_SIZE - 1 : 0] EX_memwr_in; 
input [MEM_OP_TYPE_SIZE - 1 : 0] EX_memop_type_in;
input [31:0] EX_MUXop0_in;
input [31:0] EX_MUXop1_in;
input [31:0] EX_MUXop2_in;

output  [31:0] EX_ALUOut_out;
output  [31:0] EX_STData_out;
output  [4:0] EX_inst_rd_out; 
output  [MEM_OP_SIZE - 1 : 0]  EX_memop_out;
output  [MEM_OP_TYPE_SIZE - 1 : 0]  EX_memop_type_out;
output  [MEM_WR_SIZE - 1 : 0] EX_memwr_out;
output  EX_RegWrite_out;
output  EX_bflag_out;

wire [31:0] EX_ALUOut;
wire [MEM_OP_SIZE - 1 : 0] EX_memop_out;
wire [MEM_WR_SIZE - 1 : 0] EX_memwr_out;
wire [MEM_OP_TYPE_SIZE - 1 : 0] EX_memop_type_out;

wire overflow;

// Instantiate ALU
ALU ALU 
(
	.op1  (EX_MUXop1_in),
  .op2  (EX_MUXop2_in), 
	.ctrl (EX_aluop_in),
	.res  (EX_ALUOut),
  .bflag(EX_bflag_out),
	.overflow(overflow)
);

//assign EX_Load_inst_out = EX_memop_in & ~EX_memwr_in;
assign EX_ALUOut_out = EX_ALUOut;
assign EX_inst_rd_out = EX_inst_rd_in;
assign EX_RegWrite_out = EX_RegWrite_in;

assign EX_memop_out = EX_memop_in;
assign EX_memwr_out = EX_memwr_in;
assign EX_memop_type_out = EX_memop_type_in;
assign EX_STData_out = EX_MUXop0_in;

endmodule

