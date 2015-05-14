// When any of the four addresses are detected, the active output becomes '1'
module addr_decode (
  input     [31:0] adbus,
  output reg       active, 
  output reg [3:0] select);

  // range A000_0000 - BFFF_FFFF
  parameter adbus_mask = 32'hAFFF_FFC0;

  always @ (adbus) begin
    if ((adbus_mask & adbus) == adbus_mask) begin
      active = 1'b1;
      case (adbus[5:2])  // byte address aligned
        // 0 - cregs[0]
        4'b1100: select = 4'b0001; 
        // 4 - cregs[1]
        4'b1101: select = 4'b0010;
        // 8 - cregs[2]
        4'b1110: select = 4'b0100;
        // C - cregs[3]
        4'b1111: select = 4'b1000;
        default : select = 4'b0000;
      endcase
    end
    else begin
      active = 1'b0;
      select = 4'b0000;
    end
  end
endmodule 
  
