function [32:0] ADD;
  input [31:0] a, b;
  ADD = {a[31], a} + {b[31], b};
endfunction

function [32:0] SUB;
  input [31:0] a, b;
  SUB = {a[31], a} - {b[31], b};
endfunction

function CalcZero;
  input [31:0] result;
  CalcZero = {result == 32'd0} ? 1'b1 : 1'b0;
endfunction

function [31:0] sign_extend_immediate;
  input [15:0] immediate;
  sign_extend_immediate = {{16{immediate[15]}}, immediate};
endfunction

function [31:0] sign_extend_offset;
  input [17:0] offset;
  sign_extend_offset = {{14{offset[17]}}, offset};
endfunction

function [31:0] sign_extend_byte;
  input [7:0] imm8;
  sign_extend_byte = {{24{imm8[7]}}, imm8};
endfunction

function [31:0] zero_extend_immediate;
  input [15:0] imm16;
  zero_extend_immediate = {16'b0, imm16};
endfunction

function [31:0] zero_extend_byte;
  input [7:0] imm8;
  zero_extend_byte = {24'b0, imm8};
endfunction

function [15:0] load_hword;
  input [31:0] memword;
  input  [1:0] sel;
  reg   [15:0] temp;
  begin
    case(sel)
      2'b00:
        temp = memword[15:0];
      2'b10:
        temp = memword[31:16];
      default:
        temp = 16'bx;
    endcase
    load_hword = temp;
  end
endfunction

function [7:0] load_byte;
  input [31:0] memword;
  input  [1:0] sel;
  reg    [7:0] temp;
  begin
    case(sel)
      2'b00:
        temp = memword[7:0];
      2'b01:
        temp = memword[15:8];
      2'b10:
        temp = memword[23:16];
      2'b11:
        temp = memword[31:24];
      default:
        temp = 8'bx;
    endcase
    load_byte = temp;
  end
endfunction

function [31:0] store_byte;
  input [31:0] regword ;
  input [31:0] memword;
  input  [1:0] sel;
  reg   [31:0] temp;
  begin
    case(sel)
      2'b00:
        temp = {memword[31: 8], regword[7:0]};
      2'b01:
        temp = {memword[31:16], regword[7:0], memword[7:0]}; 
      2'b10:
        temp = {memword[31:24], regword[7:0], memword[15:0]}; 
      2'b11:
        temp = {regword[7:0], memword[23:0]}; 
      default:
        temp = 31'bx;
    endcase
    store_byte = temp;
  end
endfunction

function [31:0] store_hword;
  input [31:0] regword;
  input [31:0] memword;
  input  [1:0] sel;
  reg   [31:0] temp;
  begin
    case(sel[1:0])
      2'b00:
        temp = {memword[31:16], regword[15:0]};
      2'b10:
        temp = {regword[15:0], memword[15:0]};
      default:
        temp = 31'bx;
    endcase
    store_hword = temp;
  end
endfunction

function [31:0] mask_store_byte;
  input  [1:0] sel;
  reg   [31:0] temp;
  begin
    case(sel)
      2'b00:
        temp = 32'h000000ff; //{24'b0, regword[7:0]};
      2'b01:
        temp = 32'h0000ff00; //{emword[31:16], regword[7:0], memword[7:0]}; 
      2'b10:
        temp = 32'h00ff0000; //{memword[31:24], regword[7:0], memword[15:0]}; 
      2'b11:
        temp = 32'hff000000; //{regword[7:0], memword[23:0]}; 
      default:
        temp = 31'bx;
    endcase
    mask_store_byte = temp;
  end
endfunction

function [31:0] mask_store_hword;
  input  [1:0] sel;
  reg   [31:0] temp;
  begin
    case(sel[1:0])
      2'b00:
        temp = 32'h0000ffff; //{16'b0, regword[15:0]};
      2'b10:
        temp = 32'hffff0000; //{regword[15:0], 16'b0};
      default:
        temp = 31'bx;
    endcase
    mask_store_hword = temp;
  end
endfunction

function [127:0] check_HiZ;
  input [7:0] width;
  input [127:0] word;
  integer i;
  for (i = 0; i < width; i = i + 1) begin
    if (word[i] === 1'bz) begin
      $display("Error: in word %h word[%d] is high Z", word, i);
      $stop;
    end
  end
  check_HiZ = word;
endfunction

function [31:0] check_load_word;
  input [31:0] word;
  integer i;
  begin
    for (i = 0; i < 31; i = i + 1) begin
      if (word[i] === 1'bz) begin
        $display($time,, "Error: memory load data %h has highZ state", word);
        $stop;
      end
      if (word[i] === 1'bx) begin
        $display($time);
        $display("************************************************************");
        $display("   Warning: memory load data %h has xX state", word);
        $display("************************************************************");
        //$stop;
      end
    end
    check_load_word = word;
  end
endfunction
