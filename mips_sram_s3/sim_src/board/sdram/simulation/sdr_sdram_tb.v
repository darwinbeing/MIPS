`timescale 1ps / 1ps

module sdr_sdram_tb();


// defines for the testbench
`define         BL              8               // burst length
`define         CL              3               // cas latency
`define         RCD             2               // RCD
`define         LOOP_LENGTH     1024            // memory test loop length


`include        "params.v"


reg                             clk;                    // Generated System Clock
reg                             clk2;                   // staggered system clock for sdram models
reg                             reset_n;                // Reset

reg     [2:0]                   cmd;
reg     [`ASIZE-1:0]            addr;
reg                             ref_ack;
reg     [`DSIZE-1:0]            datain;
reg     [`DSIZE/8-1:0]          dm;

wire                            cmdack;
wire    [`DSIZE-1:0]            dataout;
wire    [11:0]                  sa;
wire    [1:0]                   ba;
wire    [1:0]                   cs_n;
wire                            cke;
wire                            ras_n;
wire                            cas_n;
wire                            we_n;
wire    [`DSIZE-1:0]            dq;
wire    [`DSIZE/8-1:0]          dqm;
reg     [`ASIZE-1:0]            test_data;
reg     [`DSIZE-1:0]            test_addr;
reg     [11:0]                  mode_reg;

integer                         j;
integer                         x,y,z;
integer                         bl;

// SDR SDRAM controller
sdr_sdram sdr_sdram1 (
                .CLK(clk),
                .RESET_N(reset_n),
                .ADDR(addr),
                .CMD(cmd),
                .CMDACK(cmdack),
                .DATAIN(datain),
                .DATAOUT(dataout),
                .DM(dm),
                .SA(sa),
                .BA(ba),
                .CS_N(cs_n),
                .CKE(cke),
                .RAS_N(ras_n),
                .CAS_N(cas_n),
                .WE_N(we_n),
                .DQ(dq),
                .DQM(dqm)
                );

// micron memory models

mt48lc8m16a2 mem00      (.Dq(dq[15:0]),
                        .Addr(sa[11:0]),
                        .Ba(ba),
                        .Clk(clk2),
                        .Cke(cke),
                        .Cs_n(cs_n[0]),
                        .Cas_n(cas_n),
                        .Ras_n(ras_n),
                        .We_n(we_n),
                        .Dqm(dqm[1:0]));

mt48lc8m16a2 mem01      (.Dq(dq[31:16]),
                        .Addr(sa[11:0]),
                        .Ba(ba),
                        .Clk(clk2),
                        .Cke(cke),
                        .Cs_n(cs_n[0]),
                        .Cas_n(cas_n),
                        .Ras_n(ras_n),
                        .We_n(we_n),
                        .Dqm(dqm[3:2]));
                        
mt48lc8m16a2 mem10      (.Dq(dq[15:0]),
                        .Addr(sa[11:0]),
                        .Ba(ba),
                        .Clk(clk2),
                        .Cke(cke),
                        .Cs_n(cs_n[1]),
                        .Cas_n(cas_n),
                        .Ras_n(ras_n),
                        .We_n(we_n),
                        .Dqm(dqm[1:0]));

mt48lc8m16a2 mem11      (.Dq(dq[31:16]),
                        .Addr(sa[11:0]),
                        .Ba(ba),
                        .Clk(clk2),
                        .Cke(cke),
                        .Cs_n(cs_n[1]),
                        .Cas_n(cas_n),
                        .Ras_n(ras_n),
                        .We_n(we_n),
                        .Dqm(dqm[3:2]));


initial begin
        clk = 1;
        clk2 = 1;
        reset_n = 0;                                             // reset the system
        #100000 reset_n = 1;
end


// system clocks

//133mhz clock always block
always begin
        #2750 clk2 = ~clk2;                                  
        #1000 clk = ~clk;
end

//100mhz clock always block
//always begin
//        #3 clk2 = ~clk2;                                  
//        #2 clk = ~clk;
//end



//      write_burst(address, start_value, data_mask, RCD, BL)
//
//      This task performs a write access of size BL 
//      at SDRAM address to the SDRAM controller
//
//      address         :    Address in SDRAM to start the burst access
//      start_value     :    Starting value for the burst write sequence.  The write burst task
//                              simply increments the data values from the start_value.
//      data_mask       :    Byte data mask for all cycles in the burst.
//      RCD             :    RCD value that was set during configuration
//      BL              :    BL is the burst length the devices have been configured for.

