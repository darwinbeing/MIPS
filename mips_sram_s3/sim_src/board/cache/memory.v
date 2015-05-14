`include "MIPS1000_defines.v"


module memory 
#( parameter ADDR_WIDTH = `MEM_ADDR_WIDTH-1,
             MEM_SIZE    = `MEM_SIZE,
             MEM_WIDTH   = 16 /* x16 DRAM */)
(
  input                clk,
  input                cs,
  input                rwbar,
  input [ADDR_WIDTH:0] adbus,
  inout [31:0]         databus
);
  
  reg [MEM_WIDTH-1:0] bus;
  reg [MEM_WIDTH-1:0] sram [0:MEM_SIZE - 1];
  reg oe;

  function [MEM_WIDTH-1:0] check_mem_word;
    input [MEM_WIDTH-1:0] word;
    integer i;
    begin
      for (i = 0; i < MEM_WIDTH; i = i + 1) begin
        if (word[i] == 1'bz || word[i] == 1'bZ) begin
          $display($time,, "Error in memory.v: memory data %h has highZ state", word);
          $stop;
        end
        /*
        if (word[i] == 1'bx || word[i] == 1'bX) begin
          $display($time,, "Warning: memory data %h has xX state", word);
        end
        */
      end
      check_mem_word = word;
    end
  endfunction

  /*
  initial begin : initialize_memory
    integer i;
    for (i = 0; i < MEM_SIZE; i = i + 1)
      sram[i] = {MEM_WIDTH{1'b0}};
  end
  */

  // #((MEM_DELAY-1) * (2 * `HCYCLE)) 
  always @ (posedge clk) begin
    if (cs) begin
      if (rwbar) begin
        bus <= check_mem_word(sram[adbus]);
        oe  <= 1'b1;
      end
      else begin
        bus         <= {MEM_WIDTH{1'bz}};
        sram[adbus] <= check_mem_word(databus[MEM_WIDTH-1:0]);
        oe          <= 1'b0;
      end
    end
    else begin
      bus <= {MEM_WIDTH{1'bz}};
      oe  <= 1'b0;
    end
  end 

  assign databus = oe ? {{(32-MEM_WIDTH){1'bz}}, bus} : 32'hz;
  
endmodule
  

