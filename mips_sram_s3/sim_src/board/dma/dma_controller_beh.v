module dma_controller (
  input        clk   ,
  input        rst   ,
  // memory signals
  output reg   read_mem  ,
  output reg   write_mem ,
  inout [31:0] databus ,
  output reg [31:0] adbus   ,
  input        ready   ,
  input        grant   ,
  input [3:0]  status_wr   ,
  input        status_rd   ,

  // cpu signals
  input [3:0] select_reg ,

  // device signals
  input error1    ,
  input error2    ,
  input dev_rdy   ,
  output reg dev_rcv  ,
  input [31:0] dev_data);

  reg         done;
  reg  [31:0] cregs [0:3];
  reg  [31:0] databus_txd;
  reg  [31:0] line;

  wire [31:0] ctrl;
  wire [31:0] numb;
  wire [31:0] saddr;
  //wire [31:0] creg0, creg1, creg2, creg3;
  wire        go, rd, wr, ie;
  wire        wren = | status_wr;
  
  // Clear DMA control registers at reset
  always @ (posedge clk) begin
    if (rst) begin 
      cregs[0] <= 32'd0;
      cregs[1] <= 32'd0;
      cregs[2] <= 32'd0;
      cregs[3] <= 32'd0;
    end
  end
  
  assign databus = databus_txd;

  // control and status register  
  assign ctrl  = cregs[3];

  // The number of words to transfer
  assign numb  = cregs[2];

  // Starting address of words transfer
  assign saddr = cregs[1];

  // done ie er2 er1 | ie wr rd go
  // cregs[0]

// When cpu is ready to start data transfer, it sets go and wr flags of the
// 4th DMA register to '1'. The ie flag may be set by the CPU to enable
// interrupt when DMA completes its transfer. When done, DMA writes its error
// status to the status register and sets the done flag to '1'.  

  assign go = ctrl[0];
  assign rd = ctrl[1];
  assign wr = ctrl[2];
  assign ie = ctrl[3];

  always begin
    databus_txd = 32'hz;
    adbus       = 32'hz;
    write_mem   = 1'b0;
    read_mem    = 1'b0;
    dev_rcv     = 1'b0;

    wait (go) done = 1'b0;

    // memory read unimplemented
    if (rd) begin
    end

    // memory write
    if (wr) begin

      while (cregs[2] > 0) begin
        cregs[2] = cregs[2] - 1;

        if (!dev_rdy) wait(dev_rdy);
        line = dev_data;  // dev_data may be an output read buffer in the memory controller

        // free device by issuing dev_rcv, which is synchronized with the system clock
        @(posedge clk)
        dev_rcv = 1'b1;
        @(negedge clk)
        dev_rcv = 1'b0;

        // dma issues write_mem to get permission from the arbiter to use system bus
        write_mem = 1'b1;

        wait (grant);
        databus_txd = line;
        adbus   = saddr;

        wait (ready)
        databus_txd = 32'hz;
        adbus   = 32'hz;
        write_mem = 1'b0;
        cregs[1] = cregs[1] + 32'd4;
      end
      done = 1'b1;
    end
  end

// CPU reads DMA register
  always @ (posedge clk) begin
    case ({status_rd, select_reg})
      5'b10001: databus_txd = cregs[0];
      5'b10010: databus_txd = cregs[1];
      5'b10100: databus_txd = cregs[2];
      5'b11000: databus_txd = cregs[3];
      default:  databus_txd = 32'hz;
    endcase
  end

// CPU sets DMA register
  always @ (posedge clk) begin
    case ({wren, select_reg})
      5'b10001: cregs[0] = databus;
      5'b10010: cregs[1] = databus;
      5'b10100: cregs[2] = databus;
      // LSBs 8
      5'b11000: cregs[3] = databus;
      default:; 
//      begin
//        $display("Error cregs write address");
//        $stop;
//      end
    endcase
  end

// DMA sets status regiter
  always @ (posedge clk) begin
    // set done bit and clear go bit
    if (done) begin
      cregs[3] = {ctrl[31:8], {1'b1, ie, error2, error1}, ctrl[3:1], 1'b0};
    end
  end

endmodule    
