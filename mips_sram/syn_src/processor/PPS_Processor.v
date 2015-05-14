
`include "MIPS1000_defines.v"
module PPS_Processor 
(
  clk,
  rst,
  inst,
  data_in,
  inst_addr,
  data_addr,
  data_out,
  bwe
);

input clk;
input rst;

// Memory Interface
 input [31:0] inst;
 input [31:0] data_in;
output [31:0] inst_addr;
output [31:0] data_addr;
output [31:0] data_out;
output  [3:0] bwe;


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
          
wire [31:0] IF_PC_out;
wire [31:0] IF_addr_out;
wire [31:0] IF_inst_out;
wire [31:0] IF_inst_in;

wire [RWE_SIZE - 1 : 0] ID_RegWrite_out;
wire [ALU_OP_SIZE - 1 : 0] ID_aluop_out;
wire [MEM_OP_SIZE - 1 : 0] ID_memop_out; 
wire [MEM_WR_SIZE - 1 : 0] ID_memwr_out; 
wire [MEM_OP_TYPE_SIZE - 1 : 0] ID_memop_type_out;
wire [31:0] ID_MUXop0_out;
wire [31:0] ID_MUXop1_out;
wire [31:0] ID_MUXop2_out;
wire [31:0] ID_bra_tgt_out;
wire  [4:0] ID_inst_rd_out; 
wire        ID_Pstomp_out;
wire        ID_Pstall_out;
wire        ID_mem_wait;

wire [31:0] EX_STData_out;
wire [MEM_OP_SIZE - 1 : 0]  EX_memop_out;
wire [MEM_OP_TYPE_SIZE - 1 : 0]  EX_memop_type_out;
wire [MEM_WR_SIZE - 1 : 0] EX_memwr_out;

wire [31:0] EX_ALUOut_out;
wire  [4:0] EX_inst_rd_out; 
wire        EX_bflag_out;
wire        EX_RegWrite_out;

wire [31:0] MEM_Addr_in;
wire [31:0] MEM_MUXOut_out;
wire [31:0] MEM_STData_out;
wire  [4:0] MEM_inst_rd_out; 
wire [31:0] MEM_Addr_out;
wire [31:0] MEM_LDData_in;
wire        MEM_memwr_out;
wire        MEM_memop_out;
wire        MEM_RegWrite_out;

wire [31:0] WB_RF_Wdata_out;
wire  [4:0] WB_inst_rd_out;
wire [RWE_SIZE - 1 : 0] WB_RegWrite_out;
wire  [3:0] MEM_bwe_out; 

assign bwe = MEM_bwe_out;
assign inst_addr = IF_addr_out;
assign data_addr = MEM_Addr_out;
assign data_out = MEM_STData_out;   
assign IF_inst_in = inst;
assign MEM_LDData_in = data_in;


PPS_Fetch IF
(
  .clk(clk),
  .rst(rst),

  .Pstomp      (ID_Pstomp_out),
  .bra_tgt     (ID_bra_tgt_out),
  .pcwe        (ID_mem_wait),
  .IF_inst_in  (IF_inst_in),
  .IF_inst_out (IF_inst_out),
  .IF_addr_out (IF_addr_out),
  .IF_PC_out   (IF_PC_out) 
);

PPS_Decode ID
(
  .clk              (clk),
  .rst              (rst),

  .ID_inst_in       (IF_inst_out),
  .ID_PC_in         (IF_PC_out), 
  .EX_bflag_in      (EX_bflag_out), 

  .WB_RF_Wdata_in   (WB_RF_Wdata_out),
  .WB_inst_rd_in    (WB_inst_rd_out ),
  .WB_RegWrite_in   (WB_RegWrite_out),

  .ID_mem_wait      (ID_mem_wait      ),
  .ID_MUXop0_out    (ID_MUXop0_out    ),
  .ID_MUXop1_out    (ID_MUXop1_out    ),
  .ID_MUXop2_out    (ID_MUXop2_out    ),
  .ID_inst_rd_out   (ID_inst_rd_out   ), 
  .ID_aluop_out     (ID_aluop_out     ),
  .ID_RegWrite_out  (ID_RegWrite_out  ),
  .ID_memop_out     (ID_memop_out     ),
  .ID_memop_type_out(ID_memop_type_out),
  .ID_memwr_out     (ID_memwr_out     ),

  .ID_Pstomp_out    (ID_Pstomp_out    ),
  .ID_bra_tgt_out   (ID_bra_tgt_out   )
);

PPS_Execute EXE
(
  .EX_MUXop0_in     (ID_MUXop0_out    ),
  .EX_MUXop1_in     (ID_MUXop1_out    ),
  .EX_MUXop2_in     (ID_MUXop2_out    ),
  .EX_inst_rd_in    (ID_inst_rd_out   ), 
  .EX_aluop_in      (ID_aluop_out     ),
  .EX_RegWrite_in   (ID_RegWrite_out  ),
  .EX_memop_in      (ID_memop_out     ),
  .EX_memop_type_in (ID_memop_type_out),
  .EX_memwr_in      (ID_memwr_out     ),

  .EX_ALUOut_out    (EX_ALUOut_out    ),
  .EX_STData_out    (EX_STData_out    ),
  .EX_inst_rd_out   (EX_inst_rd_out   ), 
  .EX_memop_out     (EX_memop_out     ),
  .EX_memop_type_out(EX_memop_type_out),
  .EX_memwr_out     (EX_memwr_out     ),
  .EX_RegWrite_out  (EX_RegWrite_out  ),
  .EX_bflag_out     (EX_bflag_out     )
);

PPS_Memory MEM
(
  .MEM_ALUOut_in    (EX_ALUOut_out    ),
  .MEM_STData_in    (EX_STData_out    ),
  .MEM_inst_rd_in   (EX_inst_rd_out   ), 
  .MEM_RegWrite_in  (EX_RegWrite_out  ),
  .MEM_memop_in     (EX_memop_out     ),
  .MEM_memop_type_in(EX_memop_type_out),
  .MEM_memwr_in     (EX_memwr_out     ),

  // To WB 
  .MEM_MUXOut_out   (MEM_MUXOut_out   ),
  .MEM_inst_rd_out  (MEM_inst_rd_out  ), 
  .MEM_RegWrite_out (MEM_RegWrite_out ),


  // Memory Interface
  .MEM_Addr_in      (EX_ALUOut_out  ),
  .MEM_LDData_in    (MEM_LDData_in  ),
  .MEM_STData_out   (MEM_STData_out ),
  .MEM_Addr_out     (MEM_Addr_out   ),
  .MEM_memwr_out    (MEM_memwr_out  ),
  .MEM_memop_out    (MEM_memop_out  ),
  .MEM_bwe_out      (MEM_bwe_out    )
);

PPS_WriteBack WB
(
  .WB_inst_rd_in  (MEM_inst_rd_out), 
  .WB_RegWrite_in (MEM_RegWrite_out),
  .WB_RF_Wdata_in (MEM_MUXOut_out),
  
  .WB_inst_rd_out (WB_inst_rd_out ),
  .WB_RegWrite_out(WB_RegWrite_out),
  .WB_RF_Wdata_out(WB_RF_Wdata_out)
);




endmodule
