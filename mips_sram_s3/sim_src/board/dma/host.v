// -----------------------------------------------------------------
// Steps:
// 1. HOST reads a 8-bit instruction per line from A SRAM file (SRAM.dat). 
// 2. DMA sends the instruction to SRAM. (Precompute the file size)
// 3. DMA reads the instruction from SRAM  
// 4. CPU executes the instructions in the SRAM
// -----------------------------------------------------------------
module host (
  input             clk,
  output reg        hclk,
  input      [31:0] adbus,
  output     [31:0] databus,  // DMA - BUS
  output reg        rw_n,     // HOST read/write
  input             data_rcv, // DMA received data
  input             data_txd, // DMA sent data
  output reg        data_rdy, // DEV is ready
  output reg [31:0] dev_out,  // HOST -> DMA
  input      [31:0] dev_in   // HOST <- DMA
);

  // A SRAM file (SRAM.dat)
  integer cnt;
  integer file_size;
  integer file, status;

  reg [31:0] memcode;
  reg [31:0] test_data;
  reg [31:0] data;
  reg [31:0] databus_txd;

  always #100 hclk = ~hclk;

  assign databus = databus_txd;

  initial begin
    file        = $fopen("SRAM.dat", "r");
    file_size   = 0;
    status      = 0;
    hclk        = 1'b0;
    cnt         = 1;
    rw_n        = 1'b0;         // write
    data_rdy    = 1'b0;
    databus_txd = 32'hz;
    data        = 32'hFFFFFFFF;
    test_data   = 32'hDEADBEEF;  
    wait (status == -1);        // -1 when file reading is done
    file_size = cnt; 
    cnt = 1;                    // reset counter
    #100

    rw_n = 1'b1;                // read
    wait (cnt == file_size) cnt = 0;
    
    // Execute test program ...
    
    //$stop;
  end

    // HOST -> DMA
  always begin
    status = $fscanf(file, "%h\n", test_data);
    data_rdy = 1'b1;
    wait (data_rdy & ~rw_n);
    dev_out = test_data;
    $display($time, "%d : MEM <- DMA writing test data %h", cnt, dev_out);
    wait (data_rcv);   // wait until device data is received by DMA
    data_rdy = 1'b0;
    cnt = cnt + 1;
    @(negedge hclk);
    @(negedge hclk); // 
  end

    // HOST <- DMA
  always begin
    wait (data_txd & rw_n);
    data_rdy = 1'b1;
    wait (!data_txd);  // wait until data is sent from DMA to device
    data_rdy = 1'b0;
    data = dev_in;
    $display($time, "%d : MEM -> DMA reading test data %h", cnt, dev_in);
    cnt = cnt + 1;
  end

  // word transfer length is 8
  always @ (posedge clk) begin
    if (adbus == 32'hAFFFFFE0) begin
      databus_txd <= 32'd128;   // precomputed (simpletest.s) 
    end
    else begin
      databus_txd <= 32'hz;
    end
  end

endmodule 
