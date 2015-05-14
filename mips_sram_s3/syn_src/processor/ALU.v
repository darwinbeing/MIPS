`include "MIPS1000_defines.v"

module ALU 
(
	op1,op2,       // ALU operands
	ctrl,          // ALU operation encodings
	res,           // 32-bit ALU result
	//mem_addr,
	bflag,         // set to 1 when the branch is taken
	overflow       // ALU overflow
);

  parameter ALUCTRL_WIDTH=`ALU_CTRL_WIDTH;
 
  //parameter  OP_NONE  = `ALU_OP_NONE; 

  // Arithmetic operations
  parameter  OP_ADD   = `ALU_OP_ADD;  // op1 + op2 signed
  parameter  OP_ADDU  = `ALU_OP_ADDU; // op1 + op2 unsigned
  parameter  OP_SUB   = `ALU_OP_SUB;  // op1 - op2 signed
  parameter  OP_SUBU  = `ALU_OP_SUBU; // op1 - op2 unsigned

  // Relational operations
  parameter  OP_SLT   = `ALU_OP_SLT;  // op1 < op2 (signed)
  parameter  OP_SLTU  = `ALU_OP_SLTU; // op1 < op2 (unsigned)
  parameter  OP_EQ    = `ALU_OP_EQ;   // op1 == op2
  parameter  OP_NEQ   = `ALU_OP_NEQ;  // op1 != op2
  parameter  OP_LTZ   = `ALU_OP_LTZ;  // op1 < 0
  parameter  OP_GTZ   = `ALU_OP_GTZ;  // op1 > 0
  parameter  OP_LEZ   = `ALU_OP_LEZ;  // op1 <= 0
  parameter  OP_GEZ   = `ALU_OP_GEZ;  // op1 >= 0

  // Logical operations
  parameter  OP_AND   = `ALU_OP_AND;  // and 
  parameter  OP_OR    = `ALU_OP_OR;   // or
  parameter  OP_XOR   = `ALU_OP_XOR;  // xor
  parameter  OP_NOR   = `ALU_OP_NOR;  // nor

  // Shift operations
  parameter  OP_SLL   = `ALU_OP_SLL;  // shift left logical
  parameter  OP_SRL   = `ALU_OP_SRL;  // shift right logical
  parameter  OP_SRA   = `ALU_OP_SRA;  // shift right arithmetic
  parameter  OP_LUI   = `ALU_OP_LUI;  // load 16-bit immediate operand

  // Operations which do nothing but are useful
  parameter  OP_OP2   = `ALU_OP_OP2;  // return op2


  input  [31:0]              op1;  // ALU operand 1
  input  [31:0]              op2;  // ALU operand 2
  input  [ALUCTRL_WIDTH-1:0] ctrl; // ALU Operation encodings
  
  output [31:0]              res;  // 32-bit result
  //output [31:0]              mem_addr;
  output                     bflag;
  output                     overflow;
 
  reg    [31:0]              res;
  reg                        bflag;
  
  //##################### Arithmetic Operation ######################
  wire  [32:0] res_add;         		      // 33-bit adder result
  wire  [32:0] op1_inter, op2_inter;  		// 33-bit internal input operands
  wire         nop2_sel;              		// select the opposite of op2
  wire         sign_op1;                  // operand 1 sign-ext bit
  wire         sign_op2;                  // operand 2 sign-ext bit
  wire         sign;                     	// Signed operation
  
  // Sign extension for the signed operation 
  assign sign      = ctrl==OP_ADD | ctrl==OP_SUB | ctrl==OP_SLT;
  assign sign_op1  = sign & op1[31];
  assign sign_op2  = sign & op2[31];

  // -op2 to obtain a substraction
  assign nop2_sel  = ctrl==OP_SUB | ctrl==OP_SUBU | ctrl==OP_SLT | ctrl==OP_SLTU;
  assign op2_inter = {sign_op2, op2};
  assign op1_inter = {sign_op1, op1};
  assign res_add   = nop2_sel ? op1_inter - op2_inter : op1_inter + op2_inter;

  //Only ADD and SUB can cause overflow
  //ADDU and SUBU ignore overflow
  assign overflow  = res_add[31] ^ res_add[32];

  //Give the add result directly to tell the synthesis tool that only 
  //the adder is used for caculating the address of the mem operation 
  //assign mem_addr  = res_add[31:0];

  //##################### shift OPERATIONS ######################
  
  wire [31:0] res_shl;  // Results of right shifter
  wire [31:0] res_shr;  // Results of right shifter
  wire  [4:0] shamt;    // Shift amount
    
  // Value of the shift for the programmable shifter
  assign   shamt = op1[4:0];
  assign res_shl = op2 << shamt;
  assign res_shr = (ctrl==OP_SRA && op2[31]==1'b1)? ~(~op2 >> shamt) : op2 >> shamt;
 
 
  //##################### misc OPERATIONS ######################
  
  wire [31:0] res_lui;  // Result of Load Upper Immediate
  assign res_lui = {op2[15:0],16'b0};
   
  //##################### res selection ######################
 
  always @(ctrl,res_add,op1,op2,res_shl,res_shr,res_lui) 
  begin
    res  = op2;
    bflag = 1'b0;
    case(ctrl) /*synthesis parallel_case */
      OP_ADD,
      OP_ADDU,
      OP_SUB,
      OP_SUBU: res = res_add[31:0];
      OP_SLTU,
      OP_SLT:  res = {31'b0,res_add[32]};
      OP_AND:  res = op1 & op2;
      OP_OR:   res = op1 | op2;
      OP_NOR:  res = ~(op1 | op2);
      OP_XOR:  res = op1 ^ op2;
      OP_EQ:   bflag = ~(|(op1 ^ op2));
      OP_NEQ:  bflag = |(op1 ^ op2);
      OP_LTZ:  bflag = op1[31];
      OP_GTZ:  bflag = ~op1[31] && (|op1[30:0]);
      OP_LEZ:  bflag = op1[31] |(~|op1);
      OP_GEZ:  bflag = ~op1[31];
      OP_SLL:  res = res_shl;
      OP_SRL,
      OP_SRA:  res = res_shr;
      OP_LUI:  res = res_lui;
      OP_OP2:  res = op2;
      default: begin
               res = op2;
               bflag = 1'b0;
               end
     endcase        
  end

endmodule
