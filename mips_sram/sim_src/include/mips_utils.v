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
  input [7:0] byte;
  sign_extend_byte = {{24{byte[7]}}, byte};
endfunction

function [31:0] zero_extend_immediate;
  input [15:0] immediate;
  zero_extend_immediate = {16'b0, immediate};
endfunction

function [31:0] zero_extend_byte;
  input [7:0] byte;
  zero_extend_byte = {24'b0, byte};
endfunction

function [15:0] load_hword;
  input [31:0] memword;
  input  [1:0] byte;
  reg   [15:0] temp;
  begin
    case(byte)
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
  input  [1:0] byte;
  reg    [7:0] temp;
  begin
    case(byte)
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
