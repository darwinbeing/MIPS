//module Board (
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
  output reg dma_rcv  ,
  output reg dma_txd  ,
  input  [31:0] dev_wdata,   // DEV -> DMA
  output reg [31:0] dev_rdata    // DMA -> DEV  
);

  parameter DMA_IDLE        = 4'd0, 
            DMA_START       = 4'd1,
            DMA_READ        = 4'd2, 
            DMA_WRITE       = 4'd3,
            DMA_WRITE_GRANT = 4'd4,
            DMA_READ_GRANT  = 4'd5,
            DMA_WRITE_READY = 4'd6,
            DMA_READ_READY  = 4'd7;

  reg  [31:0] cregs [0:3];
  reg  [31:0] databus_txd, cdatabus_txd;
  reg  [31:0] line;
  reg   [3:0] state;
  reg         dma_update;

  wire [31:0] ctrl;
  wire [31:0] numb;
  wire [31:0] saddr;
  wire        go, rd, wr, ie;
  wire        dma_done;
  wire        wren = | status_wr;

  tri  [31:0] tri_databus;
  
   
  assign databus = tri_databus;
  assign tri_databus = databus_txd;
  assign tri_databus = cdatabus_txd;
  assign dma_done = (state == DMA_START) & (rd | wr) & (cregs[2] == 32'd0);

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
// status to the status register and sets the done flag to '1' and clears the
// go bit. The done bit of cregs[3] is read by the software for exiting the
// poll of done bit.

  assign go = ctrl[0];
  assign rd = ctrl[1];
  assign wr = ctrl[2];
  assign ie = ctrl[3];

  always @ (posedge clk) begin
    // default
    databus_txd <= 32'hz;
    adbus       <= 32'hz;
    write_mem   <= 1'b0;
    read_mem    <= 1'b0;
    dma_rcv     <= 1'b0;
    dma_txd     <= 1'b0;
    dma_update  <= 1'b0;
    //done        <= 1'b0;

    case (state)
    DMA_IDLE: 
    begin
      if (go) begin
        //done  <= 1'b0;
        state <= DMA_START; 
      end
    end

    DMA_START:
    begin
      if (rd) begin
        if (cregs[2] > 0) begin
          read_mem  <= 1'b1;
          state     <= DMA_READ; 
        end
        else begin
          //done      <= 1'b1;
          state     <= DMA_IDLE;
        end
      end

      if (wr) begin
        if (cregs[2] > 0) begin
          if (dev_rdy) begin
            line    <= dev_wdata;  // dev_wdata may be an output read buffer in the memory controller
            dma_rcv <= 1'b1;
            state   <= DMA_WRITE; 
          end
        end
        else begin
          //done      <= 1'b1;
          state     <= DMA_IDLE;
        end
      end
    end

    DMA_WRITE:
    begin
      dma_rcv       <= 1'b0;
      // issues write_mem to get bus use permission from arbiter
      write_mem     <= 1'b1;
      state         <= DMA_WRITE_GRANT;
    end

    DMA_READ:
    begin
      if (grant) begin
        adbus      <= saddr;
        read_mem   <= 1'b0;
        state      <= DMA_READ_GRANT;
      end
      else begin
        read_mem   <= 1'b1;
      end
    end

    DMA_WRITE_GRANT:
    begin
      if (grant) begin
        databus_txd <= line;  // DEV -> DMA -> BUS
        adbus       <= saddr;
        state       <= DMA_WRITE_READY;
      end
      else begin
        write_mem   <= 1'b1;
      end
    end

    DMA_READ_GRANT:
    begin
      if (ready) begin
        line        <= databus; // DEV <- DMA <- BUS 
        dma_txd     <= 1'b1;
        state       <= DMA_READ_READY;
      end
      else begin
        adbus       <= saddr;
      end
    end

    DMA_READ_READY:
    begin
      if (dev_rdy) begin
        dev_rdata   <= line;
        dma_txd     <= 1'b0;
        dma_update  <= 1'b1;
        state       <= DMA_START;
      end
      else begin
        dma_txd     <= 1'b1;
        state       <= DMA_READ_READY;
      end
    end

    DMA_WRITE_READY:
    begin
      if (ready) begin
        databus_txd <= 32'hz;
        adbus       <= 32'hz;
        dma_update  <= 1'b1;
        state       <= DMA_START;
      end
      else begin              // keep the output driven
        databus_txd <= line;
        adbus       <= saddr;
        //write_mem   <= 1'b1;
        state       <= DMA_WRITE_READY;
      end
    end

    default: state  <= DMA_IDLE;
  endcase
end

  always @ (posedge clk) begin
    // CPU reads DMA register
    case ({status_rd, select_reg})
      5'b10001: cdatabus_txd = cregs[0];
      5'b10010: cdatabus_txd = cregs[1];
      5'b10100: cdatabus_txd = cregs[2];
      5'b11000: cdatabus_txd = cregs[3];
      default:  cdatabus_txd = 32'hz;
    endcase
  end

  always @ (posedge clk) begin
    // Clear DMA control registers at reset
    if (rst) begin 
      cregs[0] <= 32'd0;
      cregs[1] <= 32'd0;
      cregs[2] <= 32'd0;
      cregs[3] <= 32'd0;
    end 
    else if (dma_done) begin
      // DMA sets status regiter:
      // set done bit and clear go bit
      cregs[3] <= {ctrl[31:8], {1'b1, ie, error2, error1}, ctrl[3:1], 1'b0};
    end
    else if (dma_update) begin
      cregs[1] <= cregs[1] + 32'd4;
      cregs[2] <= cregs[2] - 32'd1;
    end
    else begin
      // CPU sets DMA register
      case ({wren, select_reg})
        5'b10001: cregs[0] = databus;
        5'b10010: cregs[1] = databus;
        5'b10100: cregs[2] = databus;
        // LSBs 8
        5'b11000: cregs[3] = databus;
        default: ;
        //begin
        //  $display("Error cregs write address");
        //  $stop;
        //end
      endcase
    end 
  end

endmodule    

