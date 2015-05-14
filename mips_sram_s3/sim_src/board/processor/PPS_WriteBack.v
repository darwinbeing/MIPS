`include "MIPS1000_defines.v"
module PPS_WriteBack #( 
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
  WB_inst_rd_in, 
  WB_RegWrite_in,
  WB_RF_Wdata_in,

  WB_inst_rd_out,
  WB_RegWrite_out,
  WB_RF_Wdata_out
);


input [31:0] WB_RF_Wdata_in;
input  [4:0] WB_inst_rd_in;
input [RWE_SIZE - 1 : 0] WB_RegWrite_in;

output [31:0] WB_RF_Wdata_out;
output [4:0] WB_inst_rd_out;
output [RWE_SIZE - 1 : 0] WB_RegWrite_out;

assign WB_RF_Wdata_out = WB_RF_Wdata_in;  
assign WB_RegWrite_out = WB_RegWrite_in; 
assign WB_inst_rd_out = WB_inst_rd_in;

endmodule

