`include "MIPS1000_defines.v"

module TestBench;
  reg clk;
  reg rst;
  wire [`MEM_ADDR_WIDTH-1:0] abus1;
  wire [`MEM_ADDR_WIDTH-1:0] abus2;
  wire [31:0] dbus1;  
  wire [31:0] dbus2o;
  
  reg [5:0] i;

  // Instantiate top level module
  //PPS_Top Top(clk, rst, abus1, abus2, dbus1, dbus2o);
 
  reg [3:0] SW, KEY;

  // Test memory-mapped I/O operations
  DE2_Top Top
	(
		.CLOCK_50(clk),						//	50 MHz
		.CLOCK_27(clk),           //  27 MHz
		.SW(SW),								//	Toggle Switch[17:0]
		.KEY(KEY),
		.VGA_CLK(),   						//	VGA Clock
		.VGA_HS(),							//	VGA H_SYNC
		.VGA_VS(),							//	VGA V_SYNC
		.VGA_BLANK(),						//	VGA BLANK
		.VGA_SYNC(),						//	VGA SYNC
		.VGA_R(),   						//	VGA Red[9:0]
		.VGA_G(),	 						//	VGA Green[9:0]
		.VGA_B()  						  //	VGA Blue[9:0]
	);

  always #10 clk = ~clk;

  initial begin

    clk = 0;
    SW = 4'b0000;
    KEY = 4'b1111;
    #200;
    @(negedge clk);
    SW = 4'b0001;
    
    #3000;
    @(negedge clk);
    KEY = 4'b0111;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    KEY = 4'b1111;

    //$stop;
  end

  always @(posedge clk) 
  begin
    $display("------------- (time %d)", $time);
    for (i = 0; i < 32; i=i+1)
    begin
      if (i % 4 == 0 && i != 0) $display("");
      $write("regs[%2d] = %h    ", i, Top.Processor.ID.RegFile.RF_mem[i]);
    end
   
    $display("\n");
    $display("debug:  PC=%h", Top.Processor.IF.PC);
    $display("debug:  ID_instr=%h (op=%h rs=%d rt=%d rd=%d imm=%d) IFID_pc=%h",
    Top.Processor.IF_inst_out, Top.Processor.ID.Decoder.inst_op,
    Top.Processor.ID.Decoder.inst_rs, Top.Processor.ID.Decoder.inst_rt,
    Top.Processor.ID.Decoder.inst_rd, Top.Processor.ID.Decoder.inst_imm,   
    Top.Processor.IF_PC_out);

    $display("debug:  EX_op1=%h EX_op2=%h EX_rd=%h",
    Top.Processor.ID_MUXop1_out, Top.Processor.ID_MUXop2_out, Top.Processor.ID_inst_rd_out);
    
    $display("debug:  MEM_stdata=%h MEM_ALUout=%h MEM_rd=%d",
    Top.Processor.EX_STData_out, Top.Processor.EX_ALUOut_out, Top.Processor.EX_inst_rd_out);
    
    $display("debug:  WB_RF_Wdata=%h WB_rd=%d, WB_ren=%b",
    Top.Processor.WB_RF_Wdata_out, Top.Processor.WB_inst_rd_out, Top.Processor.WB_RegWrite_out);
    
    $display("debug:  Pstomp=%h", Top.Processor.ID_Pstomp_out);
    
    $display("\n\n");
  end
    
endmodule                     

