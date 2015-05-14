`include "MIPS1000_defines.v"
module PPS_Execute #(
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
          DST_ADDR_SEL_SIZE = 2)
(
  input       clk,
  input data_ready,
  input inst_ready,
  input data_read,
  input data_write,
  input [4:0] EX_inst_rd_in, 
  input [RWE_SIZE - 1 : 0] EX_RegWrite_in,
  input [ALU_OP_SIZE - 1 : 0] EX_aluop_in,
  input [MEM_OP_SIZE - 1 : 0] EX_memop_in, 
  input [MEM_WR_SIZE - 1 : 0] EX_memwr_in, 
  input [MEM_OP_TYPE_SIZE - 1 : 0] EX_memop_type_in,
  input [31:0] EX_MUXop0_in,
  input [31:0] EX_MUXop1_in,
  input [31:0] EX_MUXop2_in,
  input [31:0] EX_LDData_in,
  
  // Memory Read
  output reg [31:0] EX_ALUOut_out,
  output reg [4:0] EX_inst_rd_out, 
  output reg [MEM_OP_TYPE_SIZE - 1 : 0]  EX_memop_type_out,
  output reg [MEM_OP_SIZE - 1 : 0]  EX_memop_out,
  output reg EX_RegWrite_out,
  output reg [31:0] EX_LDData_out,
  
  output [31:0] EX_Addr_out,
  output [31:0] EX_STData_out,
  output  [3:0] EX_bwe_out,
  output [MEM_WR_SIZE - 1 : 0] EX_memwr_out,
  output      EX_bflag_out 
);

wire [31:0] EX_ALUOut;
wire [31:0] EX_STData_in;
wire        mem_write;
wire        overflow;
wire        PipeReg_en;

reg [31:0] EX_STData_inter;
reg  [3:0] EX_bwe_inter;

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

assign PipeReg_en = (data_read | data_write) ? data_ready : inst_ready;

always @ (posedge clk) begin
  if (PipeReg_en) begin
    EX_inst_rd_out    <= EX_inst_rd_in;
    EX_RegWrite_out   <= EX_RegWrite_in;
    EX_ALUOut_out     <= EX_ALUOut;        // arith result
    EX_memop_type_out <= EX_memop_type_in;
    EX_memop_out      <= EX_memop_in;
    EX_LDData_out     <= EX_LDData_in;
  end
  else if (!(data_read || data_write))begin
    // insert bubbles
    EX_RegWrite_out   <= 1'b0;
    EX_memop_out      <= 1'b0;
  end
end

// Memory read/write address
assign EX_Addr_out = EX_ALUOut;

// Memory write data
assign EX_STData_in  = EX_MUXop0_in;
assign EX_STData_out = EX_STData_inter;

// Memory write enable
assign  EX_memwr_out = EX_memwr_in;

/************************************************
    Data Alignment Unit 
 ***********************************************/
assign mem_write  = EX_memop_in & EX_memwr_in;
//assign EX_bwe_out = {4{mem_write}} & EX_bwe_inter;
assign EX_bwe_out = EX_bwe_inter;  /* write-buffer added */

always @ (EX_ALUOut[1:0],  EX_memop_type_in)
begin
  case (EX_memop_type_in)
    `tMEM_OP_NULL,
    `tMEM_OP_WORD:
    begin
      EX_bwe_inter = 4'b1111;
    end
    
    `tMEM_OP_HWORD:
    // sh
    begin
      case (EX_ALUOut[1])
        1'b1: EX_bwe_inter = 4'b1100;
        1'b0: EX_bwe_inter = 4'b0011;
      endcase
    end

    `tMEM_OP_BYTE:
    // sb
    begin
      case (EX_ALUOut[1:0])
        2'b11: EX_bwe_inter = 4'b1000; 
        2'b10: EX_bwe_inter = 4'b0100;
        2'b01: EX_bwe_inter = 4'b0010;
        2'b00: EX_bwe_inter = 4'b0001;
      endcase
    end

    default:
    begin
      EX_bwe_inter = 4'b0000;
    end
  endcase
end

// Memory write data alignment
always @ (EX_ALUOut[1:0],  EX_memop_type_in, EX_STData_in)
begin
  case (EX_memop_type_in)
    `tMEM_OP_NULL,
    // sw
    `tMEM_OP_WORD:
    begin
      EX_STData_inter = EX_STData_in;
    end
    
    `tMEM_OP_HWORD:
    // sh
    begin
      case (EX_ALUOut[1])
        1'b1: EX_STData_inter = EX_STData_in << 16;
        1'b0: EX_STData_inter = EX_STData_in;
      endcase
    end

    `tMEM_OP_BYTE:
    // sb
    begin
      case (EX_ALUOut[1:0])
        2'b11: EX_STData_inter = EX_STData_in << 24;
        2'b10: EX_STData_inter = EX_STData_in << 16;
        2'b01: EX_STData_inter = EX_STData_in << 8;
        2'b00: EX_STData_inter = EX_STData_in;
      endcase
    end

    default:
    begin
      EX_STData_inter = 32'hxxxx_xxxx;
    end
  endcase
end

endmodule

