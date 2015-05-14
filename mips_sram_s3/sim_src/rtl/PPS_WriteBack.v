module PPS_WriteBack
(
  WB_inst_rd_in, 
  WB_RegWrite_in,
  WB_RF_Wdata_in,

  WB_inst_rd_out,
  WB_RegWrite_out,
  WB_RF_Wdata_out
);

parameter RWE_SIZE = 1;

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

