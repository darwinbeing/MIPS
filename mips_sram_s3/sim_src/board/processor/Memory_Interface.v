//
// An interface between processor and cache
//
module Memory_Interface(
  input      clk,
  input      rst,
  input      memwr,
  input      memop,
  input      inst_ready,
  output     inst_read,
  input      data_ready,
  output     data_read,
  output     data_write
);

  reg mem_write;
  reg mem_read;
  reg inst_read_int;

  //--------------------------------------------------------------
  // According to the memory access handshaking, 
  // the data_write/data_read must be reset for at least one clock
  // cycle after the ready signal is received.
  //--------------------------------------------------------------
  always @ (posedge clk) begin
    if (rst) 
      inst_read_int  <= 1'b0;
    else if (!data_ready & memop) // & ~inst_ready)  
    // shut down icache but keep reading inst register 
    // for data cache miss
      inst_read_int<= 1'b0;
    else if (inst_ready & inst_read)
      inst_read_int  <= 1'b0;
    else
      inst_read_int <= 1'b1;
  end

  always @ (posedge clk) begin
    if (rst) 
      mem_read  <= 1'b0;
    else if (data_ready & data_read)
      mem_read  <= 1'b0;
    else if (memop & ~memwr)
      mem_read  <= 1'b1;
  end

  always @ (posedge clk) begin
    if (rst) 
      mem_write  <= 1'b0;
    else if (data_ready & data_write)
      mem_write  <= 1'b0;
    else if (memop & memwr)
      mem_write  <= 1'b1;
  end

  assign inst_read = inst_read_int;// | data_ready;
  assign data_write = mem_write | (memop & memwr);
  assign data_read  = mem_read  | (memop & ~memwr);

endmodule 

