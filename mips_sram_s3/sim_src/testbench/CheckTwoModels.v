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
  reg [31:0] mdata;

  `include "mips_utils.v"

  // Instantiate top level module
  PPS_Top    mips_rtl(clk, rst, abus1, abus2, dbus1, dbus2o);
  mips_behav mips_beh(clk, rst, run);

  always #`CYCLE clk = ~clk;

  initial begin
    run = 0;
    start = 0;
    clk = 0;
    rst = 0;
    @(negedge clk);
    rst = 1;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    rst = 0;

    // Test two-model check after reset is asserted again 
    /*
    #270;
    @(negedge clk);
    rst = 1;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    rst = 0;

    #1430; // try 1430
    @(negedge clk);
    rst = 1;
    @(negedge clk);
    rst = 0;
    */

    //#43000;
    //$stop;
  end

 always @ (negedge clk) begin
   if (mips_rtl.Processor.Test_Sync.check_en) begin

     // Calls the behavioral model to check the machine states
     run = 1;

     // Wait half a period for the behavioral model to execute the instruction
     #(`CYCLE);

     // Dump current PC value
     $write($time,, "PC(beh) = %h   ", mips_beh.CPC);

     // Check machine states 
     if (mips_beh.CPC != mips_rtl.Processor.Test_Sync.check_pc) begin
       $display($time,, "PC mismatch");
       $display("%h(beh) <-> %h(rtl)", mips_beh.CPC, mips_rtl.Processor.Test_Sync.check_pc);
       $stop;
     end

     for (i = 0; i < 32; i=i+1) begin
       if (mips_beh.GPR[i] != mips_rtl.Processor.ID.RegFile.RF_mem[i]) begin
         $display($time,, "register %d mismatch: ", i);
         $stop;
       end
     end

     if (mips_beh.inst_decode == `DE__SB || 
         mips_beh.inst_decode == `DE__SH || 
         mips_beh.inst_decode == `DE__SW) begin

       if (mips_beh.vaddr != mips_rtl.Processor.Test_Sync.check_addr) begin
           $display($time,, "memory address mismatch: ");
           $display("%h(beh) <-> %h(rtl)", mips_beh.vaddr, mips_rtl.Processor.Test_Sync.check_addr);
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
         mdata = mask_store_hword(mips_beh.bytesel) & 
                 mips_rtl.Processor.Test_Sync.check_data;
         if (mips_beh.mdata != mdata) begin
             $display($time,, "halfword write data mismatch: ");
             $display("%h(beh) <-> %h(rtl)", mips_beh.mdata, mdata);
             $stop;
         end
       end

       // byte
       if  (mips_beh.inst_decode == `DE__SB) begin
         mdata = mask_store_byte(mips_beh.bytesel) & 
                 mips_rtl.Processor.Test_Sync.check_data;
         if (mips_beh.mdata != mdata) begin
             $display($time,, "byte write data mismatch: ");
             $display("%h(beh) <-> %h(rtl)", mips_beh.mdata, mdata);
             $stop;
         end
       end
     end
     run = 0;
   end
 end
    
endmodule                     

