`include "MIPS1000_defines.v"
module PPS_Memory
(
  MEM_inst_rd_in, 
  MEM_RegWrite_in,
  MEM_memop_in,
  MEM_memop_type_in,
  MEM_memwr_in,
  MEM_ALUOut_in,
  MEM_STData_in,

  // Memory Interface
  MEM_Addr_in,  
  MEM_LDData_in,
  MEM_STData_out,
  MEM_Addr_out,
  MEM_memwr_out,
  MEM_memop_out,
  MEM_bwe_out,
  
  MEM_MUXOut_out,
  MEM_inst_rd_out, 
  MEM_RegWrite_out
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

input [31:0] MEM_ALUOut_in;
input [31:0] MEM_STData_in;
input  [4:0] MEM_inst_rd_in;
input [RWE_SIZE - 1 : 0] MEM_RegWrite_in;
input [MEM_OP_SIZE - 1 : 0] MEM_memop_in; 
input [MEM_WR_SIZE - 1 : 0] MEM_memwr_in; 
input [MEM_OP_TYPE_SIZE - 1 : 0] MEM_memop_type_in;  

// Memory interface
input [31:0] MEM_LDData_in;
input [31:0] MEM_Addr_in; 

output [31:0] MEM_MUXOut_out;
output [31:0] MEM_STData_out;
output [31:0] MEM_Addr_out;
output [MEM_WR_SIZE-1:0]MEM_memwr_out;
output [MEM_OP_SIZE-1:0]MEM_memop_out;
output [4:0] MEM_inst_rd_out; 
output  [3:0] MEM_bwe_out;
output MEM_RegWrite_out;

wire mem_write;

// Outputs of Data Alignemtn unit
reg [31:0] MEM_LDData_inter;
reg [31:0] MEM_STData_inter;
reg  [3:0] MEM_bwe_inter;

// Memory Interface
assign MEM_STData_out = MEM_STData_inter;
assign MEM_Addr_out = MEM_Addr_in; 
assign MEM_memwr_out = MEM_memwr_in;
assign MEM_memop_out = MEM_memop_in;

// 
assign MEM_MUXOut_out = MEM_memop_in ? MEM_LDData_inter: MEM_ALUOut_in;
assign MEM_inst_rd_out = MEM_inst_rd_in;
assign MEM_RegWrite_out = MEM_RegWrite_in;

/***********************************************************
    Data Alignment Unit 
 ***********************************************************/
 
// Memory write data enable
always @ (MEM_Addr_in[1:0],  MEM_memop_type_in)
begin
  case (MEM_memop_type_in)
    `tMEM_OP_NULL,
    `tMEM_OP_WORD:
    begin
      MEM_bwe_inter = 4'b1111;
    end
    
    `tMEM_OP_HWORD:
    // sh
    begin
      case (MEM_Addr_in[1])
        1'b1: MEM_bwe_inter = 4'b1100;
        1'b0: MEM_bwe_inter = 4'b0011;
      endcase
    end

    `tMEM_OP_BYTE:
    // sb
    begin
      case (MEM_Addr_in[1:0])
        2'b11: MEM_bwe_inter = 4'b1000; 
        2'b10: MEM_bwe_inter = 4'b0100;
        2'b01: MEM_bwe_inter = 4'b0010;
        2'b00: MEM_bwe_inter = 4'b0001;
      endcase
    end

    default:
    begin
      MEM_bwe_inter = 4'b0000;
    end
  endcase
end

assign mem_write = MEM_memop_in & MEM_memwr_in;
assign MEM_bwe_out = {4{mem_write}} & MEM_bwe_inter;


// Memory write data alignment
always @ (MEM_Addr_in[1:0],  MEM_memop_type_in, MEM_STData_in)
begin
  case (MEM_memop_type_in)
    `tMEM_OP_NULL,
    // sw
    `tMEM_OP_WORD:
    begin
      MEM_STData_inter = MEM_STData_in;
    end
    
    `tMEM_OP_HWORD:
    // sh
    begin
      case (MEM_Addr_in[1])
        1'b1: MEM_STData_inter = MEM_STData_in << 16;
        1'b0: MEM_STData_inter = MEM_STData_in;
      endcase
    end

    
    `tMEM_OP_BYTE:
    // sb
    begin
      case (MEM_Addr_in[1:0])
        2'b11: MEM_STData_inter = MEM_STData_in << 24;
        2'b10: MEM_STData_inter = MEM_STData_in << 16;
        2'b01: MEM_STData_inter = MEM_STData_in << 8;
        2'b00: MEM_STData_inter = MEM_STData_in;
      endcase
    end

    default:
    begin
      MEM_STData_inter = 32'hxxxx_xxxx;
    end
  endcase
end

// Memory read data alignment
always @ (MEM_Addr_in[1:0], MEM_memop_type_in, MEM_LDData_in)
  begin
    case (MEM_memop_type_in)
      `tMEM_OP_NULL,
      
      // lw
      `tMEM_OP_WORD:
      begin
        MEM_LDData_inter = MEM_LDData_in;
      end
      
      `tMEM_OP_HWORD:
      // lh
      begin
        case (MEM_Addr_in[1])
          1'b1: MEM_LDData_inter = {{16{MEM_LDData_in[31]}}, MEM_LDData_in[31:16]};
          1'b0: MEM_LDData_inter = {{16{MEM_LDData_in[15]}}, MEM_LDData_in[15:0]};
        endcase
      end

      // lhu
      `tMEM_OP_HWORDU:
      begin
        case (MEM_Addr_in[1])
          1'b1: MEM_LDData_inter = {16'b0, MEM_LDData_in[31:16]};
          1'b0: MEM_LDData_inter = {16'b0, MEM_LDData_in[15:0]};
        endcase
      end
      
      `tMEM_OP_BYTE:
      // lb
      begin
        case (MEM_Addr_in[1:0])
          2'b11: MEM_LDData_inter = {{24{MEM_LDData_in[31]}}, MEM_LDData_in[31:24]};
          2'b10: MEM_LDData_inter = {{24{MEM_LDData_in[23]}}, MEM_LDData_in[23:16]};
          2'b01: MEM_LDData_inter = {{24{MEM_LDData_in[15]}}, MEM_LDData_in[15:8]};
          2'b00: MEM_LDData_inter = {{24{MEM_LDData_in[7]}}, MEM_LDData_in[7:0]};
        endcase
      end
      
      // lbu
      `tMEM_OP_BYTEU:
      begin
        case (MEM_Addr_in[1:0])
          2'b11: MEM_LDData_inter = {24'b0, MEM_LDData_in[31:24]};
          2'b10: MEM_LDData_inter = {24'b0, MEM_LDData_in[23:16]};
          2'b01: MEM_LDData_inter = {24'b0, MEM_LDData_in[15:8]};
          2'b00: MEM_LDData_inter = {24'b0, MEM_LDData_in[7:0]};
        endcase
      end

      default:
      begin
        MEM_LDData_inter = 32'bx;
      end
    endcase
  end


endmodule 
