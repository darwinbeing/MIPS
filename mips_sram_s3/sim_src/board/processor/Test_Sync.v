//------------------------------------------------------------------------------ 
// Probe the 3-stage pipelined processor's pc, memory write data and address 
// after the instruction has retired. It doesn't modify the structure of the 
// processor. The codes for generating check enables are not straightforward. 
//------------------------------------------------------------------------------ 
module Test_Sync (
  input             clk,
  input             rst,
  // pipeline stall
  input             data_ready,
  input             inst_ready,
  input             data_read,
  input             data_write,
  // store data
  input      [31:0] data,
  // instruction address
  input      [31:0] pc,
  // store address
  input      [31:0] addr,

  output            check_en,
  output reg [31:0] check_pc,
  output reg [31:0] check_data,
  output reg [31:0] check_addr);

  reg [31:0] pc_dly1, pc_dly2;
  reg [31:0] data_dly1;
  reg [31:0] addr_dly1;
  reg        check_dly1, check_dly2;
  reg        check_en1, check_en2;

  wire pc_en   = (data_read | data_write) ?  data_ready : inst_ready;
  wire data_en = (data_read | data_write) & data_ready;

  // Because pc is connected to the PC register output in PPS_Top.v
  // (i.e. at stage 2) so only two delays are needed to get the appropriate pc
  always @ (posedge clk) begin
    if (pc_en) begin
      pc_dly1 <= pc;
    end
    check_pc   <= pc_dly1;
  end

  // Because memory data or address are available at stage 2, 
  // so only two delays are needed to get the appropriate signals
  always @ (posedge clk) begin
    if (data_en) begin
      data_dly1  <= data;
    end
    check_data <= data_dly1;
  end

  always @ (posedge clk) begin
    if (data_en) begin
      addr_dly1  <= addr;
    end
    check_addr <= addr_dly1;
  end

  // At stage 4 we check pc and memory write data/address 
  always @ (posedge clk) begin
    if (rst) begin
      check_dly1 <= 1'b0;
      check_dly2 <= 1'b0;
      check_en1  <= 1'b0;
      check_en2  <= 1'b0;
    end
    /* The following codes are tricky */
    else begin
      // At the rising clock edge, go to stage 3 
      // when inst_ready is asserted at stage 2.
      check_dly1 <= pc_en;

      if (data_read || data_write) begin
      // At the rising clock edge, go to stage 3 
      // when data_ready is asserted at stage 2.
        check_dly2 <= pc_en;
        check_en1  <= 1'b0;
      end
      else 
      begin
      // Go to stage 4 at the rising clock edge from stage 3
      // if it is not a memory instruction.
        check_dly2 <= 1'b0;
        check_en1 <= check_dly1;
      end

      // Go to stage 4 at the rising clock edge from stage 3
      // if it is a memory instruction.
      check_en2 <= check_dly2;
    end
  end

  assign check_en = check_en1 | check_en2; 

endmodule