task    burst_write;

        input [`ASIZE-1   : 0]    address;
        input [`DSIZE-1   : 0]    start_value;
        input [`DSIZE/8-1 : 0]    data_mask;
        input [1 : 0]             RCD;
        input [3 : 0]             BL;

        integer                 i;

        begin
                addr <= address;
                cmd  <= 3'b010;                             // Issue a WRITEA command
                datain <= start_value;                      // Assert the first data value
                dm     <= data_mask;
                @(cmdack==1);                               // wait for the ack from the controller
                @(posedge clk);
                cmd  <= 3'b000;
                for (i=1 ; i<=(RCD-2); i=i+1)               // wait for RAS to CAS to expire
                @(posedge clk);
                for(i = 1; i <= BL; i = i + 1)              // loop from 1 to BL
                begin
                         #1000;
                        datain <= start_value + i;          // clock the data into the controller
                        @(posedge clk);
                        
                end
                dm <= 0;
        end
endtask

//      burst_read(address, start_value, CL, RCD, BL)
//
//      This task performs a read access of size BL 
//      at SDRAM address to the SDRAM controller
//
//      address         :       Address in SDRAM to start the burst access
//      start_value     :       Starting value for the burst read sequence.  The read burst task
//                                simply increments and compares the data values from the start_value.
//      CL              :       CAS latency the sdram devices have been configured for.
//      RCD             :       RCD value the controller has been configured for.
//      BL              :       BL is the burst length the sdram devices have been configured for


task    burst_read;

        input   [`ASIZE-1 : 0]         address;
        input   [`DSIZE-1 : 0]         start_value;
        input   [1 : 0]                CL;
        input   [1 : 0]                RCD;
        input   [3 : 0]                BL;
        integer                        i;
        reg     [`DSIZE-1 : 0]         read_data;
        
        begin
                addr  <= address;
                cmd   <= 3'b001;                            // Issue the READA command
                @(cmdack == 1);                             // wait for an ack from the controller
                @(posedge clk);
                #1000;
                cmd <= 3'b000;                              // Issue a NOP
                for (i=1 ; i<=(CL+RCD+1); i=i+1)            // wait for RAS to CAS to expire
                @(posedge clk);
                for(i = 1; i <= BL; i = i + 1)              // loop from 1 to burst length(BL), collecting and comparing the data
                begin
                        @(posedge clk);
                        read_data <= dataout;
                        #2000;
                        if (read_data !== start_value + i - 1)
                        begin
                                $display("Read error at %h read %h expected %h", (addr+i-1), read_data, (start_value + i -1));
                                $stop;
                        end
                end
                #1000000;
                cmd <= 3'b100;                           // issue a precharge command to close the page                          
                @(posedge clk);
                @(cmdack==1);
                @(posedge clk);
                #1000;    
                cmd  <= 3'b000;

        end
endtask


//      page_write_burst(address, start_value, data_mask, RCD, length)
//
//      This task performs a page write burst access of size length 
//      at SDRAM address to the SDRAM controller
//
//      address         :    Address in SDRAM to start the burst access
//      start_value     :    Starting value for the burst write sequence.  The write burst task
//                              simply increments the data values from the start_value.
//      data_mask       :    Byte data mask for all cycles in the burst.
//      RCD             :    RCD value that was set during configuration
//      length          :    burst length of the access.

