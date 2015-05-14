`timescale 1ns/1ns

`define bs_ic_val   89
`define bs_ic_tag   88:64
`define bs_ic_word1 63:32
`define bs_ic_word0 31:0

`define bs_dc_val   89
`define bs_dc_tag   88:64
`define bs_dc_word1 63:32
`define bs_dc_word0 31:0

`define bs_rf_data  31:0
`define bs_rf_addr  36:32

`define bs_wb_tag_val   99
`define bs_wb_tag       98:72
`define bs_wb_word1_val 71:68
`define bs_wb_word0_val 67:64
`define bs_wb_word1     63:32
`define bs_wb_word0     31:0

module TestBench;

  `include "cache.h"

  reg clk;							//	50 MHz
  reg rst;
  reg sdram_rst;
  reg run_inst;
  reg run_data;


  parameter BUF_SIZE = 32;
  parameter BUF_ADDR_WIDTH = 5;

  reg [25+32+32:0] cache_inst_buffer [0 : BUF_SIZE-1];
  reg [25+32+32:0] cache_data_buffer [0 : BUF_SIZE-1];
  reg [25+32+32:0] cache_data_vector;
  reg inst_ready_buffer [0 : BUF_SIZE-1];
  reg data_ready_buffer [0 : BUF_SIZE-1];
  reg regfile_ready_buffer [0 : BUF_SIZE-1];
  reg wb_ready_buffer [0 : BUF_SIZE-1];

  reg [5+32:0] regfile_data_buffer [0 : BUF_SIZE-1];
  reg [5+32:0] regfile_data_vector;

  reg [1+27+4+4+32+32-1:0] wb_data_buffer [0 : BUF_SIZE-1];
  reg [1+27+4+4+32+32-1:0] wb_data_vector;


  reg [BUF_ADDR_WIDTH-1:0] ibuf_h, ibuf_t;
  reg [BUF_ADDR_WIDTH-1:0] dbuf_h, dbuf_t;
  reg [BUF_ADDR_WIDTH-1:0] wbbuf_h, wbbuf_t;
  reg [BUF_ADDR_WIDTH-1:0] rfbuf_h, rfbuf_t;
  reg [BUF_ADDR_WIDTH:0] ix;


  reg [4:0] rf_addr;
  reg [31:0] rf_data;
  reg [4:0] rf_warf;

  reg [`IC_INDEXSIZE : 0] i;  // d and i has same cache size
  reg [7:0] d13, d12, d11, d10;
  reg [7:0] d03, d02, d01, d00;
  reg [31:0] d1, d0; 
  reg [`ITAGSIZE-1:0] t;
  reg v;

  reg [26:0] wb_t;
  reg [3:0] v0, v1;
  reg v13, v12, v11, v10;
  reg v03, v02, v01, v00;
  reg tv; 

  `include "mips_utils.v"

  test_beh DUT_BEH (clk, rst, run_inst, run_data, done);

  test_rtl DUT_RTL (clk, rst, sdram_rst);

  always #10 clk = ~clk;

  initial begin

    //----------------------------------------------
    // Test processor(beh) + caches(beh) + memory(beh)
    //----------------------------------------------
    //$readmemh("simpletest.txt", DUT_BEH.SRAM.sram );
    //$readmemh("loop.txt", DUT_BEH.SRAM.sram ); // runtime: ~123 us
    $readmemh("sdata_loop.txt", DUT_BEH.SRAM.sram ); // runtime: ~328 us
    //$readmemh("bubble_sort.txt", DUT_BEH.SRAM.sram ); // runtime: ~3037886 ns 
    //$readmemh("writebuffer_test.txt", DUT_BEH.SRAM.sram ); // runtime: 
    //$readmemh("writebuffer_test1.txt", DUT_BEH.SRAM.sram ); // runtime: 
    //$readmemh("memory.txt", DUT_BEH.SRAM.sram ); // runtime: 
    
    //----------------------------------------------
    // Test processor(rtl) + caches(rtl) + memory(rtl)
    //----------------------------------------------
    //$readmemh("simpletest.txt", DUT_RTL.m0.Bank0);
    //$readmemh("loop.txt", DUT_RTL.m0.Bank0);
    $readmemh("sdata_loop.txt", DUT_RTL.m0.Bank0);
    //$readmemh("bubble_sort.txt", DUT_RTL.m0.Bank0);
    //$readmemh("writebuffer_test.txt", DUT_RTL.m0.Bank0);
    //$readmemh("writebuffer_test1.txt", DUT_RTL.m0.Bank0);
    //$readmemh("memory.txt", DUT_RTL.m0.Bank0);

    clk = 1;
    rst = 1; 
    sdram_rst = 0; 

    ibuf_h = 0; ibuf_t = 0; 
    dbuf_h = 0; dbuf_t = 0;
    rfbuf_h = 0; rfbuf_t = 0;
    wbbuf_h = 0; wbbuf_t = 0;
    run_inst = 0; 
    run_data = 1;

    for (ix = 0; ix < BUF_SIZE; ix = ix + 1) begin
      inst_ready_buffer[ix] = 1'b0;
      data_ready_buffer[ix] = 1'b0;
      regfile_ready_buffer[ix] = 1'b0;
      wb_ready_buffer[ix] = 1'b0;
    end

    #100
    sdram_rst = 1; 

    // Wait for SDRAM initialization
    #99500

    // start rtl model
    rst = 0;  
  end

  //wire empty = (dbuf_h == dbuf_t) & ~data_ready_buffer[dbuf_h];
  //wire full  = (dbuf_h == dbuf_t) & data_ready_buffer[dbuf_h];

  //=====================================================================
  //
  // master: rtl model
  // slave: beh model
  //
  // After master execute an instruction, it puts the instruction cache
  // contents and data cache contents(if any) in the instruction and
  // data buffer. If the instruction buffer is not empty, then the beh model
  // is started to execute the instruction. If the instruction is a memory
  // instruction, then the beh model's memory operation will not be started 
  // until the data buffer is not empty.
  //
  //=====================================================================

  // run_inst generator
  always @(negedge clk) begin
    //============================================================
    // beh model has executed an instruction
    //============================================================
    if (run_inst && done) begin
      run_inst <= 1'b0; 
    end
    else if (inst_ready_buffer[ibuf_t] && !done) begin
    //============================================================
    // start beh model for any unexecuted instruction in the buffer
    //============================================================
      run_inst <= 1'b1;
    end
  end

  // run_data generator
  always @(negedge clk) begin
    //============================================================
    // There are pending data cache RAMS(rtl) for beh model to execute
    // the memory instruction
    //============================================================
    if (run_inst && !done) begin
      if  (data_ready_buffer[dbuf_t]) 
          run_data <= 1'b1; 
        else 
          run_data <= 1'b0;
    end
    else run_data <= 1'b0;
  end
  
  //==================================================================
  // compare instruction cache RAMs(beh) with RAMs(rtl) in the buffer
  //==================================================================
  always  @(negedge clk) begin

    if (DUT_RTL.Processor.inst_ready) begin
      if (inst_ready_buffer[ibuf_h]) begin
        $display("***** ibuf full ***** "); $stop;
      end

      i   = DUT_RTL.ICache.DAddress[`IINDEX];
      d13 = DUT_RTL.ICache.DataRam_D13.DataRam[i];
      d12 = DUT_RTL.ICache.DataRam_D12.DataRam[i]; 
      d11 = DUT_RTL.ICache.DataRam_D11.DataRam[i]; 
      d10 = DUT_RTL.ICache.DataRam_D10.DataRam[i];
      d03 = DUT_RTL.ICache.DataRam_D03.DataRam[i]; 
      d02 = DUT_RTL.ICache.DataRam_D02.DataRam[i]; 
      d01 = DUT_RTL.ICache.DataRam_D01.DataRam[i]; 
      d00 = DUT_RTL.ICache.DataRam_D00.DataRam[i];
      t   = DUT_RTL.ICache.TagRam.TagRam[i];
      v   = DUT_RTL.ICache.ValidRam.ValidBits[i];

      inst_ready_buffer[ibuf_h] = 1'b1;
      cache_inst_buffer[ibuf_h] = {v, t, d13, d12, d11, d10, 
                                           d03, d02, d01, d00};
      ibuf_h   = ibuf_h + 1;

    end

    if (DUT_BEH.Processor.inst_ready) begin

      if (!inst_ready_buffer[ibuf_t]) begin
        $display("***** ibuf empty ***** "); $stop;
      end

      $display("check instruction cache entry at ibuf_t %d", ibuf_t);
      cache_data_vector = cache_inst_buffer[ibuf_t];

      d1 = cache_data_vector[`bs_ic_word1]; 
      d0 = cache_data_vector[`bs_ic_word0];
      t  = cache_data_vector[`bs_ic_tag];
      v  = cache_data_vector[`bs_ic_val];

      i  = DUT_BEH.Processor.inst_addr[`IINDEX];
      if (DUT_BEH.icache.tag[i]   !== t  || 
          DUT_BEH.icache.valid[i] !== v  ||
          DUT_BEH.icache.ram1[i]  !== d1 ||
          DUT_BEH.icache.ram0[i]  !== d0) 
      begin
        $display($time,,
        "Inst Cache line %d: (BEH) %b %h %h %h <-> (RTL) %b %h %h %h", i,
         DUT_BEH.icache.valid[i], 
         DUT_BEH.icache.tag[i],  
         DUT_BEH.icache.ram1[i],
         DUT_BEH.icache.ram0[i], 
         v, t, d1, d0);
        $stop;
      end
      inst_ready_buffer[ibuf_t] <= 1'b0;
      ibuf_t   <= ibuf_t + 1;
    end
  end


  //==========================================================
  // compare data cache RAMs(beh) with RAMs(rtl) in the buffer
  //==========================================================
  always  @(negedge clk) begin

    // save data cache RAMs(rtl) in the buffer
    if (DUT_RTL.Processor.data_ready) begin
        if (data_ready_buffer[dbuf_h]) begin
          $display("***** dbuf full ***** "); $stop;
        end

        i   = DUT_RTL.DCache.DAddress[`DINDEX];
        d13 = DUT_RTL.DCache.DataRam_D13.DataRam[i];
        d12 = DUT_RTL.DCache.DataRam_D12.DataRam[i]; 
        d11 = DUT_RTL.DCache.DataRam_D11.DataRam[i]; 
        d10 = DUT_RTL.DCache.DataRam_D10.DataRam[i];
        d03 = DUT_RTL.DCache.DataRam_D03.DataRam[i]; 
        d02 = DUT_RTL.DCache.DataRam_D02.DataRam[i]; 
        d01 = DUT_RTL.DCache.DataRam_D01.DataRam[i]; 
        d00 = DUT_RTL.DCache.DataRam_D00.DataRam[i];
        t   = DUT_RTL.DCache.TagRam.TagRam[i];
        v   = DUT_RTL.DCache.ValidRam.ValidBits[i];
        $display($time,, "debug: d13 = %h", d13);

        data_ready_buffer[dbuf_h] = 1'b1;
        cache_data_buffer[dbuf_h] = {v, t, d13, d12, d11, d10, 
                                             d03, d02, d01, d00};
        dbuf_h = dbuf_h + 1;


  //==========================================================
  // compare WB RAMs(beh) with RAMs(rtl) in the buffer
  //==========================================================
      if (wb_ready_buffer[wbbuf_h]) begin
        $display("***** wbbuf full ***** "); $stop;
      end

      i     = DUT_RTL.DCache.DAddress[`WB_INDEX];
      tv    = DUT_RTL.DCache.WriteBuffer.wb_tv.wb_val[i];
      wb_t  = DUT_RTL.DCache.WriteBuffer.wb_t.wb_tag[i];
      v13   = DUT_RTL.DCache.WriteBuffer.wb_v7.wb_val[i]; 
      d13   = DUT_RTL.DCache.WriteBuffer.wb_m7.wb_mem[i];
      v12   = DUT_RTL.DCache.WriteBuffer.wb_v6.wb_val[i];
      d12   = DUT_RTL.DCache.WriteBuffer.wb_m6.wb_mem[i];
      v11   = DUT_RTL.DCache.WriteBuffer.wb_v5.wb_val[i];
      d11   = DUT_RTL.DCache.WriteBuffer.wb_m5.wb_mem[i];
      v10   = DUT_RTL.DCache.WriteBuffer.wb_v4.wb_val[i];
      d10   = DUT_RTL.DCache.WriteBuffer.wb_m4.wb_mem[i];
      v03   = DUT_RTL.DCache.WriteBuffer.wb_v3.wb_val[i];
      d03   = DUT_RTL.DCache.WriteBuffer.wb_m3.wb_mem[i];
      v02   = DUT_RTL.DCache.WriteBuffer.wb_v2.wb_val[i];
      d02   = DUT_RTL.DCache.WriteBuffer.wb_m2.wb_mem[i];
      v01   = DUT_RTL.DCache.WriteBuffer.wb_v1.wb_val[i];
      d01   = DUT_RTL.DCache.WriteBuffer.wb_m1.wb_mem[i];
      v00   = DUT_RTL.DCache.WriteBuffer.wb_v0.wb_val[i];
      d00   = DUT_RTL.DCache.WriteBuffer.wb_m0.wb_mem[i];

      wb_ready_buffer[wbbuf_h] = 1'b1;
      wb_data_buffer[wbbuf_h]  = {  tv, wb_t, 
                                    v13, v12, v11, v10, 
                                    v03, v02, v01, v00,
                                    d13, d12, d11, d10, 
                                    d03, d02, d01, d00};
      wbbuf_h = wbbuf_h + 1;
    end  //if (DUT_RTL.Processor.data_ready) begin


    if (DUT_BEH.Processor.data_ready) begin

      if (!data_ready_buffer[dbuf_t]) begin
        $display("***** dbuf empty ***** "); $stop;
      end

      $display("check data cache entry at dbuf %d...", dbuf_t);
      cache_data_vector = cache_data_buffer[dbuf_t];
      data_ready_buffer[dbuf_t] = 1'b0;
      dbuf_t = dbuf_t + 1;

      d1 = cache_data_vector[`bs_dc_word1]; 
      d0 = cache_data_vector[`bs_dc_word0];
      t  = cache_data_vector[`bs_dc_tag];
      v  = cache_data_vector[`bs_dc_val];
      i  = DUT_BEH.Processor.data_addr[`DINDEX];

      if (DUT_BEH.dcache.tag[i]   !== t  ||
          DUT_BEH.dcache.valid[i] !== v  ||
          DUT_BEH.dcache.ram1[i]  !== d1 ||
          DUT_BEH.dcache.ram0[i]  !== d0) begin
        $display($time,,
        "Error: Data Cache line %d: (BEH) %b %h %h %h <-> (RTL) %b %h %h %h", i,
        DUT_BEH.dcache.valid[i],
        DUT_BEH.dcache.tag[i],  
        DUT_BEH.dcache.ram1[i],
        DUT_BEH.dcache.ram0[i], 
        v, t, d1, d0);
        $stop;
      end

      if (!wb_ready_buffer[wbbuf_t]) begin
        $display("***** wbbuf empty ***** "); $stop;
      end

      $display("check wb entry at wbbuf %d...", wbbuf_t);
      wb_data_vector = wb_data_buffer[wbbuf_t];
      wb_ready_buffer[wbbuf_t] = 1'b0;
      wbbuf_t = wbbuf_t + 1;

      d1 = wb_data_vector[`bs_wb_word1]; 
      d0 = wb_data_vector[`bs_wb_word0];
      v1 = wb_data_vector[`bs_wb_word1_val];
      v0 = wb_data_vector[`bs_wb_word0_val];
      wb_t = wb_data_vector[`bs_wb_tag];
      tv = wb_data_vector[`bs_wb_tag_val];

      i  = DUT_BEH.Processor.data_addr[`WB_INDEX];

      if (DUT_BEH.dcache.wb_tag_val[i]  !== tv ||
          DUT_BEH.dcache.wb_tag[i]      !== wb_t  ||
          DUT_BEH.dcache.wb_ram1_val[i] !== v1 ||
          DUT_BEH.dcache.wb_ram0_val[i] !== v0 ||
          DUT_BEH.dcache.wb_ram1[i]     !== d1 ||
          DUT_BEH.dcache.wb_ram0[i]     !== d0) begin
        $display($time,,
        "Error: Write buffer line %d: (BEH) %b-%h %b-%h %b-%h  <-> (RTL) %b-%h %b-%h %b-%h",
        i,
        DUT_BEH.dcache.wb_tag_val[i],  
        DUT_BEH.dcache.wb_tag[i],  
        DUT_BEH.dcache.wb_ram1_val[i],
        DUT_BEH.dcache.wb_ram1[i],
        DUT_BEH.dcache.wb_ram0_val[i],
        DUT_BEH.dcache.wb_ram0[i], 
        tv, wb_t, v1, d1, v0, d0);
        $stop;
      end
    end // if (DUT_BEH.Processor.data_ready) begin
  end

 //==========================================================
 // compare register file write address and data (beh) with 
 // those in the buffer
 //==========================================================
  always  @(negedge clk) begin

    if (DUT_RTL.Processor.ID.RegFile.Wen && 
        DUT_RTL.Processor.ID.RegFile.Wa != 0) begin

      if (regfile_ready_buffer[rfbuf_h]) begin
        $display("***** regfile buf full ***** "); $stop;
      end

      rf_addr = DUT_RTL.Processor.ID.RegFile.Wa;
      rf_data = DUT_RTL.Processor.ID.RegFile.Wd;
      regfile_ready_buffer[rfbuf_h] = 1'b1;
      regfile_data_buffer[rfbuf_h]  = {rf_addr, rf_data};
      rfbuf_h = rfbuf_h + 1;
    end

    if (DUT_BEH.Processor.werf) begin

      if (!regfile_ready_buffer[rfbuf_t]) begin
        $display("***** rfbuf empty ***** "); $stop;
      end

      $display($time,,"check register file entry rfbuf %d...", rfbuf_t);
      regfile_data_vector = regfile_data_buffer[rfbuf_t];
      regfile_ready_buffer[rfbuf_t] = 1'b0;
      rfbuf_t = rfbuf_t + 1;

      rf_addr = regfile_data_vector[`bs_rf_addr];
      rf_data = regfile_data_vector[`bs_rf_data]; 

      rf_warf = DUT_BEH.Processor.warf;
      if (rf_warf !== rf_addr || DUT_BEH.Processor.GPR[rf_warf] !== rf_data) 
      begin
        $display($time,, "register file entry: (BEH) %d %h <-> (RTL) %d %h ",
        rf_warf, DUT_BEH.Processor.GPR[rf_warf], rf_addr, rf_data);
        $stop;
      end
    end
  end

endmodule 
