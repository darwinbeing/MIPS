module Reset_Control (clk, rst_in, rst_out);
  input clk;
  input rst_in;
  output reg rst_out;

always @ (posedge clk)
begin
  if (!rst_in)
    rst_out <= 1'b1;
  else 
    rst_out <= 1'b0;
end

endmodule


