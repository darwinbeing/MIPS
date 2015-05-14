`include "MIPS1000_defines.v"

module PPS_Top (clk, rst, abus1, abus2, dbus1, dbus2o);

  // FPGA clock
  input clk;
  input rst;
  output [`MEM_ADDR_WIDTH-1:0] abus1;
  output [`MEM_ADDR_WIDTH-1:0] abus2;
  output [31:0] dbus1;  
  output [31:0] dbus2o;


wire [31:0] inst;
wire [31:0] inst_addr;
wire [31:0] data_addr;
wire [31:0] data;
wire [31:0] dbus2i;
wire  [3:0] bwe;
//wire [`MEM_ADDR_WIDTH-1:0] abus1;
//wire [`MEM_ADDR_WIDTH-1:0] abus2;
//wire [31:0] dbus1;
//wire [31:0] dbus2o;

assign dbus1 = inst;
assign dbus2o = data;

PPS_Processor Processor
(
  .clk      (clk),
  .rst      (rst),
  .inst_addr(inst_addr),
  .data_addr(data_addr),
  .inst     (inst),
  .data_in  (data), // MEM2PROC
  .data_out (dbus2i), //PROC2MEM
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
  .dbus2i (dbus2i),
  .dbus2o (data),
  .re1    (1'b1),
  .re2    (1'b1),
  .bwe    (bwe)
);

endmodule 
