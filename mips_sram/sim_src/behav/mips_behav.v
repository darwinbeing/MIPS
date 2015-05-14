/*
 MIPS2 document
 JAL
 Place the return address link in GPR 31. The return link is the address of the second instruction following the branch,
 at which location execution continues after a procedure call.
 This is a PC-region branch (not PC-relative); the effective target address is in the ¡°current¡± 256 MB-aligned region.
 The low 28 bits of the target address is the instr_index field shifted left 2 bits. The remaining upper bits are the corresponding
 bits of the address of the instruction in the delay slot (not the branch itself).
 Jump to the effective target address. Execute the instruction that follows the jump, in the branch delay slot, before
 executing the jump itself.


 For memory write, the bit width of memory address must correspond to the memory size.
 For memory read, the bit width of memory address may correspond to the memory size.
 */

`include "MIPS1000_defines.v"

module mips_behav(run);
  input run;
 
  parameter DEBUG = 1'b1;

  parameter INST_DE_WIDTH = `INST_DE_WIDTH_;
  
  parameter
  DE_INVALID = `DE__INVALID , // INVALID_inst

  //Special
  DE_SLL     = `DE__SLL     ,// SLL  
  DE_SRL     = `DE__SRL     ,// SRL
  DE_SRA     = `DE__SRA     ,// SRA
  DE_SLLV    = `DE__SLLV    ,// SLLV
  DE_SRLV    = `DE__SRLV    ,// SRLV
  DE_SRAV    = `DE__SRAV    ,// SRAV
  DE_JR      = `DE__JR      ,// JR
  DE_JALR    = `DE__JALR    ,// JALR
  //DE_SYSCALL = `DE__SYSCALL ,// SYSCALL
  //DE_BREAK   = `DE__BREAK   ,// BREAK
  //DE_MFHI    = `DE__MFHI    ,// MFHI
  //DE_MTHI    = `DE__MTHI    ,// MTHI
  //DE_MFLO    = `DE__MFLO    ,// MFLO
  //DE_MTLO    = `DE__MTLO    ,// MTLO
  DE_SUB     = `DE__SUB     ,// SUB
  DE_SUBU    = `DE__SUBU    ,// SUBU
  DE_ADD     = `DE__ADD     ,// ADD
  DE_ADDU    = `DE__ADDU    ,// ADDU
  DE_AND     = `DE__AND     ,// AND
  //DE_MULT    = `DE__MULT    ,// MULT
  //DE_MULTU   = `DE__MULTU   ,// MULTU
  DE_NOR     = `DE__NOR     ,// NOR
  DE_OR      = `DE__OR      ,// OR
  DE_SLT     = `DE__SLT     ,// SLT
  DE_SLTU    = `DE__SLTU    ,// SLTU
  DE_XOR     = `DE__XOR     ,// XOR
  //DE_DIV     = `DE__DIV     ,// DIV
  //DE_DIVU    = `DE__DIVU    ,// DIVU
  //REGIMM
  DE_BGEZ    = `DE__BGEZ    ,// BGEZ
  DE_BGEZAL  = `DE__BGEZAL  ,// BGEZAL
  DE_BLTZ    = `DE__BLTZ    ,// BLTZ
  DE_BLTZAL  = `DE__BLTZAL  ,// BLTZAL

  //NORMAL
  DE_ORI     = `DE__ORI     ,// ORI
  DE_ADDI    = `DE__ADDI    ,// ADDI
  DE_ADDIU   = `DE__ADDIU   ,// ADDIU
  DE_ANDI    = `DE__ANDI    ,// ANDI
  DE_BEQ     = `DE__BEQ     ,// BEQ
  DE_BGTZ    = `DE__BGTZ    ,// BGTZ
  DE_BLEZ    = `DE__BLEZ    ,// BLEZ
  DE_BNE     = `DE__BNE     ,// BNE
  DE_J       = `DE__J       ,// J
  DE_JAL     = `DE__JAL     ,// JAL
  DE_LUI     = `DE__LUI     ,// LUI
  DE_SLTI    = `DE__SLTI    ,// SLTI
  DE_SLTIU   = `DE__SLTIU   ,// SLTIU
  DE_LW      = `DE__LW      ,// LW
  DE_SW      = `DE__SW      ,// SW
  DE_LB      = `DE__LB      ,// LB
  DE_LH      = `DE__LH      ,// LH
  //DE_LWL     = `DE__LWL     ,// LWL
  DE_LBU     = `DE__LBU     ,// LBU
  DE_LHU     = `DE__LHU     ,// LHU
  //DE_LWR     = `DE__LWR     ,// LWR
  DE_SB      = `DE__SB      ,// SB
  DE_SH      = `DE__SH      ,// SH
  //DE_SWL     = `DE__SWL     ,// SWL
  //DE_SWR     = `DE__SWR     ,// SWR
  DE_XORI    = `DE__XORI    ;// XORI
  //DE_COP0    = `DE__COP0    ,// COP0
  //DE_SWC0  = `DE__SWC0    ,// SWC0
  //DE_LWC0  = `DE__LWC0    ,// LWC0
  //DE_MFC0    = `DE__MFC0    ,// MFC0
  //DE_MTC0    = `DE__MTC0    ;// MTC0
  
 
  //input [31:0] instr; 
  //output reg [0:INST_DE_WIDTH-1] inst_decode;
  reg [0:INST_DE_WIDTH-1] inst_decode;
   
  reg [31 : 0] memory [0 : `MEM_SIZE-1];
  reg [31 : 0] GPR    [0 : 31];
  reg [31 : 0] PC;
  reg [31 : 0] target_offset;
  reg [32 : 0] temp;
  reg  [4 : 0] s;           // register shift amount 
  reg [31 : 0] paddr;       // physical address
  reg [31 : 0] vaddr;       // virtual address
  reg [31 : 0] memword;     // 32-bit memory data
  reg  [1 : 0] byte;        // 2-bit memory byte select(load)
  reg  [1 : 0] bytesel;     // 2-bit memory byte select(store)
  reg          condition;   // branch condition
  reg          overflow;    // arithmetic overflow
  reg signed [32 : 0] tempS;

  // Instruction fields
  wire  [5:0] inst_op;
  wire  [5:0] inst_func;
  wire  [4:0] inst_regimm;
  wire  [4:0] rs;
  wire  [4:0] rt;
  wire  [4:0] rd;
  wire  [4:0] sa;
  wire  [4:0] base;
  wire [15:0] immediate;
  wire [15:0] offset;
  wire [25:0] instr_index;
  wire [31:0] instr;
  
`include "mips_utils.v"

  assign instr       = memory[PC[31:2]];
  assign inst_op     = instr[31:26];
  assign inst_func   = instr[5:0];
  assign inst_regimm = instr[20:16]; // bltz, bgez, bltzal, bgezal 
  assign rs          = instr[25:21];
  assign base        = instr[25:21];
  assign rt          = instr[20:16];
  assign rd          = instr[15:11];
  assign sa          = instr[10:6];
  assign immediate   = instr[15:0];
  assign offset      = instr[15:0];
  assign instr_index = instr[25:0];

  // Initialize machine states
  initial begin : states
    integer i;

    PC = 32'b0;

    for (i = 0; i < 32; i = i + 1) 
      GPR[i] = 32'b0;

    for (i = 0; i < `MEM_SIZE; i = i + 1) 
      memory[i] = 32'b0;

    // RAM.dat should be put into Modelsim simulation directory
    $readmemh("RAM.dat", memory); 
  end
  
  // Instruction execution
  always @(run) begin
    if (run) begin
      overflow  = 1'b0;
      PC = PC + 32'd4;
      case (inst_op)//synthesis parallel_case
        'd0://special operation 
        begin
          case (inst_func) //synthesis parallel_case
            'd0://SLL rd,rt,sa
            begin
              if (DEBUG) $display("DE_SLL") ;
              if (rd != 0) GPR[rd] = GPR[rt] << sa;
            end

            'd2://SRL rd,rt,sa
            begin
              if (DEBUG) $display("DE_SRL") ;
              if (rd != 0) GPR[rd] = GPR[rt] >> sa;
            end

            'd3://SRA rd,rt,sa
            begin
              if (DEBUG) $display("DE_SRA") ;
              tempS = $signed(GPR[rt]) >>> sa;
              if (rd != 0) GPR[rd] = tempS;
              
            end

            'd4://SLLV rd,rt,rs
            begin
              if (DEBUG) $display("DE_SLLV") ;
              s = GPR[rs];
              temp = GPR[rt];
              //GPR[rd] = {temp[31-s:0], {s{1'b0}}};
              if (rd != 0) GPR[rd] = temp << s;
            end

            'd6://SRLV rd,rt,rs
            begin
              if (DEBUG) $display("DE_SRLV") ;
              s = GPR[rs];
              temp = GPR[rt];
              //GPR[rd] = {{s{1'b0}}, temp[31:s]};
              if (rd != 0) GPR[rd] = temp >> s;
            end

            'd7://SRAV rd,rt,rs
            begin
              if (DEBUG) $display("DE_SRAV") ;
              s = GPR[rs];
              tempS = $signed(GPR[rt]) >>> s;
              if (rd != 0) GPR[rd] = tempS;
            end

            'd8://JR rs
            begin
              if (DEBUG) $display("DE_JR") ;
              PC = GPR[rs];
            end

            'd9://JALR jalr rs(default: rd=31) or jalr rd,rs
            begin
              if (DEBUG) $display("DE_JALR") ;
              //GPR[rd] = PC + 32'd4;
              temp = GPR[rs];
              if (rd != 0) GPR[rd] = PC;
              PC = temp; 
            end
            //'d12://SYSCALL
            //begin
            //  if (DEBUG) $display("DE_SYSCALL");
            //end
            //'d13://BREAK
            //begin
            //  if (DEBUG) $display("DE_BREAK");
            //end
            //'d16://MFHI rd
            //begin
            //  if (DEBUG) $display("DE_MFHI");
            //end
            //'d17://MTHI rs
            //begin
            //  if (DEBUG) $display("DE_MTHI");
            //end
            //'d18://MFLO rd
            //begin
            //  if (DEBUG) $display("DE_MFLO");
            //end
            //'d19://MTLO rs
            //begin
            //  if (DEBUG) $display("DE_MTLO");
            //end
            //'d24://MULT rs,rt
            //begin
            //  if (DEBUG) $display("DE_MULT");
            //end
            //'d25://MULTU rs,rt
            //begin
            //  if (DEBUG) $display("DE_MULTU");
            //end
            //'d26://DIV rs,rt
            //begin
            //  if (DEBUG) $display("DE_DIV") ;
            //end
            //'d27://DIVU rs,rt
            //begin
            //  if (DEBUG) $display("DE_DIVU") ;
            //end
            
            'd32://ADD rd,rs,rt
            begin
              if (DEBUG) $display("DE_ADD") ;
              temp = ADD(GPR[rs], GPR[rt]);
              if (temp[32] != temp[31])
                overflow = 1'b1;
              else if (rd != 0) 
                GPR[rd] = temp[31:0];
              //zero = CalcZero(temp[31:0]);  
            end

            'd33://ADDU rd,rs,rt
            begin
              if (DEBUG) $display("DE_ADDU") ;
              temp = ADD(GPR[rs], GPR[rt]);
              if (rd != 0) GPR[rd] = temp[31:0];
              //zero = CalcZero(temp[31:0]);  
            end

            'd34://SUB rd,rs,rt
            begin
              if (DEBUG) $display("DE_SUB") ;
              temp = SUB(GPR[rs], GPR[rt]);
              if (temp[32] != temp[31])
                overflow = 1'b1;
              else if (rd != 0) 
                GPR[rd] = temp[31:0];
            end

            'd35://SUBU rd,rs,rt
            begin
              if (DEBUG) $display("DE_SUBU") ;
              temp = SUB(GPR[rs], GPR[rt]);
              if (rd != 0) GPR[rd] = temp[31:0];
            end

            'd36://AND rd,rs,rt
            begin
              if (DEBUG) $display("DE_AND") ;
              if (rd != 0) GPR[rd] = GPR[rs] & GPR[rt];
            end

            'd37://OR rd,rs,rt
            begin
              if (DEBUG) $display("DE_OR") ;
              if (rd != 0) GPR[rd] = GPR[rs] | GPR[rt];
            end

            'd38://XOR rd,rs,rt
            begin
              if (DEBUG) $display("DE_XOR") ;
              if (rd != 0) GPR[rd] = GPR[rs] ^ GPR[rt];
            end

            'd39://NOR rd,rs,rt
            begin
              if (DEBUG) $display("DE_NOR") ;
              if (rd != 0) GPR[rd] = ~(GPR[rs] | GPR[rt]);
            end

            'd42://SLT rd,rs,rt
            begin
              if (DEBUG) $display("DE_SLT") ;
              if ($signed(GPR[rs]) < $signed(GPR[rt])) 
                GPR[rd] = 32'b1;
              else
                GPR[rd] = 32'b0;
            end

            'd43://SLTU rd,rs,rt
            begin
              if (DEBUG) $display("DE_SLTU");
              if ({1'b0, GPR[rs]} < {1'b0, GPR[rt]})
                GPR[rd] = 32'b1;
              else
                GPR[rd] = 32'b0;
            end

            default: 
            begin
              if (DEBUG) $display("DE_INVALID") ;
            end
          endcase
        end

        'd1://regimm opreation
        begin
          case (inst_regimm) //synthesis parallel_case

            'd0://BLTZ rs,offset(signed)
            begin
              if (DEBUG) $display("DE_BLTZ") ;
              target_offset = sign_extend_offset({offset, 2'b0});
              condition = ($signed(GPR[rs]) < 32'sb0);
              if (condition) 
                PC = PC + target_offset;
            end

            'd1://BGEZ rs,offset(signed)
            begin
              if (DEBUG) $display("DE_BGEZ") ;
              target_offset = sign_extend_offset({offset, 2'b0});
              condition = ($signed(GPR[rs]) >= 32'sb0);
              if (condition) 
                PC = PC + target_offset;
            end

            'd16://BLTZAL rs,offset(signed)
            begin
              if (DEBUG) $display("DE_BLTZAL") ;
              target_offset = sign_extend_offset({offset, 2'b0});
              //GPR[31] = PC + 32'd4;
              GPR[31] = PC;
              condition = ($signed(GPR[rs]) < 32'sb0);
              if (condition) 
                PC = PC + target_offset;
            end
            'd17://BGEZAL rs,offset(signed)
            begin
              if (DEBUG) $display("DE_BGEZAL") ;
              target_offset = sign_extend_offset({offset, 2'b0});
              //GPR[31] = PC + 32'd4;
              GPR[31] = PC;
              condition = ($signed(GPR[rs]) >= 32'sb0);
              if (condition) 
                PC = PC + target_offset;
            end
            default: 
            begin
              if (DEBUG) $display("DE_INVALID") ;
            end
          endcase
        end

        'd2://J imm26({pc[31:28],imm26,00})
        begin
          if (DEBUG) $display("DE_J") ;
          PC = {PC[31:28], instr_index, 2'b0};
        end

        'd3://JAL imm26({pc[31:28],imm26,00})
        begin
          if (DEBUG) $display("DE_JAL") ;
          //GPR[31] = PC + 32'd4;
          GPR[31] = PC;
          PC = {PC[31:28], instr_index, 2'b0};
        end

        'd4://BEQ rs,rt,offset(signed)
        begin
          if (DEBUG) $display("DE_BEQ") ;
          target_offset = sign_extend_offset({offset, 2'b0});
          condition = (GPR[rs] == GPR[rt]);
          if (condition) 
            PC = PC + target_offset;
        end

        'd5://BNE rs,rt,offset(signed)
        begin
          if (DEBUG) $display("DE_BNE") ;
          target_offset = sign_extend_offset({offset, 2'b0});
          condition = (GPR[rs] != GPR[rt]);
          if (condition) 
            PC = PC + target_offset;
        end

        'd6://BLEZ rs,offset(signed)
        begin
          if (DEBUG) $display("DE_BLEZ") ;
          target_offset = sign_extend_offset({offset, 2'b0});
          condition = ($signed(GPR[rs]) <= 32'sb0);
          if (condition) 
            PC = PC + target_offset;
        end

        'd7://BGTZ rs,offset(signed)
        begin
          if (DEBUG) $display("DE_BGTZ") ;
          target_offset = sign_extend_offset({offset, 2'b0});
          condition = ($signed(GPR[rs]) > 32'sb0);
          if (condition) 
            PC = PC + target_offset;
        end

        'd8://ADDI rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_ADDI") ;
          temp = ADD(GPR[rs], sign_extend_immediate(immediate));
          if (temp[32] != temp[31])
            overflow = 1'b1;
          else if (rt != 0) 
            GPR[rt] = temp[31:0];
          //zero = CalcZero(temp[31:0]);  
        end

        'd9://ADDIU rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_ADDIU") ;
          temp = ADD(GPR[rs], sign_extend_immediate(immediate));
          if (rt != 0) GPR[rt] = temp[31:0];
          //zero = CalcZero(temp[31:0]);  
        end

        'd10://SLTI rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_SLTI") ;
          if ($signed(GPR[rs]) < $signed(sign_extend_immediate(immediate)))
            GPR[rt] = 32'b1;
          else
            GPR[rt] = 32'b0;
        end

        'd11://SLTIU rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_SLTIU") ;
          if ({1'b0, GPR[rs]} < {1'b0, sign_extend_immediate(immediate)})
            GPR[rt] = 32'b1;
          else
            GPR[rt] = 32'b0;
        end

        'd12://ANDI rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_ANDI") ;
          if (rt != 0) 
            GPR[rt] = GPR[rs] & zero_extend_immediate(immediate);
        end

        'd13://ORI rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_ORI") ;
          if (rt != 0) 
            GPR[rt] = GPR[rs] | zero_extend_immediate(immediate);
        end

        'd14://XORI rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_XORI") ;
          if (rt != 0) 
            GPR[rt] = GPR[rs] ^ zero_extend_immediate(immediate);
        end

        'd15://LUI rt,imm16
        begin
          if (DEBUG) $display("DE_LUI") ;
          if (rt != 0) GPR[rt] = {immediate, 16'b0};
        end

  //      'd16://COP0 func
  //      begin
  //	      case(inst_cop0_func) //synthesis parallel_case
  //          'd0://mfc0 rt,rd // GPR[rd] = CPR[rt] //differ to mips32 definition
  //          begin
  //            if (DEBUG) $display("DE_MFC0");
  //          end
  //
  //          'd4://mtc0 rt,rd // CPR[rd] = GPR[rt] //follow the mips32 definition
  //          begin
  //            if (DEBUG) $display("DE_MTC0;
  //          end
  //          default:
  //          begin
  //            casex(inst_cop0_code) //synthesis parallel_case
  //              COP0_FUNC_DERET,
  //              COP0_FUNC_ERET,
  //              COP0_FUNC_WAIT:
  //              begin
  //                if (DEBUG) $display("DE_COP0;
  //              end
  //              default:
  //              begin
  //                if (DEBUG) $display("DE_INVALID;
  //              end
  //            endcase
  //          end
  //        endcase
  //      end

        'd32://LB rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_LB");
          vaddr   = sign_extend_immediate(offset) + GPR[base];
          paddr   = {2'b0, vaddr[31:2]};
          memword = memory[paddr];
          byte    = vaddr[1:0];
          //GPR[rt] = sign_extend_byte(memword[7 + 8 * byte : 8 * byte]);
          if (rt != 0)
            GPR[rt] = sign_extend_byte(load_byte(memword, byte));
        end

        'd33://LH rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_LH") ;
          vaddr   = sign_extend_immediate(offset) + GPR[base];
          if (vaddr[0] != 1'b0) begin
            $display("LH memory address error");
            $stop;
          end
          paddr   = {2'b0, vaddr[31:2]};
          memword = memory[paddr];
          byte    = vaddr[1:0];
          if (rt != 0)
            GPR[rt] = sign_extend_immediate(load_hword(memword, byte));
        end

  //      'd34://LWL rt,offset(base) (offset:signed;base:rs)
  //      begin
  //	      if (DEBUG) $display("DE_LWL") ;
  //      end

        'd35://LW rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_LW");
          vaddr   = sign_extend_immediate(offset) + GPR[base];
          if (vaddr[1:0] != 2'b0) begin
            $display("LW memory address error");
            $stop;
          end
          paddr   = {2'b0, vaddr[31:2]};
          memword = memory[paddr];
          if (rt != 0)
            GPR[rt] = memword;
        end

        'd36://LBU rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_LBU");
          vaddr   = sign_extend_immediate(offset) + GPR[base];
          paddr   = {2'b0, vaddr[31:2]};
          memword = memory[paddr];
          byte    = vaddr[1:0];
          if (rt != 0)
            GPR[rt] = zero_extend_byte(load_byte(memword, byte));
        end

        'd37://LHU rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_LHU") ;
          vaddr   = sign_extend_immediate(offset) + GPR[base];
          if (vaddr[0] != 1'b0) begin
            $display("LHU memory address error");
            $stop;
          end
          paddr   = {2'b0, vaddr[31:2]};
          memword = memory[paddr];
          byte    = vaddr[1:0];
          if (rt != 0)
            GPR[rt] = zero_extend_immediate(load_hword(memword, byte));
        end

  //      'd38://LWR rt,offset(base) (offset:signed;base:rs)
  //      begin
  //	      if (DEBUG) $display("DE_LWR") ;
  //      end

        'd40://SB rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_SB");
          vaddr   = sign_extend_immediate(offset) + GPR[base];
          paddr   = {2'b0, vaddr[31:2]};
          temp    = GPR[rt];
          memword = memory[paddr];
          bytesel = vaddr[1:0];
          memory[paddr[`MEM_ADDR_WIDTH-1:0]] = store_byte(temp, memword, bytesel);
        end

        'd41://SH rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_SH");
          vaddr   = sign_extend_immediate(offset) + GPR[base];
          if (vaddr[0] != 1'b0) begin
            $display("SH memory address error");
            $stop;
          end
          paddr   = {2'b0, vaddr[31:2]};
          temp    = GPR[rt];
          memword = memory[paddr];
          bytesel = vaddr[1:0];
          memory[paddr[`MEM_ADDR_WIDTH-1:0]] = store_hword(temp, memword, bytesel);
        end

  //      'd42://SWL rt,offset(base) (offset:signed;base:rs)
  //      begin
  //	      if (DEBUG) $display("DE_SWL ;
  //      end

        'd43://SW rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_SW") ;
          vaddr = sign_extend_immediate(offset) + GPR[base];
          if (vaddr[1:0] != 2'b0) begin
            $display("SW memory address error");
            //$stop;
          end
          paddr = {2'b0, vaddr[31:2]};
          memory[paddr[`MEM_ADDR_WIDTH-1:0]] = GPR[rt];
        end

  //      'd46://SWR rt,offset(base) (offset:signed;base:rs)
  //      begin
  //	      if (DEBUG) $display("DE_SWR ;
  //      end

        default: 
        begin
          if (DEBUG) $display("DE_INVALID");
        end
      endcase
    end
  end

endmodule