task    page_write_burst;

        input [`ASIZE-1   : 0]    address;
        input [`DSIZE-1   : 0]    start_value;
        input [`DSIZE/8-1 : 0]    data_mask;
        input [1 : 0]             RCD;
        input [15 : 0]            length;

        integer                 i;

        begin
                addr <= address;
                cmd  <= 3'b010;
                datain <= start_value;
                dm     <= data_mask;
                @(cmdack==1);
                @(posedge clk);
                #1000;    
                cmd  <= 3'b000;
                for (i=1 ; i<=(RCD-2); i=i+1)
                @(posedge clk);
                for(i = 1; i <= length-2; i = i + 1)
                begin
                #1000;
                        datain <= start_value + i;
                        
                        @(posedge clk);
                        
                end
                #1000;
                datain <= start_value + i;               // keep incrementing the data value
                #1000;    
                cmd <= 3'b100;                           // issue a precharge/terminate command to terminate the page burst                         
                @(posedge clk);
                #1000;

                datain <= start_value + i + 1;           // increment the data one more
                   
                @(cmdack == 1)                           // Wait for the controller to ack the command   
                #2000;
                cmd <= 3'b000;                           // Clear the command by issuing a NOP
                
                dm <= 0;
                #1000000;
                cmd <= 3'b100;                           // issue a precharge command to close the page                          
                @(posedge clk);
                @(cmdack==1);
                @(posedge clk);
                #1000;    
                cmd  <= 3'b000;


        end
endtask

//      page_read_burst(address, start_value, CL, RCD, length)
//
//      This task performs a page read access of size length 
//      at SDRAM address to the SDRAM controller
//
//      address         :       Address in SDRAM to start the burst access
//      start_value     :       Starting value for the burst read sequence.  The read burst task
//                                simply increments and compares the data values from the start_value.
//      CL              :       CAS latency the sdram devices have been configured for.
//      RCD             :       RCD value the controller has been configured for.
//      length          :       burst length of the access


task    page_read_burst;

        input   [`ASIZE-1 : 0]         address;
        input   [`DSIZE-1 : 0]         start_value;
        input   [1 : 0]                CL;
        input   [1 : 0]                RCD;
        input   [15 : 0]               length;
        integer                        i;
        reg     [`DSIZE-1 : 0]         read_data;
        
        begin
                addr  <= address;
                cmd   <= 3'b001;                                 // issue a read command to the controller
                @(cmdack == 1);                                  // wait for the controller to ack
                @(posedge clk);
                #1000;
                cmd <= 3'b000;
                                                   // NOP on the command input
                for (i=1 ; i<=(CL+RCD+1); i=i+1)                 // Wait for activate and cas latency delays
                @(posedge clk);
                for(i = 1; i <= length; i = i + 1)               // loop and collect the data
                begin
                        @(posedge clk);
                        read_data <= dataout;
                        #2000;
                        if (i == (length-8)) cmd <= 3'b100;      // Terminate the page burst 
                        if (cmdack == 1) cmd<=3'b000;            // end the precharge command once the controller has ack'd
                        if (read_data !== start_value + i - 1)
                        begin
                                $display("Read error at %h read %h expected %h", (addr+i-1), read_data, (start_value + i -1));
                                $stop;
                        end
                end
        end
endtask

//      config(bl, cl, rc, pm, ref)
//
//      This task cofigures the SDRAM devices and the controller 
//
//      bl         :       Burst length 1,2,4, or 8
//      cl         :       Cas latency, 2 or 3
//      rc         :       Ras to Cas delay.
//      pm         :       page mode setting
//      ref        :       refresh period setting


