// Testbench for Micron SDR SDRAM Verilog models

`timescale 1ns / 100ps

module test;

reg         [15 : 0] dq;                            // SDRAM I/O
reg         [11 : 0] addr;                          // SDRAM Address
reg          [1 : 0] ba;                            // Bank Address
reg                  clk;                           // Clock
reg                  cke;                           // Synchronous Clock Enable
reg                  cs_n;                          // CS#
reg                  ras_n;                         // RAS#
reg                  cas_n;                         // CAS#
reg                  we_n;                          // WE#
reg          [1 : 0] dqm;                           // I/O Mask

wire        [15 : 0] DQ = dq;

parameter            hi_z = 16'bz;                  // Hi-Z

parameter            tCK = 7;                       // Clock Period

mt48lc8m16a2 sdram0 (DQ, addr, ba, clk, cke, cs_n, ras_n, cas_n, we_n, dqm);

initial begin
    clk = 1'b0;
    cke = 1'b0;
    cs_n = 1'b1;
    dq  = hi_z;
end

always #3.5 clk = ~clk;

/*
always @ (posedge clk) begin
    $strobe("at time %t clk=%b cke=%b CS#=%b RAS#=%b CAS#=%b WE#=%b dqm=%b addr=%b ba=%b DQ=%d",
            $time, clk, cke, cs_n, ras_n, cas_n, we_n, dqm, addr, ba, DQ);
end
*/

task active;
    input  [1 : 0] bank;
    input [11 : 0] row;
    input [15 : 0] dq_in;
    begin
        cke   = 1;
        cs_n  = 0;
        ras_n = 0;
        cas_n = 1;
        we_n  = 1;
        dqm   = 0;
        ba    = bank;
        addr  = row;
        dq    = dq_in;
    end
endtask

task auto_refresh;
    begin
        cke   = 1;
        cs_n  = 0;
        ras_n = 0;
        cas_n = 0;
        we_n  = 1;
        dqm   = 0;
        //ba    = 0;
        //addr  = 0;
        dq    = hi_z;
    end
endtask

task burst_term;
    input [15 : 0] dq_in;
    begin
        cke   = 1;
        cs_n  = 0;
        ras_n = 1;
        cas_n = 1;
        we_n  = 0;
        dqm   = 0;
        //ba    = 0;
        //addr  = 0;
        dq    = dq_in;
    end
endtask

task load_mode_reg;
    input [13 : 0] op_code;
    begin
        cke   = 1;
        cs_n  = 0;
        ras_n = 0;
        cas_n = 0;
        we_n  = 0;
        dqm   = 0;
        ba    = op_code [13 : 12];
        addr  = op_code [11 :  0];
        dq    = hi_z;
    end
endtask

task nop;
    input  [1 : 0] dqm_in;
    input [15 : 0] dq_in;
    begin
        cke   = 1;
        cs_n  = 0;
        ras_n = 1;
        cas_n = 1;
        we_n  = 1;
        dqm   = dqm_in;
        //ba    = 0;
        //addr  = 0;
        dq    = dq_in;
    end
endtask

task precharge_bank_0;
    input  [1 : 0] dqm_in;
    input [15 : 0] dq_in;
    begin
        cke   = 1;
        cs_n  = 0;
        ras_n = 0;
        cas_n = 1;
        we_n  = 0;
        dqm   = dqm_in;
        ba    = 0;
        addr  = 0;
        dq    = dq_in;
    end
endtask

task precharge_bank_1;
    input  [1 : 0] dqm_in;
    input [15 : 0] dq_in;
    begin
        cke   = 1;
        cs_n  = 0;
        ras_n = 0;
        cas_n = 1;
        we_n  = 0;
        dqm   = dqm_in;
        ba    = 1;
        addr  = 0;
        dq    = dq_in;
    end
endtask

task precharge_bank_2;
    input  [1 : 0] dqm_in;
    input [15 : 0] dq_in;
    begin
        cke   = 1;
        cs_n  = 0;
        ras_n = 0;
        cas_n = 1;
        we_n  = 0;
        dqm   = dqm_in;
        ba    = 2;
        addr  = 0;
        dq    = dq_in;
    end
endtask

task precharge_bank_3;
    input  [1 : 0] dqm_in;
    input [15 : 0] dq_in;
    begin
        cke   = 1;
        cs_n  = 0;
        ras_n = 0;
        cas_n = 1;
        we_n  = 0;
        dqm   = dqm_in;
        ba    = 3;
        addr  = 0;
        dq    = dq_in;
    end
endtask

task precharge_all_bank;
    input  [1 : 0] dqm_in;
    input [15 : 0] dq_in;
    begin
        cke   = 1;
        cs_n  = 0;
        ras_n = 0;
        cas_n = 1;
        we_n  = 0;
        dqm   = dqm_in;
        ba    = 0;
        addr  = 1024;            // A10 = 1
        dq    = dq_in;
    end
endtask

task read;
    input  [1 : 0] bank;
    input [11 : 0] column;
    input [15 : 0] dq_in;
    input  [1 : 0] dqm_in;
    begin
        cke   = 1;
        cs_n  = 0;
        ras_n = 1;
        cas_n = 0;
        we_n  = 1;
        dqm   = dqm_in;
        ba    = bank;
        addr  = column;
        dq    = dq_in;
    end
endtask

task write;
    input  [1 : 0] bank;
    input [11 : 0] column;
    input [15 : 0] dq_in;
    input  [1 : 0] dqm_in;
    begin
        cke   = 1;
        cs_n  = 0;
        ras_n = 1;
        cas_n = 0;
        we_n  = 0;
        dqm   = dqm_in;
        ba    = bank;
        addr  = column;
        dq    = dq_in;
    end
endtask

initial begin
    begin
    // 1. Simultaneously apply power to VDD and VDDQ.
    // 2. Assert and hold CKE at a LVTTL logic LOW since all inputs and outputs are LVTTLcompatible.
    // 3. Provide stable CLOCK signal. Stable clock is defined as a signal cycling within timing
    // constraints specified for the clock pin.
    // 4. Wait at least 100¦Ìs prior to issuing any command other than a COMMAND INHIBIT
    // or NOP.
    // 5. Starting at some point during this 100¦Ìs period, bring CKE HIGH. Continuing at least
    // through the end of this period, one or more COMMAND INHIBIT or NOP commands
    // must be applied.
    // 6. Perform a PRECHARGE ALL command.
    // 7. Wait at least tRP time; during this time, NOPs or DESELECT commands must be
    // given. All banks will complete their precharge, thereby placing the device in the all
    // banks idle state.
    // 8. Issue an AUTO REFRESH command.
    // 9. Wait at least tRFC time, during which only NOPs or COMMAND INHIBIT commands
    // are allowed.
    // 10. Issue an AUTO REFRESH command.
    // 11. Wait at least tRFC time, during which only NOPs or COMMAND INHIBIT commands
    // are allowed.
    // 12. The SDRAM is now ready for mode register programming. Because the mode register
    // will power up in an unknown state, it should be loaded with desired bit values prior to
    // applying any operational command. Using the LMR command, program the mode
    // register. The mode register is programmed via the MODE REGISTER SET command
    // with BA1 = 0, BA0 = 0 and retains the stored information until it is programmed again
    // or the device loses power. Not programming the mode register upon initialization will
    // result in default settings, which may not be desired. Outputs are guaranteed High-Z
    // after the LMR command is issued. Outputs should be High-Z already before the LMR
    // command is issued.
    // 13. Wait at least tMRD time, during which only NOP or DESELECT commands are
    // allowed.

        // Initialize
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; precharge_all_bank(0, hi_z);      // Precharge ALL Bank
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; auto_refresh;                     // Auto Refresh
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; auto_refresh;                     // Auto Refresh
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; load_mode_reg (50);               // Load Mode: Lat = 3, BL = 4, Seq
        #tCK; nop    (0, hi_z);                 // Nop

        // Write with auto precharge to bank 0 (non-interrupt)
        #tCK; active (0, 0, hi_z);              // Active: Bank = 0, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; write  (0, 1024, 100, 0);         // Write : Bank = 0, Col = 0, Dqm = 0, Auto Precharge
        #tCK; nop    (0, 101);                  // Nop
        #tCK; nop    (0, 102);                  // Nop
        #tCK; nop    (0, 103);                  // Nop
        #tCK; nop    (0, hi_z);                 // Nop

        // Write with auto precharge to bank 1 (non-interrupt)
        #tCK; active (1, 0, hi_z);              // Active: Bank = 1, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; write  (1, 1024, 200, 0);         // Write : Bank = 1, Col = 0, Dqm = 0, Auto precharge
        #tCK; nop    (0, 201);                  // Nop
        #tCK; nop    (0, 202);                  // Nop
        #tCK; nop    (0, 203);                  // Nop
        #tCK; nop    (0, hi_z);                 // Nop

        // Write with auto precharge to bank 2 (non-interrupt)
        #tCK; active (2, 0, hi_z);              // Active: Bank = 2, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; write  (2, 1024, 300, 0);         // Write : Bank = 2, Col = 0, Dqm = 0, Auto Precharge
        #tCK; nop    (0, 301);                  // Nop
        #tCK; nop    (0, 302);                  // Nop
        #tCK; nop    (0, 303);                  // Nop
        #tCK; nop    (0, hi_z);                 // Nop

        // Write with auto precharge to bank 3 (non-interrupt)
        #tCK; active (3, 0, hi_z);              // Active: Bank = 3, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; write  (3, 1024, 400, 0);         // Write : Bank = 3, Col = 0, Dqm = 0, Auto precharge
        #tCK; nop    (0, 401);                  // Nop
        #tCK; nop    (0, 402);                  // Nop
        #tCK; nop    (0, 403);                  // Nop
        #tCK; nop    (0, hi_z);                 // Nop

        // Read with auto precharge to bank 0 (non-interrupt)
        #tCK; active (0, 0, hi_z);              // Active: Bank = 0, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; read   (0, 1024, hi_z, 0);        // Read  : Bank = 0, Col = 0, Dqm = 0, Auto precharge
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop

        // Read with auto precharge to bank 1 (non-interrupt)
        #tCK; active (1, 0, hi_z);              // Active: Bank = 1, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; read   (1, 1024, hi_z, 0);        // Read  : Bank = 1, Col = 0, Dqm = 0, Auto precharge
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop

        // Read with auto precharge to bank 2 (non-interrupt)
        #tCK; active (2, 0, hi_z);              // Active: Bank = 2, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; read   (2, 1024, hi_z, 0);        // Read  : Bank = 2, Col = 0, Dqm = 0, Auto precharge
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop

        // Read with auto precharge to bank 3 (non-interrupt)
        #tCK; active (3, 0, hi_z);              // Active: Bank = 3, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; read   (3, 1024, hi_z, 0);        // Read  : Bank = 3, Col = 0, Dqm = 0, Auto precharge
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop


        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // More tests
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        // Write 
        //  [1 : 0] bank;
        //  [11 : 0] column;
        //  [15 : 0] dq_in;
        //   [1 : 0] dqm_in;

        //================================================================================================
        // Write with precharge to bank 0 (non-interrupt)
        $display("Write with manual Precharge");
        //================================================================================================
        #tCK; active (0, 0, hi_z);              // Active: Bank = 0, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; write  (0, 0, 100, 0);            // Write : Bank = 0, Col = 0, Dqm = 0, Manual Precharge
        #tCK; nop    (0, 201);                  // Nop
        #tCK; nop    (0, 202);                  // Nop
        #tCK; nop    (0, 203);                  // Nop
        #tCK; write  (0, 4, 204, 0);            // Write : Bank = 0, Col = 4, Dqm = 0, Manual Precharge
        #tCK; nop    (0, 205);                  // Nop
        #tCK; nop    (0, 206);                  // Nop
        #tCK; nop    (0, 207);                  // Nop
        #tCK; write  (0, 8, 108, 0);            // Write : Bank = 0, Col = 8, Dqm = 0, Manual Precharge
        #tCK; nop    (0, 209);                  // Nop
        #tCK; nop    (0, 210);                  // Nop
        #tCK; nop    (0, 211);                  // Nop
        #tCK; write  (0, 12, 212, 0);            // Write : Bank = 0, Col = 12, Dqm = 0, Manual Precharge
        #tCK; nop    (0, 213);                  // Nop
        #tCK; nop    (0, 214);                  // Nop
        #tCK; nop    (0, 215);                  // Nop

        #tCK; nop    (0, hi_z);                 // Nop

        //================================================================================================
        // Similar to Figure 21: Write to Write
        $display("Write to Write");
        //================================================================================================
        #tCK; write  (0, 16, 216, 0);           // Write : Bank = 0, Col = 16, Wdata = 216, Dqm = 0, Manual Precharge
        #tCK; nop    (0, 217);                  // Nop
        #tCK; write  (0, 20, 220, 0);           // Write : Bank = 0, Col = 20, Wdata = 220, Dqm = 0, Manual Precharge
        #tCK; nop    (0, 221);                  // Nop
        #tCK; write  (0, 24, 224, 0);           // Write : Bank = 0, Col = 24, Wdata = 224, Dqm = 0, Manual Precharge
        #tCK; nop    (0, 225);                  // Nop
        #tCK; write  (0, 28, 228, 0);           // Write : Bank = 0, Col = 28, Wdata = 228, Dqm = 0, Manual Precharge
        #tCK; nop    (0, 229);                  // Nop

        //================================================================================================
        // Similar to Figure 22: Ramdom Write to the same column
        $display("Random Write to the same column");
        //================================================================================================
        #tCK; write  (0, 30, 230, 0);           // Write : Bank = 0, Col = 30, Wdata = 230, Dqm = 0, Manual Precharge
        #tCK; write  (0, 34, 234, 0);           // Write : Bank = 0, Col = 34, Wdata = 234, Dqm = 0, Manual Precharge
        #tCK; write  (0, 38, 238, 0);           // Write : Bank = 0, Col = 38, Wdata = 238, Dqm = 0, Manual Precharge
        #tCK; write  (0, 42, 242, 0);           // Write : Bank = 0, Col = 42, Wdata = 242, Dqm = 0, Manual Precharge
        #tCK; nop    (0, 243);                  // Nop:  Wdata 243 last valid write data
        //================================================================================================
        // Similar to Figure 23: Write-to-Read
        $display("Write-to-Read");
        //================================================================================================
        #tCK; nop    (0, 244);                  // Nop 
             read    (0, 0, hi_z, 0);           // Read  : Bank = 0, Col = 0, Dqm = 0, Manual precharge
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        //#tCK; precharge_bank_0(0, hi_z);      // Precharge: truncate the last desired data element 
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; precharge_bank_0(0, hi_z);        // Precharge  the last of a burst of four (last desired data - 2 )
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop


        //================================================================================================
        // Similar to Figure 13: Consecutive READ Bursts
        $display("Consecutive Read Bursts");
        //================================================================================================
        #tCK; active (0, 0, hi_z);              // Active: Bank = 0, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; read   (0, 0, hi_z, 0);           // Read  : Bank = 0, Col = 0, Dqm = 0, Manual precharge
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop

        #tCK; read   (0, 4, hi_z, 0);           // Read  : Bank = 0, Col = 4, Dqm = 0, Manual precharge
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop

        #tCK; read   (0, 8, hi_z, 0);           // Read  : Bank = 0, Col = 8, Dqm = 0, Manual precharge
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop

        //================================================================================================
        // Similar to Figure 14: Random READ Accesses
        $display("Random Read Accesses");
        //================================================================================================
        #tCK; read   (0, 12, hi_z, 0);          // Read  : Bank = 0, Col = 12, Dqm = 0, Manual precharge
        #tCK; read   (0, 16, hi_z, 0);          // Read  : Bank = 0, Col = 16, Dqm = 0, Manual precharge
        #tCK; read   (0, 20, hi_z, 0);          // Read  : Bank = 0, Col = 20, Dqm = 0, Manual precharge
        #tCK; read   (0, 24, hi_z, 0);          // Read  : Bank = 0, Col = 24, Dqm = 0, Manual precharge

        //================================================================================================
        /* 
          nop
          input  [1 : 0] dqm_in;
          input [15 : 0] dq_in;
         */
        // Similar to Figure 15: READ-to-WRITE
        // The DQM signal must be de-asserted prior to the WRITE command (DQM latency is
        // zero clocks for input buffers) to ensure that the written data is not masked
        //================================================================================================
        #tCK; nop    (3, hi_z);                 // Nop: DQM high
        #tCK; nop    (3, hi_z);                 // Nop: DQM high
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; write  (0, 42, 242, 0);           // Write : Bank = 0, Col = 42, Dqm = 0, Manual Precharge
        #tCK; nop    (0, 243);                 // Nop :              Col = 43
        #tCK; nop    (0, 244);                 // Nop :              Col = 40
        #tCK; nop    (0, 245);                 // Nop :              Col = 41
   
        //================================================================================================
        // Similar to Figure 18: Terminating a READ Burst 
        $display("Terminating a Read Burst");
        // (auto precharge is not actived)
        //================================================================================================
        #tCK; read   (0, 42, hi_z, 0);          // Read  : Bank = 0, Col = 42, Dqm = 0, Manual precharge
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; burst_term(hi_z);                 // Burst Terminate
        //--------------------------------------------------------------------------------------------------
        // The BURST TERMINATE command does not precharge the row; the row will remain
        // open until a PRECHARGE command is issued.
        //--------------------------------------------------------------------------------------------------
        #tCK; precharge_bank_0(0, hi_z);        // Precharge 

        //==================================================================================================
        // Unimplemented
        //
        // Power-down occurs if CKE is registered low coincident with a NOP or COMMAND
        // INHIBIT when no accesses are in progress. If power-down occurs when all banks are
        // idle, this mode is referred to as precharge power-down; if power-down occurs when
        // there is a row active in any bank, this mode is referred to as active power-down.
        
        // The clock suspend mode occurs when a column access/burst is in progress and CKE is registered low.
        
        // BURST READ/SINGLE WRITE
        //==================================================================================================

        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop (tRP = 3 cycles(CLK-7ns) for opening the same bank)

        //================================================================================================
        // Figure 46: Alternating Bank Read Accesses (tRP is not considered here for reading different bank)
        $display("Alternating Bank Read Accesses");
        //================================================================================================
        #tCK; active (0, 0, hi_z);              // Active: Bank = 0, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; read   (0, 1024, hi_z, 0);        // Read  : Bank = 0, Col = 0, Dqm = 0, Auto precharge
        //#tCK; nop    (0, hi_z);                 // Nop
        //#tCK; nop    (0, hi_z);                 // Nop

        #tCK; active (1, 0, hi_z);              // Active: Bank = 1, Row = 0  after CAS Latency - Bank0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; read   (1, 1024, hi_z, 0);        // Read  : Bank = 1, Col = 0, Dqm = 0, Auto precharge
        //#tCK; nop    (0, hi_z);                 // Nop
        //#tCK; nop    (0, hi_z);                 // Nop

        #tCK; active (2, 0, hi_z);              // Active: Bank = 2, Row = 0 again
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; read   (2, 1024, hi_z, 0);        // Read  : Bank = 2, Col = 0, Dqm = 0, Auto precharge
        //#tCK; nop    (0, hi_z);                 // Nop
        //#tCK; nop    (0, hi_z);                 // Nop

        #tCK; active (3, 0, hi_z);              // Active: Bank = 3, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; read   (3, 1024, hi_z, 0);        // Read  : Bank = 3, Col = 0, Dqm = 0, Auto precharge
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop

        //=============================================================================================
        // Figure 49 WRITE-Without Auto Precharge
        $display("WRITE-Without Auto Precharge");
        // ??*15ns is required between <DIN m + 3> and the PRECHARGE command, regardless of frequency.* ??
        // OK: tWR(write recovery time): 1 CLK + 7 ns
        //=============================================================================================
        #tCK; active (0, 0, hi_z);              // Active: Bank = 0, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; write  (0, 0, 401, 0);            // Write  : Bank = 0, Col = 0, Dqm = 0, Manule precharge
        #tCK; nop    (0,    402);               // Nop
        #tCK; nop    (0,    403);               // Nop
        #tCK; nop    (0,    404);               // Nop (DIN m + 3)
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; precharge_bank_0(0, hi_z);        // Precharge (tWR: min 2 cycles)
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop


        //================================================================================================
        // Figure 46: Alternating Bank Write Accesses
        $display("Alternating Bank Write Accesses");
        //================================================================================================
        #tCK; active (0, 0, hi_z);              // Active: Bank = 0, Row = 0
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; write  (0, 1024,    0000, 0);     // Write  : Bank = 0, Col = 0, Dqm = 0, Auto precharge
        #tCK; active (1, 0,       0001);        // Active : Bank = 1, Row = 0  after RRD latency
        #tCK; nop    (0,          0002);        // Nop
        #tCK; nop    (0,          0003);        // Nop
        #tCK; write  (1, 1024,    1000, 0);     // Write  : Bank = 1, Col = 0, Dqm = 0, Auto precharge
        #tCK; active (2, 0,       1001);        // Active: Bank = 2, Row = 0 again
        #tCK; nop    (0,          1002);        // Nop
        #tCK; nop    (0,          1003);        // Nop
        #tCK; write  (2, 1024,    2000, 0);     // Write  : Bank = 2, Col = 0, Dqm = 0, Auto precharge
        #tCK; active (3, 0,       2001);        // Active: Bank = 3, Row = 0
        #tCK; nop    (0,          2002);        // Nop
        #tCK; nop    (0,          2003);        // Nop
        #tCK; write  (3, 1024,    3000, 0);     // Write  : Bank = 3, Col = 0, Dqm = 0, Auto precharge
        #tCK; nop    (0,          3001);        // Nop
        #tCK; nop    (0,          3002);        // Nop
        #tCK; nop    (0,          3003);        // Nop
        #tCK; nop    (0, hi_z);                 // Nop
        #tCK; nop    (0, hi_z);                 // Nop

    end
$stop;
$finish;
end

endmodule


