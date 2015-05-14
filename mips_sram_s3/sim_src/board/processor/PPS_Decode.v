`include "MIPS1000_defines.v"
module PPS_Decode
(
  clk,
  rst,

  // pipeline stall
  data_ready,
  inst_ready,
  data_read,
  data_write,

  ID_inst_in,
  ID_PC_in, 
  EX_bflag_in,
  WB_RF_Wdata_in,
  WB_inst_rd_in,
  WB_RegWrite_in,

  ID_MUXop0_out,
  ID_MUXop1_out,
  ID_MUXop2_out,
  ID_inst_rd_out, 
  ID_aluop_out,
  ID_RegWrite_out,
  ID_memop_out,
  ID_memop_type_out,
  ID_memwr_out,
  ID_Pstomp_out,
  ID_bra_tgt_out
);

parameter BRA_TYPE_SIZE = 3,
          BRA_LNK_SIZE = 1,
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
          
input clk;
input rst;
input data_ready;
input inst_ready;
input data_read;
input data_write;
input [31:0] ID_inst_in;
input [31:0] ID_PC_in;

// Asserted high when the conditional branch is taken
input EX_bflag_in;

// Data of Forwarding paths from 
// EX, MEM and WB stages
input [31:0] WB_RF_Wdata_in;

// Register specifier for detecting hazards
// from EX, MEM and WB stages
input  [4:0]  WB_inst_rd_in; 

input WB_RegWrite_in;

output  [4:0] ID_inst_rd_out; 
output  [RWE_SIZE - 1 : 0] ID_RegWrite_out;
output  [ALU_OP_SIZE - 1 : 0] ID_aluop_out;
output  [MEM_OP_SIZE - 1 : 0] ID_memop_out; 
output  [MEM_WR_SIZE - 1 : 0] ID_memwr_out; 
output  [MEM_OP_TYPE_SIZE - 1 : 0] ID_memop_type_out;
output  [31:0] ID_MUXop0_out;
output  [31:0] ID_MUXop1_out;
output  [31:0] ID_MUXop2_out;

output ID_Pstomp_out;
output [31:0] ID_bra_tgt_out;

reg  stall_reg;
wire stall;
wire insert_bubble;

wire [31:0] ID_PC_plus4;   
wire [31:0] ID_MUXop1_out;
wire [31:0] ID_MUXop2_out;
wire [31:0] MUXop1_out;
wire [31:0] MUXop2_out;
wire [ALU_OP_SIZE - 1:0] ID_aluop_out;
wire [31:0] JMP_target;
wire [31:0] JR_target;
wire [31:0] BRA_target;
wire [MEM_OP_SIZE - 1 : 0] ID_memop_out; 
wire [MEM_WR_SIZE - 1 : 0] ID_memwr_out; 
wire [MEM_OP_TYPE_SIZE - 1 : 0] ID_memop_type_out;
wire [4:0] ID_inst_rd_out;  // select between rt and rd

wire [0:`INST_DE_WIDTH_ - 1] ID_inst_decode;
wire [31:0] ID_inst_imm31;  

// Instruction fields
wire [4:0] ID_inst_rs;
wire [4:0] ID_inst_rt;
wire [4:0] ID_inst_rd;
wire [4:0] ID_inst_sa;
wire [15:0] ID_inst_imm;
wire [25:0] ID_inst_jmp_imm;

wire [31:0] RF_Rdata1;
wire [31:0] RF_Rdata2;
wire [31:0] RF_Wdata;
wire [31:0] RF_Wd;
wire [31:0] RF_Rd1;
wire [31:0] RF_Rd2;
wire  [4:0] RF_Wa;
wire  [4:0] RF_Ra1;
wire  [4:0] RF_Ra2;
wire        RF_Ren1;
wire        RF_Ren2;
wire        RF_Wen;

