`include "MIPS1000_defines.v"

// Synchronous RAM
// writable only on port 2i
module three_port_sram 
(
  clk,
  abus1,
  dbus1,
  abus2,
  dbus2i,
  dbus2o,
  re1,
  re2,
  bwe
);

	input		clk;
	input	 [`MEM_ADDR_WIDTH-1:0]	abus1;
	input	 [`MEM_ADDR_WIDTH-1:0]	abus2;
	input	 [31:0]	dbus2i;
	input	re1;
	input	re2;
	input	[3:0] bwe;
	output [31:0]	dbus1;
	output [31:0]	dbus2o;

RAM3 u3 
(
	.clock      (clk),
	.data       (dbus2i[31:24]),
	.rdaddress_a(abus1),
	.rdaddress_b(abus2),
	.wraddress  (abus2),
	.wren       (bwe[3]),
	.qa         (dbus1[31:24]),
	.qb         (dbus2o[31:24])
);

RAM2 u2 
(
	.clock      (clk),
	.data       (dbus2i[23:16]),
	.rdaddress_a(abus1),
	.rdaddress_b(abus2),
	.wraddress  (abus2),
	.wren       (bwe[2]),
	.qa         (dbus1[23:16]),
	.qb         (dbus2o[23:16])
);

RAM1 u1 
(
	.clock      (clk),
	.data       (dbus2i[15:8]),
	.rdaddress_a(abus1),
	.rdaddress_b(abus2),
	.wraddress  (abus2),
	.wren       (bwe[1]),
	.qa         (dbus1[15:8]),
	.qb         (dbus2o[15:8])
);

RAM0 u0 
(
	.clock      (clk),
	.data       (dbus2i[7:0]),
	.rdaddress_a(abus1),
	.rdaddress_b(abus2),
	.wraddress  (abus2),
	.wren       (bwe[0]),
	.qa         (dbus1[7:0]),
	.qb         (dbus2o[7:0])
);

endmodule

