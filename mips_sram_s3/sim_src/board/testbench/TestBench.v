`include "MIPS1000_defines.v"

module TestBench;
  reg clk;
  reg rst;
  wire hclk;
  wire [`MEM_ADDR_WIDTH-1:0] abus1;
  wire [`MEM_ADDR_WIDTH-1:0] abus2;
  wire [31:0] dbus1;  
  wire [31:0] dbus2i;
  wire [31:0] dbus2o;
  
  reg [`MEM_ADDR_WIDTH:0] i;
  reg [31:0] mdata;
  reg run;

  `include "mips_utils.v"

  // Instantiate top level module (cache + processor)
  PPS_Top Top(clk, rst, abus1, abus2, dbus1, dbus2i, dbus2o);

  //mips_behav mips_beh(clk, rst, run); 

  always #(`HCYCLE) clk = ~clk;

  initial begin
    

    // Test processor + caches + memory
    //$readmemh("SRAM.dat", Top.SRAM.sram );
    
    // Test processor + dma + caches + memory
    $readmemh("RAM.dat", Top.icache.ram);
    $readmemb("TAG.dat", Top.icache.tag);
    $readmemb("VALID.dat", Top.icache.valid);

    clk = 0;
    rst = 1;
    #100;
    rst = 1'b0;

    //$stop;
  end
 /*
 always @ (negedge clk) begin

   // --------------------------------------------------------------------------------
   // Check machine states enabled
   // --------------------------------------------------------------------------------
   if (Top.Test_Sync.check_en) begin

     // Calls the behavioral model to check the machine states
     run = 1;

     // Wait about half a period for the behavioral model to execute the instruction
     #(`CYCLE - 1);

     // --------------------------------------------------------------------------------
     // Check current PC
     // --------------------------------------------------------------------------------
     $display("Checking PC...");
     if (mips_beh.CPC != Top.Test_Sync.check_pc) begin
       $display($time,, "PC mismatch");
       $display("%h(beh) <-> %h(rtl)", mips_beh.CPC, Top.Test_Sync.check_pc);
       $stop;
     end

     // --------------------------------------------------------------------------------
     // Check register file contents
     // --------------------------------------------------------------------------------
     $display("Checking register file contents...");
     for (i = 0; i < 32; i=i+1) begin
       if (mips_beh.GPR[i] != Top.Processor.ID.RegFile.RF_mem[i]) begin
         $display($time,, "register %d mismatch: ", i);
         $stop;
       end
     end

     // --------------------------------------------------------------------------------
     // Check memory alignment and memory address
     // --------------------------------------------------------------------------------
     if (mips_beh.inst_decode == `DE__SB || 
         mips_beh.inst_decode == `DE__SH || 
         mips_beh.inst_decode == `DE__SW) begin
     if (mips_beh.vaddr != Top.Test_Sync.check_addr) begin
           $display($time,, "memory address mismatch: ");
           $display("%h(beh) <-> %h(rtl)", mips_beh.vaddr, Top.Test_Sync.check_addr);
           $stop;
       end

       // word
       if  (mips_beh.inst_decode == `DE__SW) begin
         if (mips_beh.mdata != mdata) begin
           $display($time,, "word write data mismatch: ");
           $display("%h(beh) <-> %h(rtl)", mips_beh.mdata, mdata);
           $stop;
         end
       end

       // halfword
       if  (mips_beh.inst_decode == `DE__SH) begin
         mdata = mask_store_hword(mips_beh.bytesel) & Top.Test_Sync.check_data;
         if (mips_beh.mdata != mdata) begin
             $display($time,, "halfword write data mismatch: ");
             $display("%h(beh) <-> %h(rtl)", mips_beh.mdata, mdata);
             $stop;
         end
       end

       // byte
       if  (mips_beh.inst_decode == `DE__SB) begin
         mdata = mask_store_byte(mips_beh.bytesel) & Top.Test_Sync.check_data;
         if (mips_beh.mdata != mdata) begin
             $display($time,, "byte write data mismatch: ");
             $display("%h(beh) <-> %h(rtl)", mips_beh.mdata, mdata);
             $stop;
         end
       end
     end

     // --------------------------------------------------------------------------------
     // Check memory directly for a write-thru cache 
     // --------------------------------------------------------------------------------
     $display("Checking memory...");
     for (i = 0; i < `MEM_SIZE; i=i+1) begin
       if (mips_beh.memory[i] != Top.memory.sram[i]) begin
         $display($time,, "memory data mismatch at entry %d ", i);
         $display("%h(beh) <-> %h(sram)", mips_beh.memory[i], Top.memory.sram[i]);
         $stop; 
       end
     end
     run = 0;
   end
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
   */ 
endmodule                     