task    config;

        input   [3 : 0]           bl;
        input   [1 : 0]           cl;
        input   [1 : 0]           rc;
        input                     pm;
        input   [15: 0]           ref;
        
        reg     [`ASIZE-1 : 0]    config_data;
        
        begin
                config_data <= 0;
                @(posedge clk);
                @(posedge clk);
                                                        
                @(posedge clk);
                if (bl == 1)
                        config_data[2:0] <= 3'b000;     // Set the Burst length portion of the mode data
                else if (bl == 2)
                        config_data[2:0] <= 3'b001;
                else if (bl == 4)
                        config_data[2:0] <= 3'b010;
                else if (bl == 8)
                        config_data[2:0] <= 3'b011;
                else if (bl == 0)
                        config_data[2:0] <= 3'b111;    // full page burst configuration value for bl
                        
                config_data[6:4] <= cl;
        
                                                         // issue precharge before issuing load_mode
                @(posedge clk);
                cmd <= 3'b100;                         
                @(cmdack == 1)                           // Wait for the controller to ack the command   
                #2000;
                cmd <= 3'b000;                           // Clear the command by issuing a NOP

                @(posedge clk);
                #2000;
        
                                                        // load mode register
                cmd <= 3'b101;
                addr[15:0] <= config_data;
                @(cmdack == 1)                          // Wait for the controller to ack the command
                cmd <= 3'b000;                          // Clear the command by issuing a NOP
        
        
                config_data <= 0;
                config_data[15:0] <= ref;
                @(posedge clk);
                                                         // load refresh counter
                @(posedge clk);
                addr[15:0] <= config_data;
                cmd  <= 3'b111;
                @(cmdack == 1 );                         // Wait for the controller to ack the command
                #2000;                          
                cmd  <= 3'b000;                          // Clear the command by issuing a NOP
                addr <= 0;
                config_data <= 0;               
                
                config_data[1:0] <= cl;                  // load contorller reg1
                config_data[3:2] <= rc;
                config_data[8] <= pm;
                config_data[12:9] <= bl;
                @(posedge clk);
                #2000;
                addr[15:0] <= config_data;
                cmd  <= 3'b110;
                @(cmdack == 1)                           // Wait for the controller to ack the command
                #2000;
                cmd  <= 3'b000;                          // Clear the command by issuing a NOP
                addr <= 0;
                config_data <= 0;
        end
endtask

initial begin
        cmd = 0;
        addr = 0;
        ref_ack = 0;
        dm <= 0;

        #3000000; 


  $display("Testing page burst accesses");
  config(0,3,3,1,1526);
  #1000000;

  $display("Writing a ramp value from 0-29 out to sdram at address 0x0");
  page_write_burst(0, 0, 4'h0, 3, 30);
  #1000000;

 $display("Reading the ramp value from sdram at address 0x0");
  page_read_burst(0,0,3,3,30);
 #1000000;


  $display("Testing data mask inputs");
  config(8,3,3,0,1526);
  #1000000;
  
  $display("writing pattern 0,1,2,3,4,5,6,7 to sdram at address 0x0");
  burst_write(0, 0, 4'b0, 3, 8);
  
  $display("Reading and verifing the pattern 0,1,2,3,4,5,6,7 at sdram address 0x0");
  burst_read(0, 0, 3, 3, 8);
  
  $display("Writing pattern 0xfffffff0, 0xfffffff1, 0xfffffff2, 0xfffffff3, 0xfffffff4, 0xfffffff5, 0xfffffff6, 0xfffffff7");
  $display("with DM set to 0xf");
  burst_write(0, 32'hfffffff0, 4'b1111, 3, 8);
  
  $display("Reading and verifing that the pattern at sdram address 0x0 is");
  $display("still 0,1,2,3,4,5,6,7");
  burst_read(0, 0, 3, 3, 8);
  
  $display("End of data mask test");
  
  bl = 1;
  for (x = 1; x <=4; x = x + 1)
  begin
    for (y = 3; y <= 3; y = y + 1)              // at 133mhz cl must be 3,  if 100mhz cl can be 2
    begin 
      for (z = 3; z <=3; z = z + 1)             //at 133mhz rc must be 3, if 100mhz rc can be 2
      begin
         $display("configuring for bl = %d   cl = %d   rc = %d",bl,y,z);
         config(bl, y, z, 0, 1526);
                

// perform 1024 burst writes to the first chip select, writing a ramp pattern
        $display("Peforming burst write to first sdram bank");
        test_data <= 0;
        test_addr <= 0;
        @(posedge clk);
        @(posedge clk);
        for (j = 0; j < `LOOP_LENGTH; j = j + 1)
        begin
                burst_write(test_addr, test_data, 4'h0, z, bl);
                test_data <= test_data + bl;
                test_addr <= test_addr + bl;
                #50000;
        end
        

// perform 1024 burst reads to the first chip select, verifing the ramp pattern
        $display("Performing burst read, verify ramp values in first sdram bank");
        test_data <= 0;
        test_addr <= 0;
        @(posedge clk);
        @(posedge clk);
        for (j = 0; j < `LOOP_LENGTH; j = j + 1)
        begin
                burst_read(test_addr, test_data, y, z, bl);
                test_data <= test_data + bl;
                test_addr <= test_addr + bl;
        end
        
        #500000;

// perform 1024 burst writes to the second chip select, writing a ramp pattern
        $display("Peforming burst write to second sdram bank");
        test_data <= 24'h400000;
        test_addr <= 24'h400000;
        @(posedge clk);
        @(posedge clk);
        for (j = 0; j < `LOOP_LENGTH; j = j + 1)
        begin
                burst_write(test_addr, test_data, 4'h0, z, bl);
                test_data <= test_data + bl;
                test_addr <= test_addr + bl;
                @(posedge clk);
        end
        
// perform 1024 burst reads to the second chip select, verifing the ramp pattern
        $display("Performing burst read, verify ramp values in second sdram bank");
        test_data <= 24'h400000;
        test_addr <= 24'h400000;
        @(posedge clk);
        @(posedge clk);
        for (j = 0; j < `LOOP_LENGTH; j = j + 1)
        begin
                burst_read(test_addr, test_data, y, z, bl);
                test_data <= test_data + bl;
                test_addr <= test_addr + bl;
        end
        
        #500000;

        $display("Test complete");
      end
    end
    bl = bl * 2;

  end
$stop;
end

endmodule