wire sign;
wire [BRA_TYPE_SIZE - 1 : 0] bra_type;
wire [BRA_LNK_SIZE - 1 : 0] bra_lnk;
wire [ALU_OP_SIZE - 1: 0] alu_op;
wire [MEM_OP_SIZE - 1 : 0] mem_op; 
wire [MEM_WR_SIZE - 1 : 0] mem_wr;
wire [USE_REG1_SIZE - 1 : 0] use_reg1;
wire [USE_REG1_SIZE - 1 : 0] use_reg2;
wire [IMM1_SEL_SIZE - 1 : 0] imm1_sel;
wire [IMM2_SEL_SIZE - 1 : 0] imm2_sel;
wire [IMM_EXT_SIZE - 1 : 0] sign_imm16;
wire [MEM_OP_TYPE_SIZE - 1 : 0] mem_op_type;
wire [RWE_SIZE - 1 : 0] rwe;
wire [DST_ADDR_SEL_SIZE - 1 : 0] dst_addr_sel;

//
// Instantiate instruction decoder
//
Decoder Decoder
(
  .inst_code(ID_inst_in),
  .inst_decode(ID_inst_decode)
);

//
// Instantiate Register File
//
RegFile RegFile
(
   .clk(clk),
   .rst(rst),
   .Wen(RF_Wen),
   .Wa(RF_Wa), 
   .Wd(RF_Wd), 
   .Ren1(RF_Ren1),
   .Ra1(RF_Ra1),
   .Rd1(RF_Rd1),
   .Ren2(RF_Ren2),
   .Ra2(RF_Ra2),
   .Rd2(RF_Rd2)
);


// Register File read address
assign RF_Ra1 = ID_inst_rs;
assign RF_Ra2 = ID_inst_rt;

// Register File write address
assign RF_Wa = WB_inst_rd_in;

// Register File write data
// The data come from memory data, ALU result or next PC
assign RF_Wd = WB_RF_Wdata_in;

// Register File read/write control signals
assign RF_Wen = WB_RegWrite_in;
assign RF_Ren1 = use_reg1;
assign RF_Ren2 = use_reg2;

assign ID_inst_rs      = ID_inst_in[25:21];
assign ID_inst_rt      = ID_inst_in[20:16];
assign ID_inst_rd      = ID_inst_in[15:11];
assign ID_inst_sa      = ID_inst_in[10:6];
assign ID_inst_imm     = ID_inst_in[15:0];
assign ID_inst_jmp_imm = ID_inst_in[25:0];

// For decoding bltz, bgez, bltzal, bgezal 
//assign inst_regimm    = inst_in[20:16];

assign bra_type = ID_inst_decode[0 : BRA_TYPE_SIZE - 1];

assign bra_lnk = ID_inst_decode[BRA_TYPE_SIZE : BRA_TYPE_SIZE + BRA_LNK_SIZE - 1];

assign alu_op = ID_inst_decode[ BRA_TYPE_SIZE + BRA_LNK_SIZE :
                             BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE - 1];

assign mem_op = ID_inst_decode[BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE :
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE + MEM_OP_SIZE - 1];

assign mem_wr = ID_inst_decode[BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE : BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE - 1];

assign mem_op_type = ID_inst_decode[
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE :
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE - 1];

assign use_reg1 = ID_inst_decode[
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE :
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE - 1];

assign use_reg2 = ID_inst_decode[
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE :
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE + USE_REG2_SIZE - 1];

assign imm1_sel = ID_inst_decode[
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE + USE_REG2_SIZE :
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE + USE_REG2_SIZE 
              + IMM1_SEL_SIZE - 1];

assign imm2_sel = ID_inst_decode[
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE + USE_REG2_SIZE 
              + IMM1_SEL_SIZE:
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE + USE_REG2_SIZE
              + IMM1_SEL_SIZE + IMM2_SEL_SIZE - 1];

