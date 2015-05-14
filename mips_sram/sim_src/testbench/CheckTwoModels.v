`include "MIPS1000_defines.v"

module CheckTwoModels;
  reg clk;
  reg rst;
  reg start;
  reg run;
  wire [`MEM_ADDR_WIDTH-1:0] abus1;
  wire [`MEM_ADDR_WIDTH-1:0] abus2;
  wire [31:0] dbus1;  
  wire [31:0] dbus2o;
  
  reg [10:0] i;


  // Instantiate top level module
  PPS_Top    mips_rtl(clk, rst, abus1, abus2, dbus1, dbus2o);
  mips_behav mips_beh(run);

  always #`CYCLE clk = ~clk;

  initial begin
    run = 0;
    start = 0;
    clk = 0;
    rst = 0;
    @(negedge clk);
    rst = 1;
    @(negedge clk);
    rst = 0;

    // PC(rtl) reset to zero
    @(posedge clk);
    start <= 1;  
    
    //#43000;
    //$stop;
  end

 always @ (posedge clk) begin
   if (start && !mips_rtl.Processor.IF.pcwe) begin
     $write($time,, "PC(beh) = %h   ", mips_beh.PC);

     // The rtl model has executed an instruction and 
     // testbench calls the behavioral model
     run = 1;

     // Wait for the behavioral model to execute the instruction
     #(`CYCLE); 


     // Check machine states 
     //$display("Checking PC...");
     if (mips_beh.PC != mips_rtl.Processor.IF.PC) begin
       $write($time,, "PC mismatch ");
       $display("%h(beh) <-> %h(rtl)", mips_beh.PC, mips_rtl.Processor.IF.PC);
       $stop;
     end

     //$display("Checking register file...");
     for (i = 0; i < 32; i=i+1) begin
       // Debug behavioral model
       if (mips_beh.GPR[i] == 32'bx) begin
         $display("Register %d content undefined %h", i, mips_beh.GPR[i]);
         $stop;
       end

       if (mips_beh.GPR[i] != mips_rtl.Processor.ID.RegFile.RF_mem[i]) begin
         $write($time,, "register %d mismatch ", i);
         $display("%h(beh) <-> %h(rtl)", mips_beh.GPR[i], mips_rtl.Processor.ID.RegFile.RF_mem[i]);
         $stop;
       end
     end

     if (mips_beh.inst_decode == `DE__SB || mips_beh.inst_decode == `DE__SH || 
         mips_beh.inst_decode == `DE__SW) begin
       //$display("Checking memory data address...");
       if (mips_beh.vaddr != mips_rtl.Processor.data_addr) begin
         $write($time,, "memory data address mismatch  ");
         $display("%h(beh) <-> %h(rtl)", mips_beh.vaddr, mips_rtl.Processor.data_addr);
         $stop;
       end
 
       //$display("Checking memory contents...");
       for (i = 0; i < `MEM_SIZE; i=i+1) begin
         if (mips_beh.memory[i] != 
           { mips_rtl.Memory.u3.alt3pram_component.u0.mem_data[i],
             mips_rtl.Memory.u2.alt3pram_component.u0.mem_data[i],
             mips_rtl.Memory.u1.alt3pram_component.u0.mem_data[i],
             mips_rtl.Memory.u0.alt3pram_component.u0.mem_data[i] }) begin
           $display($time,, "memory data mismatch at entry %d ", i);
           $stop;
         end
       end
     end
     run = 0;
   end
 end
    
endmodule                     

