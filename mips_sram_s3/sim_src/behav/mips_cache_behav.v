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


 log: tempS -> signed_temp
      delete memory struct and all the instruction read and 
      data read/write from/to memory struct
 */

`include "MIPS1000_defines.v"

module mips_cache_behav (
  input             clk,
  input             rst,
  input             run_inst,
  input             run_data,
  output reg [31:0] inst_addr,
  output reg        inst_read,
  input             inst_ready,
  input      [31:0] inst,
  output reg [31:0] data_addr,
  output reg        data_read,
  output reg        data_write,
  output reg  [3:0] data_bwe,
  input             data_ready,
  inout      [31:0] data,
  output reg        done
);
 
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
   
  reg [31 : 0] instr;
  reg [31 : 0] data_txd;
  reg [31 : 0] GPR    [0 : 31];
  reg [31 : 0] PC;
  reg [31 : 0] CPC;
  reg [31 : 0] target_offset;
  reg [32 : 0] temp;
  reg  [4 : 0] s;           // register shift amount 
  //reg [31 : 0] paddr;     // no physical address
  reg [31 : 0] vaddr;       // virtual address
  reg [31 : 0] memword;     // 32-bit memory data
  reg [31 : 0] wdata;       // 32-bit memory write data (software implementation)
  reg [31 : 0] mdata;       // 32-bit masked memory data
  reg  [1 : 0] mybyte;      // 2-bit memory byte select(load)
  reg  [1 : 0] bytesel;     // 2-bit memory byte select(store)
  reg          condition;   // branch condition
  reg          overflow;    // arithmetic overflow
  reg signed [32 : 0] signed_temp;
  reg        werf;
  reg  [4:0] warf;

  // Instruction fields
  reg  [5:0] inst_op;
  reg  [5:0] inst_func;
  reg  [4:0] inst_regimm;
  reg  [4:0] rs;
  reg  [4:0] rt;
  reg  [4:0] rd;
  reg  [4:0] sa;
  reg  [4:0] base;
  reg [15:0] immediate;
  reg [15:0] offset;
  reg [25:0] instr_index;
  
`include "mips_utils.v"

  assign data = data_txd;

  //-----------------------------------------------------------------------
  // Why clear machine states at negedge?
  // In the testbench the reset is asserted at the negedge of clock. And
  // we check machine states right after the negedge of clock when check_en
  // = 1. So the the last check occurs when the reset is asserted at the 
  // negedge of clock 
  //-----------------------------------------------------------------------
  always @(negedge rst) begin 
    $display($time,, "At negedge clock");
    if (rst == 0) begin: initialize_states
      integer i;
      #1;
      PC = 0;
      for (i = 0; i < 32; i = i + 1) GPR[i] = 0;
    end
  end

  // Instruction execution
  always @(run_inst or run_data) begin
    data_read   = 1'b0;
    data_write  = 1'b0;
    data_bwe    = 4'b0;
    data_txd    = 32'hz;
    inst_read   = 1'b0;
    inst_addr   = 32'hz;
    data_addr   = 32'hz;
    done        = 1'b0; /* default */
    werf        = 1'b0; /* default */
    warf        = 5'd0;
    if (run_inst) begin
      data_txd  = 32'hz;
      inst_read = 1'b1;
      CPC       = PC;
      inst_addr = PC;
      $display("BEH: current PC = %h %g ns", PC, $time);
      wait(inst_ready);
      #(`PERIOD);
      inst_read   = 1'b0;
      instr       = inst;
      inst_op     = instr[31:26];
      inst_func   = instr[5:0];
      inst_regimm = instr[20:16]; // bltz, bgez, bltzal, bgezal 
      rs          = instr[25:21];
      base        = instr[25:21];
      rt          = instr[20:16];
      rd          = instr[15:11];
      sa          = instr[10:6];
      immediate   = instr[15:0];
      offset      = instr[15:0];
      instr_index = instr[25:0];
      PC          = PC + 32'd4;

      overflow  = 1'b0;
      if (PC / 4 >= `MEM_SIZE) begin
        $display("PC(%h) out of bound", PC);
        $stop;
      end
      case (inst_op)//synthesis parallel_case
        'd0://special operation 
        begin
          case (inst_func) //synthesis parallel_case
            'd0://SLL rd,rt,sa
            begin
              if (DEBUG) $display("DE_SLL") ;
              if (rd != 0) begin
                GPR[rd] = GPR[rt] << sa;
                werf = 1'b1; warf = rd;
              end
              done = 1'b1;
            end

            'd2://SRL rd,rt,sa
            begin
              if (DEBUG) $display("DE_SRL") ;
              if (rd != 0) begin
                GPR[rd] = GPR[rt] >> sa;
                werf = 1'b1; warf = rd;
              end
              done = 1'b1;
            end

            'd3://SRA rd,rt,sa
            begin
              if (DEBUG) $display("DE_SRA") ;
              signed_temp = $signed(GPR[rt]) >>> sa;
              if (rd != 0) begin
                GPR[rd] = signed_temp;
                werf = 1'b1; warf = rd;
              end
              done = 1'b1;
              
            end

            'd4://SLLV rd,rt,rs
            begin
              if (DEBUG) $display("DE_SLLV") ;
              s = GPR[rs];
              temp = GPR[rt];
              //GPR[rd] = {temp[31-s:0], {s{1'b0}}};
              if (rd != 0) begin
                GPR[rd] = temp << s;
                werf = 1'b1; warf = rd;
              end
              done = 1'b1;
            end

            'd6://SRLV rd,rt,rs
            begin
              if (DEBUG) $display("DE_SRLV") ;
              s = GPR[rs];
              temp = GPR[rt];
              //GPR[rd] = {{s{1'b0}}, temp[31:s]};
              if (rd != 0) begin
                GPR[rd] = temp >> s;
                werf = 1'b1; warf = rd;
              end
              done = 1'b1;
            end

            'd7://SRAV rd,rt,rs
            begin
              if (DEBUG) $display("DE_SRAV") ;
              s = GPR[rs];
              signed_temp = $signed(GPR[rt]) >>> s;
              if (rd != 0) begin
                GPR[rd] = signed_temp; 
                werf = 1'b1; warf = rd;
              end
              done = 1'b1;
            end

            'd8://JR rs
            begin
              if (DEBUG) $display("DE_JR") ;
              PC = GPR[rs];
              done = 1'b1;
            end

            'd9://JALR jalr rs(default: rd=31) or jalr rd,rs
            begin
              if (DEBUG) $display("DE_JALR") ;
              //GPR[rd] = PC + 32'd4;
              temp = GPR[rs];
              if (rd != 0) begin
                GPR[rd] = PC;
                werf = 1'b1; warf = rd;
              end
              PC = temp; 
              done = 1'b1;
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
              else if (rd != 0) begin
                GPR[rd] = temp[31:0];
                werf = 1'b1; warf = rd;
              end
              //zero = CalcZero(temp[31:0]);  
              done = 1'b1;
            end

            'd33://ADDU rd,rs,rt
            begin
              if (DEBUG) $display("DE_ADDU") ;
              temp = ADD(GPR[rs], GPR[rt]);
              if (rd != 0) begin
                GPR[rd] = temp[31:0];
                werf = 1'b1; warf = rd;
              end
              //zero = CalcZero(temp[31:0]);  
              done = 1'b1;
            end

            'd34://SUB rd,rs,rt
            begin
              if (DEBUG) $display("DE_SUB") ;
              temp = SUB(GPR[rs], GPR[rt]);
              if (temp[32] != temp[31])
                overflow = 1'b1;
              else if (rd != 0) begin
                GPR[rd] = temp[31:0];
                werf = 1'b1; warf = rd;
              end
              done = 1'b1;
            end

            'd35://SUBU rd,rs,rt
            begin
              if (DEBUG) $display("DE_SUBU") ;
              temp = SUB(GPR[rs], GPR[rt]);
              if (rd != 0) begin
                GPR[rd] = temp[31:0];
                werf = 1'b1; warf = rd;
              end
              done = 1'b1;
            end

            'd36://AND rd,rs,rt
            begin
              if (DEBUG) $display("DE_AND") ;
              if (rd != 0) begin
                GPR[rd] = GPR[rs] & GPR[rt];
                werf = 1'b1; warf = rd;
              end
              done = 1'b1;
            end

            'd37://OR rd,rs,rt
            begin
              if (DEBUG) $display("DE_OR") ;
              if (rd != 0) begin
                GPR[rd] = GPR[rs] | GPR[rt];
                werf = 1'b1; warf = rd;
              end
              done = 1'b1;
            end

            'd38://XOR rd,rs,rt
            begin
              if (DEBUG) $display("DE_XOR") ;
              if (rd != 0) begin
                GPR[rd] = GPR[rs] ^ GPR[rt];
                werf = 1'b1; warf = rd;
              end
              done = 1'b1;
            end

            'd39://NOR rd,rs,rt
            begin
              if (DEBUG) $display("DE_NOR") ;
              if (rd != 0) begin
                GPR[rd] = ~(GPR[rs] | GPR[rt]);
                werf = 1'b1; warf = rd;
              end
              done = 1'b1;
            end

            'd42://SLT rd,rs,rt
            begin
              if (DEBUG) $display("DE_SLT") ;
              if ($signed(GPR[rs]) < $signed(GPR[rt])) 
                GPR[rd] = 32'b1;
              else
                GPR[rd] = 32'b0;
              werf = 1'b1; warf = rd;
              done = 1'b1;
            end

            'd43://SLTU rd,rs,rt
            begin
              if (DEBUG) $display("DE_SLTU");
              if ({1'b0, GPR[rs]} < {1'b0, GPR[rt]})
                GPR[rd] = 32'b1;
              else
                GPR[rd] = 32'b0;
              werf = 1'b1; warf = rd;
              done = 1'b1;
            end

            default: 
            begin
              if (DEBUG) $display("DE_INVALID") ;
              done = 1'b1;
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
              done = 1'b1;
            end

            'd1://BGEZ rs,offset(signed)
            begin
              if (DEBUG) $display("DE_BGEZ") ;
              target_offset = sign_extend_offset({offset, 2'b0});
              condition = ($signed(GPR[rs]) >= 32'sb0);
              if (condition) 
                PC = PC + target_offset;
              done = 1'b1;
            end

            'd16://BLTZAL rs,offset(signed)
            begin
              if (DEBUG) $display("DE_BLTZAL") ;
              target_offset = sign_extend_offset({offset, 2'b0});
              //GPR[31] = PC + 32'd4;
              GPR[31] = PC;
              werf = 1'b1; warf = 5'd31;
              condition = ($signed(GPR[rs]) < 32'sb0);
              if (condition) begin
                PC = PC + target_offset;
              end
              done = 1'b1;
            end
            'd17://BGEZAL rs,offset(signed)
            begin
              if (DEBUG) $display("DE_BGEZAL") ;
              target_offset = sign_extend_offset({offset, 2'b0});
              //GPR[31] = PC + 32'd4;
              werf = 1'b1; warf = 5'd31;
              GPR[31] = PC;
              condition = ($signed(GPR[rs]) >= 32'sb0);
              if (condition) begin
                PC = PC + target_offset;
              end
              done = 1'b1;
            end
            default: 
            begin
              if (DEBUG) $display("DE_INVALID") ;
              done = 1'b1;
            end
          endcase
        end

        'd2://J imm26({pc[31:28],imm26,00})
        begin
          if (DEBUG) $display("DE_J") ;
          PC = {PC[31:28], instr_index, 2'b0};
          done = 1'b1;
        end

        'd3://JAL imm26({pc[31:28],imm26,00})
        begin
          if (DEBUG) $display("DE_JAL") ;
          //GPR[31] = PC + 32'd4;
          GPR[31] = PC;
          werf = 1'b1; warf = 5'd31;
          PC = {PC[31:28], instr_index, 2'b0};
          done = 1'b1;
        end

        'd4://BEQ rs,rt,offset(signed)
        begin
          if (DEBUG) $display("DE_BEQ") ;
          target_offset = sign_extend_offset({offset, 2'b0});
          condition = (GPR[rs] == GPR[rt]);
          if (condition) 
            PC = PC + target_offset;
          done = 1'b1;
        end

        'd5://BNE rs,rt,offset(signed)
        begin
          if (DEBUG) $display("DE_BNE") ;
          target_offset = sign_extend_offset({offset, 2'b0});
          condition = (GPR[rs] != GPR[rt]);
          if (condition) 
            PC = PC + target_offset;
          done = 1'b1;
        end

        'd6://BLEZ rs,offset(signed)
        begin
          if (DEBUG) $display("DE_BLEZ") ;
          target_offset = sign_extend_offset({offset, 2'b0});
          condition = ($signed(GPR[rs]) <= 32'sb0);
          if (condition) 
            PC = PC + target_offset;
          done = 1'b1;
        end

        'd7://BGTZ rs,offset(signed)
        begin
          if (DEBUG) $display("DE_BGTZ") ;
          target_offset = sign_extend_offset({offset, 2'b0});
          condition = ($signed(GPR[rs]) > 32'sb0);
          if (condition) 
            PC = PC + target_offset;
          done = 1'b1;
        end

        'd8://ADDI rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_ADDI") ;
          temp = ADD(GPR[rs], sign_extend_immediate(immediate));
          if (temp[32] != temp[31])
            overflow = 1'b1;
          else if (rt != 0) begin
            GPR[rt] = temp[31:0];
            werf = 1'b1; warf = rt;
          end
          //zero = CalcZero(temp[31:0]);  
          done = 1'b1;
        end

        'd9://ADDIU rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_ADDIU") ;
          temp = ADD(GPR[rs], sign_extend_immediate(immediate));
          if (rt != 0) begin
            GPR[rt] = temp[31:0];
            werf = 1'b1; warf = rt;
          end
          //zero = CalcZero(temp[31:0]);  
          done = 1'b1;
        end

        'd10://SLTI rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_SLTI") ;
            $display("%d", $signed(GPR[rs]));
            $display("%d", $signed(sign_extend_immediate(immediate)));
          if ($signed(GPR[rs]) < $signed(sign_extend_immediate(immediate)))
            GPR[rt] = 32'b1;
          else
            GPR[rt] = 32'b0;
          werf = 1'b1; warf = rt;
          done = 1'b1;
        end

        'd11://SLTIU rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_SLTIU") ;
          if ({1'b0, GPR[rs]} < {1'b0, sign_extend_immediate(immediate)})
            GPR[rt] = 32'b1;
          else
            GPR[rt] = 32'b0;
          werf = 1'b1; warf = rt;
          done = 1'b1;
        end

        'd12://ANDI rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_ANDI") ;
          if (rt != 0) begin
            GPR[rt] = GPR[rs] & zero_extend_immediate(immediate);
            werf = 1'b1; warf = rt;
          end
          done = 1'b1;
        end

        'd13://ORI rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_ORI") ;
          if (rt != 0) begin
            GPR[rt] = GPR[rs] | zero_extend_immediate(immediate);
            werf = 1'b1; warf = rt;
          end
          done = 1'b1;
        end

        'd14://XORI rt,rs,imm16(singed)
        begin
          if (DEBUG) $display("DE_XORI") ;
          if (rt != 0) begin
            GPR[rt] = GPR[rs] ^ zero_extend_immediate(immediate);
            werf = 1'b1; warf = rt;
          end
          done = 1'b1;
        end

        'd15://LUI rt,imm16
        begin
          if (DEBUG) $display("DE_LUI") ;
          if (rt != 0) begin
            GPR[rt] = {immediate, 16'b0};
            werf = 1'b1; warf = rt;
          end
          done = 1'b1;
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
          wait(run_data);
          data_read = 1'b1;
          vaddr     = sign_extend_immediate(offset) + GPR[base];
          data_bwe  = 4'b0001 << vaddr[1:0];
          data_addr = vaddr;

          wait(data_ready);
          #(`PERIOD);
          data_read = 1'b0;
          memword = check_load_word(data);
          mybyte  = vaddr[1:0];
          if (rt != 0) begin
            GPR[rt] = sign_extend_byte(load_byte(memword, mybyte));
            werf = 1'b1; warf = rt;
          end
          done = 1'b1;
        end

        'd33://LH rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_LH") ;
          wait(run_data);
          data_read = 1'b1;
          data_bwe  = 4'b0011 << vaddr[1:0];
          vaddr = sign_extend_immediate(offset) + GPR[base];
          if (vaddr[0] != 1'b0) begin
            $display("LH memory address error");
            $stop;
          end
          data_addr = vaddr; 
          wait(data_ready);
          #(`PERIOD);
          data_read = 1'b0;
          memword = check_load_word(data);
          mybyte  = vaddr[1:0];
          if (rt != 0) begin
            GPR[rt] = sign_extend_immediate(load_hword(memword, mybyte));
            werf = 1'b1; warf = rt;
          end
          done = 1'b1;
        end

  //      'd34://LWL rt,offset(base) (offset:signed;base:rs)
  //      begin
  //	      if (DEBUG) $display("DE_LWL") ;
  //      end

        'd35://LW rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_LW");
          wait(run_data);
          data_read = 1'b1;
          data_bwe  = 4'b1111;
          vaddr   = sign_extend_immediate(offset) + GPR[base];
          if (vaddr[1:0] != 2'b0) begin
            $display("LW memory address error");
            $stop;
          end
          data_addr = vaddr; 
          wait(data_ready);
          #(`PERIOD);
          data_read = 1'b0;
          memword = check_load_word(data);
          if (rt != 0) begin
            GPR[rt] = memword;
            werf = 1'b1; warf = rt;
          end
          done = 1'b1;
        end

        'd36://LBU rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_LBU");
          wait(run_data);
          data_read = 1'b1;
          vaddr   = sign_extend_immediate(offset) + GPR[base];
          data_bwe  = 4'b0001 << vaddr[1:0];
          data_addr = vaddr; 
          wait(data_ready);
          #(`PERIOD);
          data_read = 1'b0;
          memword = check_load_word(data);
          mybyte  = vaddr[1:0];
          if (rt != 0) begin
            GPR[rt] = zero_extend_byte(load_byte(memword, mybyte));
            werf = 1'b1; warf = rt;
          end
          done = 1'b1;
        end

        'd37://LHU rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_LHU") ;
          wait(run_data);
          data_read = 1'b1;
          vaddr   = sign_extend_immediate(offset) + GPR[base];
          data_bwe  = 4'b0011 << vaddr[1:0];
          if (vaddr[0] != 1'b0) begin
            $display("LHU memory address error");
            $stop;
          end
          data_addr = vaddr; 
          wait(data_ready);
          #(`PERIOD);
          data_read = 1'b0;
          memword = check_load_word(data);
          mybyte  = vaddr[1:0];
          if (rt != 0) begin
            GPR[rt] = zero_extend_immediate(load_hword(memword, mybyte));
            werf = 1'b1; warf = rt;
          end
          done = 1'b1;
        end

  //      'd38://LWR rt,offset(base) (offset:signed;base:rs)
  //      begin
  //	      if (DEBUG) $display("DE_LWR") ;
  //      end

        'd40://SB rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_SB");
          wait(run_data);
          data_write = 1'b1;
          vaddr      = sign_extend_immediate(offset) + GPR[base];
          data_addr  = vaddr; 
          data_bwe   = 4'b0001 << vaddr[1:0];
          data_txd   = GPR[rt];
          wait(data_ready);
          #(`PERIOD);
          data_txd   = 32'hz;
          data_write = 1'b0;
          done = 1'b1;
        end

        'd41://SH rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_SH");
          wait(run_data);
          data_write = 1'b1;
          vaddr      = sign_extend_immediate(offset) + GPR[base];
          if (vaddr[0] != 1'b0) begin
            $display("SH memory address error");
            $stop;
          end
          data_addr  = vaddr; 
          data_bwe   = 4'b0011 << vaddr[1:0];
          data_txd   = GPR[rt];
          wait(data_ready);
          #(`PERIOD);
          data_txd   = 32'hz;
          data_write = 1'b0;
          done = 1'b1;
        end

  //      'd42://SWL rt,offset(base) (offset:signed;base:rs)
  //      begin
  //	      if (DEBUG) $display("DE_SWL ;
  //      end

        'd43://SW rt,offset(base) (offset:signed;base:rs)
        begin
          if (DEBUG) $display("DE_SW") ;
          wait(run_data);
          data_write = 1'b1;
          data_bwe   = 4'b1111;
          vaddr      = sign_extend_immediate(offset) + GPR[base];
          if (vaddr[1:0] != 2'b0) begin
            $display("SW memory address error");
            //$stop;
          end
          data_addr  = vaddr; 
          data_txd   = GPR[rt];
          wait(data_ready);
          #(`PERIOD);
          data_txd   = 32'hz;
          data_write = 1'b0;
          done = 1'b1;
        end

  //      'd46://SWR rt,offset(base) (offset:signed;base:rs)
  //      begin
  //	      if (DEBUG) $display("DE_SWR ;
  //      end

        default: 
        begin
          if (DEBUG) $display("DE_INVALID");
          done = 1'b1;
        end
      endcase
    end
  end

endmodule
