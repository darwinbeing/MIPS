module Test_Sync (
  input             clk,
  input             rst,
  input             stall,
  input      [31:0] pc,
  input      [31:0] data,
  input      [31:0] addr,
  output reg        check_en,
  output reg [31:0] check_pc,
  output reg [31:0] check_data,
  output reg [31:0] check_addr);

  reg [31:0] pc_dly1, pc_dly2;
  reg [31:0] data_dly1;
  reg [31:0] addr_dly1;
  reg        check_dly1, check_dly2;
  reg  [1:0] state;

  parameter RESET = 2'd0, START = 2'd1, RUN = 2'd2;

  always @ (posedge clk) begin
    // Delay PC for three cycles
    pc_dly1    <= pc;
    pc_dly2    <= stall ? 32'hDEADBEEF : pc_dly1;
    check_pc   <= pc_dly2;

    // Delay memory write data for two cycles
    data_dly1  <= stall ? 32'hDEADBEEF : data;
    check_data <= data_dly1;

    // Delay memory write address for two cycles
    addr_dly1  <= stall ? 32'hDEADBEEF : addr;
    check_addr <= addr_dly1;

    // Time to check
    // --------------------------------------------------------------------
    // When reset is asserted we don't need to check the register file
    // contents as they are all zeros. But we would resume checking machine
    // states after 3 clock cycles
    // --------------------------------------------------------------------
    check_dly1 <= (state == START) | (state == RUN);
    check_dly2 <= (rst | stall) ? 1'b0 : check_dly1;
    check_en   <= ~rst & check_dly2;
 end

  // Initial reset state control
  always @ (posedge clk) begin
    case (state)
      RESET:
      begin
        if (rst)
          state <= START;
      end
      START:
      begin
        if (!rst) 
          state <= RUN;
      end
      RUN:
      begin
        if (rst) 
          state <= START; 
      end
      default: begin
        $display("default");
        state <= RESET;
      end
    endcase
  end

endmodule