assign sign_imm16 = ID_inst_decode[
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE + USE_REG2_SIZE 
              + IMM1_SEL_SIZE + IMM2_SEL_SIZE:
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE + USE_REG1_SIZE
              + IMM1_SEL_SIZE + IMM2_SEL_SIZE + IMM_EXT_SIZE - 1];

assign rwe = ID_inst_decode[
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE + USE_REG2_SIZE 
              + IMM1_SEL_SIZE + IMM2_SEL_SIZE + IMM_EXT_SIZE + DATA_AVA_SIZE:
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE + USE_REG1_SIZE
              + IMM1_SEL_SIZE + IMM2_SEL_SIZE + IMM_EXT_SIZE + DATA_AVA_SIZE
              + RWE_SIZE - 1];

assign dst_addr_sel = ID_inst_decode[
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE + USE_REG2_SIZE 
              + IMM1_SEL_SIZE + IMM2_SEL_SIZE + IMM_EXT_SIZE + DATA_AVA_SIZE
              + RWE_SIZE + BANK_DES_SIZE :
              BRA_TYPE_SIZE + BRA_LNK_SIZE + ALU_OP_SIZE 
              + MEM_OP_SIZE + MEM_WR_SIZE + MEM_OP_TYPE_SIZE + EXE_TYPE_SIZE
              + 2 * REG_TYPE_SIZE + USE_REG1_SIZE + USE_REG1_SIZE
              + IMM1_SEL_SIZE + IMM2_SEL_SIZE + IMM_EXT_SIZE + DATA_AVA_SIZE
              + RWE_SIZE + BANK_DES_SIZE + DST_ADDR_SEL_SIZE - 1]; 

            
// Branch target selected by PCSource
assign ID_PC_plus4 = ID_PC_in + 32'd4;
assign JR_target   = RF_Rd1;
assign BRA_target  = ID_PC_plus4 + {{14{ID_inst_imm[15]}}, ID_inst_imm[15:0], 2'b00};
assign JMP_target  = { ID_PC_plus4[31:28], ID_inst_jmp_imm[25:0], 2'b00 };

assign ID_bra_tgt_out = bra_type[0] ? BRA_target : 
                        bra_type[1] ?  JR_target : 
                        bra_type[2] ? JMP_target : 32'b0;

// Immediate operand select
assign sign = sign_imm16 & ID_inst_imm[15];
assign ID_inst_imm31  = {{16{sign}}, ID_inst_imm[15:0]};

// ALU source multiplexors
assign ID_MUXop0_out = RF_Rd2;
assign ID_MUXop1_out = imm1_sel ? {27'b0, ID_inst_sa} : RF_Rd1;
assign ID_MUXop2_out = (imm2_sel | mem_op) ? ID_inst_imm31 : bra_lnk ? ID_PC_plus4 : RF_Rd2;


// Destination register identifier multiplexors
assign ID_inst_rd_out = (dst_addr_sel == `tD_RT) ? ID_inst_rt :
                        (dst_addr_sel == `tD_RD) ? ID_inst_rd :
                        (dst_addr_sel == `tD_31) ? `R31 : `R0;

assign ID_aluop_out      = alu_op; 

//assign ID_memwr_out      = ~((ID_inst_imm[15:0] & 16'hfff0) == 16'hfff0) & mem_wr;  // memory-mapped IO 
assign ID_memop_type_out = mem_op_type;
assign ID_memwr_out      = mem_wr;

assign ID_Pstomp_out     = ~stall_reg & 
                           (bra_type[1] | bra_type[2] | bra_type[0] & EX_bflag_in);
assign ID_memop_out      = ~stall_reg & mem_op;
assign ID_RegWrite_out   = ~(rst | stall_reg) & rwe;

// Reset control - Dr. Bakos
always @ (posedge clk) begin
  if (rst)
    stall_reg <= 1'b0;
  else
    stall_reg <= stall;
end

assign stall = rst | ID_Pstomp_out;

endmodule
