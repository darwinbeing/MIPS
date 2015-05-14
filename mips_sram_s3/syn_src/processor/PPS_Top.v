`include "MIPS1000_defines.v"

module PPS_Top (clk, rst, abus1, abus2, dbus1, dbus2i, dbus2o);
  // FPGA clock
  input clk;
  input rst;
  output [`MEM_ADDR_WIDTH-1:0] abus1;
  output [`MEM_ADDR_WIDTH-1:0] abus2;
  output [31:0] dbus1;  
  output [31:0] dbus2i;   // proc <- memory
  output [31:0] dbus2o;   // proc -> memory


wire [31:0] inst;
wire [31:0] inst_addr;
wire [31:0] data_addr;
wire [31:0] data_out;
wire [31:0] data_in;
wire  [3:0] bwe;


assign dbus1  = inst;
assign dbus2i = data_in;
assign dbus2o = data_out;

PPS_Processor Processor
(
  .clk      (clk),
  .rst      (rst),
  .inst_addr(inst_addr),
  .data_addr(data_addr),
  .inst     (inst),
  .data_in  (data_in),
  .data_out (data_out),
  .bwe      (bwe)
);
 
assign abus1 = inst_addr[`MEM_ADDR_WIDTH+1:2];
assign abus2 = data_addr[`MEM_ADDR_WIDTH+1:2];

three_port_sram Memory
(
  .clk    (clk),
  .abus1  (abus1),
  .dbus1  (inst),
  .abus2  (abus2),
  .dbus2i (data_out),
  .dbus2o (data_in),
  .re1    (1'b1),
  .re2    (1'b1),
  .bwe    (bwe)
);

endmodule 
