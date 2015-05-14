// Copyright (C) 1991-2010 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// VENDOR "Altera"
// PROGRAM "Quartus II"
// VERSION "Version 10.0 Build 218 06/27/2010 SJ Full Version"

// DATE "09/26/2010 08:38:15"

// 
// Device: Altera EP2C5T144C6 Package TQFP144
// 

// 
// This greybox netlist file is for third party Synthesis Tools
// for timing and resource estimation only.
// 


module RAM2 (
	clock,
	data,
	rdaddress_a,
	rdaddress_b,
	wraddress,
	wren,
	qa,
	qb)/* synthesis synthesis_greybox=0 */;
input 	clock;
input 	[7:0] data;
input 	[10:0] rdaddress_a;
input 	[10:0] rdaddress_b;
input 	[10:0] wraddress;
input 	wren;
output 	[7:0] qa;
output 	[7:0] qb;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[0] ;
wire \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[1] ;
wire \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[2] ;
wire \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[3] ;
wire \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[4] ;
wire \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[5] ;
wire \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[6] ;
wire \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[7] ;
wire \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[0] ;
wire \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[1] ;
wire \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[2] ;
wire \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[3] ;
wire \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[4] ;
wire \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[5] ;
wire \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[6] ;
wire \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[7] ;


RAM2_alt3pram_1 alt3pram_component(
	.qa({\alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[7] ,\alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[6] ,\alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[5] ,
\alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[4] ,\alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[3] ,\alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[2] ,
\alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[1] ,\alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[0] }),
	.qb({\alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[7] ,\alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[6] ,\alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[5] ,
\alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[4] ,\alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[3] ,\alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[2] ,
\alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[1] ,\alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[0] }),
	.wren(wren),
	.inclock(clock),
	.data({data[7],data[6],data[5],data[4],data[3],data[2],data[1],data[0]}),
	.wraddress({wraddress[10],wraddress[9],wraddress[8],wraddress[7],wraddress[6],wraddress[5],wraddress[4],wraddress[3],wraddress[2],wraddress[1],wraddress[0]}),
	.rdaddress_a({rdaddress_a[10],rdaddress_a[9],rdaddress_a[8],rdaddress_a[7],rdaddress_a[6],rdaddress_a[5],rdaddress_a[4],rdaddress_a[3],rdaddress_a[2],rdaddress_a[1],rdaddress_a[0]}),
	.rdaddress_b({rdaddress_b[10],rdaddress_b[9],rdaddress_b[8],rdaddress_b[7],rdaddress_b[6],rdaddress_b[5],rdaddress_b[4],rdaddress_b[3],rdaddress_b[2],rdaddress_b[1],rdaddress_b[0]}));

assign qa[0] = \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[0] ;

assign qa[1] = \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[1] ;

assign qa[2] = \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[2] ;

assign qa[3] = \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[3] ;

assign qa[4] = \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[4] ;

assign qa[5] = \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[5] ;

assign qa[6] = \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[6] ;

assign qa[7] = \alt3pram_component|altdpram_component1|ram_block|auto_generated|q_b[7] ;

assign qb[0] = \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[0] ;

assign qb[1] = \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[1] ;

assign qb[2] = \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[2] ;

assign qb[3] = \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[3] ;

assign qb[4] = \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[4] ;

assign qb[5] = \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[5] ;

assign qb[6] = \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[6] ;

assign qb[7] = \alt3pram_component|altdpram_component2|ram_block|auto_generated|q_b[7] ;

endmodule

module RAM2_alt3pram_1 (
	qa,
	qb,
	wren,
	inclock,
	data,
	wraddress,
	rdaddress_a,
	rdaddress_b)/* synthesis synthesis_greybox=0 */;
output 	[7:0] qa;
output 	[7:0] qb;
input 	wren;
input 	inclock;
input 	[7:0] data;
input 	[10:0] wraddress;
input 	[10:0] rdaddress_a;
input 	[10:0] rdaddress_b;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



RAM2_altdpram_1 altdpram_component1(
	.q({qa[7],qa[6],qa[5],qa[4],qa[3],qa[2],qa[1],qa[0]}),
	.wren(wren),
	.inclock(inclock),
	.data({data[7],data[6],data[5],data[4],data[3],data[2],data[1],data[0]}),
	.wraddress({wraddress[10],wraddress[9],wraddress[8],wraddress[7],wraddress[6],wraddress[5],wraddress[4],wraddress[3],wraddress[2],wraddress[1],wraddress[0]}),
	.rdaddress({rdaddress_a[10],rdaddress_a[9],rdaddress_a[8],rdaddress_a[7],rdaddress_a[6],rdaddress_a[5],rdaddress_a[4],rdaddress_a[3],rdaddress_a[2],rdaddress_a[1],rdaddress_a[0]}));

RAM2_altdpram_2 altdpram_component2(
	.q({qb[7],qb[6],qb[5],qb[4],qb[3],qb[2],qb[1],qb[0]}),
	.wren(wren),
	.inclock(inclock),
	.data({data[7],data[6],data[5],data[4],data[3],data[2],data[1],data[0]}),
	.wraddress({wraddress[10],wraddress[9],wraddress[8],wraddress[7],wraddress[6],wraddress[5],wraddress[4],wraddress[3],wraddress[2],wraddress[1],wraddress[0]}),
	.rdaddress({rdaddress_b[10],rdaddress_b[9],rdaddress_b[8],rdaddress_b[7],rdaddress_b[6],rdaddress_b[5],rdaddress_b[4],rdaddress_b[3],rdaddress_b[2],rdaddress_b[1],rdaddress_b[0]}));

endmodule

module RAM2_altdpram_1 (
	q,
	wren,
	inclock,
	data,
	wraddress,
	rdaddress)/* synthesis synthesis_greybox=0 */;
output 	[7:0] q;
input 	wren;
input 	inclock;
input 	[7:0] data;
input 	[10:0] wraddress;
input 	[10:0] rdaddress;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



RAM2_altsyncram_1 ram_block(
	.q_b({q[7],q[6],q[5],q[4],q[3],q[2],q[1],q[0]}),
	.wren_a(wren),
	.clock0(inclock),
	.data_a({data[7],data[6],data[5],data[4],data[3],data[2],data[1],data[0]}),
	.address_a({wraddress[10],wraddress[9],wraddress[8],wraddress[7],wraddress[6],wraddress[5],wraddress[4],wraddress[3],wraddress[2],wraddress[1],wraddress[0]}),
	.address_b({rdaddress[10],rdaddress[9],rdaddress[8],rdaddress[7],rdaddress[6],rdaddress[5],rdaddress[4],rdaddress[3],rdaddress[2],rdaddress[1],rdaddress[0]}));

endmodule

module RAM2_altsyncram_1 (
	q_b,
	wren_a,
	clock0,
	data_a,
	address_a,
	address_b)/* synthesis synthesis_greybox=0 */;
output 	[7:0] q_b;
input 	wren_a;
input 	clock0;
input 	[7:0] data_a;
input 	[10:0] address_a;
input 	[10:0] address_b;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



RAM2_altsyncram_uqt1 auto_generated(
	.q_b({q_b[7],q_b[6],q_b[5],q_b[4],q_b[3],q_b[2],q_b[1],q_b[0]}),
	.wren_a(wren_a),
	.clock0(clock0),
	.data_a({data_a[7],data_a[6],data_a[5],data_a[4],data_a[3],data_a[2],data_a[1],data_a[0]}),
	.address_a({address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.address_b({address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}));

endmodule

module RAM2_altsyncram_uqt1 (
	q_b,
	wren_a,
	clock0,
	data_a,
	address_a,
	address_b)/* synthesis synthesis_greybox=0 */;
output 	[7:0] q_b;
input 	wren_a;
input 	clock0;
input 	[7:0] data_a;
input 	[10:0] address_a;
input 	[10:0] address_b;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;


wire [143:0] ram_block1a0_PORTBDATAOUT_bus;
wire [143:0] ram_block1a1_PORTBDATAOUT_bus;
wire [143:0] ram_block1a2_PORTBDATAOUT_bus;
wire [143:0] ram_block1a3_PORTBDATAOUT_bus;
wire [143:0] ram_block1a4_PORTBDATAOUT_bus;
wire [143:0] ram_block1a5_PORTBDATAOUT_bus;
wire [143:0] ram_block1a6_PORTBDATAOUT_bus;
wire [143:0] ram_block1a7_PORTBDATAOUT_bus;

assign q_b[0] = ram_block1a0_PORTBDATAOUT_bus[0];

assign q_b[1] = ram_block1a1_PORTBDATAOUT_bus[0];

assign q_b[2] = ram_block1a2_PORTBDATAOUT_bus[0];

assign q_b[3] = ram_block1a3_PORTBDATAOUT_bus[0];

assign q_b[4] = ram_block1a4_PORTBDATAOUT_bus[0];

assign q_b[5] = ram_block1a5_PORTBDATAOUT_bus[0];

assign q_b[6] = ram_block1a6_PORTBDATAOUT_bus[0];

assign q_b[7] = ram_block1a7_PORTBDATAOUT_bus[0];

cycloneii_ram_block ram_block1a0(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[0]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a0_PORTBDATAOUT_bus));
defparam ram_block1a0.data_interleave_offset_in_bits = 1;
defparam ram_block1a0.data_interleave_width_in_bits = 1;
defparam ram_block1a0.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component1|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a0.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a0.operation_mode = "dual_port";
defparam ram_block1a0.port_a_address_clear = "none";
defparam ram_block1a0.port_a_address_width = 11;
defparam ram_block1a0.port_a_byte_enable_clear = "none";
defparam ram_block1a0.port_a_data_in_clear = "none";
defparam ram_block1a0.port_a_data_out_clear = "none";
defparam ram_block1a0.port_a_data_out_clock = "none";
defparam ram_block1a0.port_a_data_width = 1;
defparam ram_block1a0.port_a_first_address = 0;
defparam ram_block1a0.port_a_first_bit_number = 0;
defparam ram_block1a0.port_a_last_address = 2047;
defparam ram_block1a0.port_a_logical_ram_depth = 2048;
defparam ram_block1a0.port_a_logical_ram_width = 8;
defparam ram_block1a0.port_a_write_enable_clear = "none";
defparam ram_block1a0.port_b_address_clear = "none";
defparam ram_block1a0.port_b_address_clock = "clock0";
defparam ram_block1a0.port_b_address_width = 11;
defparam ram_block1a0.port_b_byte_enable_clear = "none";
defparam ram_block1a0.port_b_data_in_clear = "none";
defparam ram_block1a0.port_b_data_out_clear = "none";
defparam ram_block1a0.port_b_data_out_clock = "none";
defparam ram_block1a0.port_b_data_width = 1;
defparam ram_block1a0.port_b_first_address = 0;
defparam ram_block1a0.port_b_first_bit_number = 0;
defparam ram_block1a0.port_b_last_address = 2047;
defparam ram_block1a0.port_b_logical_ram_depth = 2048;
defparam ram_block1a0.port_b_logical_ram_width = 8;
defparam ram_block1a0.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a0.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a0.ram_block_type = "M4K";
defparam ram_block1a0.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a1(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[1]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a1_PORTBDATAOUT_bus));
defparam ram_block1a1.data_interleave_offset_in_bits = 1;
defparam ram_block1a1.data_interleave_width_in_bits = 1;
defparam ram_block1a1.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component1|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a1.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a1.operation_mode = "dual_port";
defparam ram_block1a1.port_a_address_clear = "none";
defparam ram_block1a1.port_a_address_width = 11;
defparam ram_block1a1.port_a_byte_enable_clear = "none";
defparam ram_block1a1.port_a_data_in_clear = "none";
defparam ram_block1a1.port_a_data_out_clear = "none";
defparam ram_block1a1.port_a_data_out_clock = "none";
defparam ram_block1a1.port_a_data_width = 1;
defparam ram_block1a1.port_a_first_address = 0;
defparam ram_block1a1.port_a_first_bit_number = 1;
defparam ram_block1a1.port_a_last_address = 2047;
defparam ram_block1a1.port_a_logical_ram_depth = 2048;
defparam ram_block1a1.port_a_logical_ram_width = 8;
defparam ram_block1a1.port_a_write_enable_clear = "none";
defparam ram_block1a1.port_b_address_clear = "none";
defparam ram_block1a1.port_b_address_clock = "clock0";
defparam ram_block1a1.port_b_address_width = 11;
defparam ram_block1a1.port_b_byte_enable_clear = "none";
defparam ram_block1a1.port_b_data_in_clear = "none";
defparam ram_block1a1.port_b_data_out_clear = "none";
defparam ram_block1a1.port_b_data_out_clock = "none";
defparam ram_block1a1.port_b_data_width = 1;
defparam ram_block1a1.port_b_first_address = 0;
defparam ram_block1a1.port_b_first_bit_number = 1;
defparam ram_block1a1.port_b_last_address = 2047;
defparam ram_block1a1.port_b_logical_ram_depth = 2048;
defparam ram_block1a1.port_b_logical_ram_width = 8;
defparam ram_block1a1.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a1.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a1.ram_block_type = "M4K";
defparam ram_block1a1.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a2(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[2]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a2_PORTBDATAOUT_bus));
defparam ram_block1a2.data_interleave_offset_in_bits = 1;
defparam ram_block1a2.data_interleave_width_in_bits = 1;
defparam ram_block1a2.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component1|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a2.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a2.operation_mode = "dual_port";
defparam ram_block1a2.port_a_address_clear = "none";
defparam ram_block1a2.port_a_address_width = 11;
defparam ram_block1a2.port_a_byte_enable_clear = "none";
defparam ram_block1a2.port_a_data_in_clear = "none";
defparam ram_block1a2.port_a_data_out_clear = "none";
defparam ram_block1a2.port_a_data_out_clock = "none";
defparam ram_block1a2.port_a_data_width = 1;
defparam ram_block1a2.port_a_first_address = 0;
defparam ram_block1a2.port_a_first_bit_number = 2;
defparam ram_block1a2.port_a_last_address = 2047;
defparam ram_block1a2.port_a_logical_ram_depth = 2048;
defparam ram_block1a2.port_a_logical_ram_width = 8;
defparam ram_block1a2.port_a_write_enable_clear = "none";
defparam ram_block1a2.port_b_address_clear = "none";
defparam ram_block1a2.port_b_address_clock = "clock0";
defparam ram_block1a2.port_b_address_width = 11;
defparam ram_block1a2.port_b_byte_enable_clear = "none";
defparam ram_block1a2.port_b_data_in_clear = "none";
defparam ram_block1a2.port_b_data_out_clear = "none";
defparam ram_block1a2.port_b_data_out_clock = "none";
defparam ram_block1a2.port_b_data_width = 1;
defparam ram_block1a2.port_b_first_address = 0;
defparam ram_block1a2.port_b_first_bit_number = 2;
defparam ram_block1a2.port_b_last_address = 2047;
defparam ram_block1a2.port_b_logical_ram_depth = 2048;
defparam ram_block1a2.port_b_logical_ram_width = 8;
defparam ram_block1a2.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a2.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a2.ram_block_type = "M4K";
defparam ram_block1a2.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a3(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[3]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a3_PORTBDATAOUT_bus));
defparam ram_block1a3.data_interleave_offset_in_bits = 1;
defparam ram_block1a3.data_interleave_width_in_bits = 1;
defparam ram_block1a3.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component1|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a3.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a3.operation_mode = "dual_port";
defparam ram_block1a3.port_a_address_clear = "none";
defparam ram_block1a3.port_a_address_width = 11;
defparam ram_block1a3.port_a_byte_enable_clear = "none";
defparam ram_block1a3.port_a_data_in_clear = "none";
defparam ram_block1a3.port_a_data_out_clear = "none";
defparam ram_block1a3.port_a_data_out_clock = "none";
defparam ram_block1a3.port_a_data_width = 1;
defparam ram_block1a3.port_a_first_address = 0;
defparam ram_block1a3.port_a_first_bit_number = 3;
defparam ram_block1a3.port_a_last_address = 2047;
defparam ram_block1a3.port_a_logical_ram_depth = 2048;
defparam ram_block1a3.port_a_logical_ram_width = 8;
defparam ram_block1a3.port_a_write_enable_clear = "none";
defparam ram_block1a3.port_b_address_clear = "none";
defparam ram_block1a3.port_b_address_clock = "clock0";
defparam ram_block1a3.port_b_address_width = 11;
defparam ram_block1a3.port_b_byte_enable_clear = "none";
defparam ram_block1a3.port_b_data_in_clear = "none";
defparam ram_block1a3.port_b_data_out_clear = "none";
defparam ram_block1a3.port_b_data_out_clock = "none";
defparam ram_block1a3.port_b_data_width = 1;
defparam ram_block1a3.port_b_first_address = 0;
defparam ram_block1a3.port_b_first_bit_number = 3;
defparam ram_block1a3.port_b_last_address = 2047;
defparam ram_block1a3.port_b_logical_ram_depth = 2048;
defparam ram_block1a3.port_b_logical_ram_width = 8;
defparam ram_block1a3.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a3.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a3.ram_block_type = "M4K";
defparam ram_block1a3.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a4(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[4]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a4_PORTBDATAOUT_bus));
defparam ram_block1a4.data_interleave_offset_in_bits = 1;
defparam ram_block1a4.data_interleave_width_in_bits = 1;
defparam ram_block1a4.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component1|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a4.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a4.operation_mode = "dual_port";
defparam ram_block1a4.port_a_address_clear = "none";
defparam ram_block1a4.port_a_address_width = 11;
defparam ram_block1a4.port_a_byte_enable_clear = "none";
defparam ram_block1a4.port_a_data_in_clear = "none";
defparam ram_block1a4.port_a_data_out_clear = "none";
defparam ram_block1a4.port_a_data_out_clock = "none";
defparam ram_block1a4.port_a_data_width = 1;
defparam ram_block1a4.port_a_first_address = 0;
defparam ram_block1a4.port_a_first_bit_number = 4;
defparam ram_block1a4.port_a_last_address = 2047;
defparam ram_block1a4.port_a_logical_ram_depth = 2048;
defparam ram_block1a4.port_a_logical_ram_width = 8;
defparam ram_block1a4.port_a_write_enable_clear = "none";
defparam ram_block1a4.port_b_address_clear = "none";
defparam ram_block1a4.port_b_address_clock = "clock0";
defparam ram_block1a4.port_b_address_width = 11;
defparam ram_block1a4.port_b_byte_enable_clear = "none";
defparam ram_block1a4.port_b_data_in_clear = "none";
defparam ram_block1a4.port_b_data_out_clear = "none";
defparam ram_block1a4.port_b_data_out_clock = "none";
defparam ram_block1a4.port_b_data_width = 1;
defparam ram_block1a4.port_b_first_address = 0;
defparam ram_block1a4.port_b_first_bit_number = 4;
defparam ram_block1a4.port_b_last_address = 2047;
defparam ram_block1a4.port_b_logical_ram_depth = 2048;
defparam ram_block1a4.port_b_logical_ram_width = 8;
defparam ram_block1a4.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a4.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a4.ram_block_type = "M4K";
defparam ram_block1a4.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a5(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[5]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a5_PORTBDATAOUT_bus));
defparam ram_block1a5.data_interleave_offset_in_bits = 1;
defparam ram_block1a5.data_interleave_width_in_bits = 1;
defparam ram_block1a5.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component1|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a5.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a5.operation_mode = "dual_port";
defparam ram_block1a5.port_a_address_clear = "none";
defparam ram_block1a5.port_a_address_width = 11;
defparam ram_block1a5.port_a_byte_enable_clear = "none";
defparam ram_block1a5.port_a_data_in_clear = "none";
defparam ram_block1a5.port_a_data_out_clear = "none";
defparam ram_block1a5.port_a_data_out_clock = "none";
defparam ram_block1a5.port_a_data_width = 1;
defparam ram_block1a5.port_a_first_address = 0;
defparam ram_block1a5.port_a_first_bit_number = 5;
defparam ram_block1a5.port_a_last_address = 2047;
defparam ram_block1a5.port_a_logical_ram_depth = 2048;
defparam ram_block1a5.port_a_logical_ram_width = 8;
defparam ram_block1a5.port_a_write_enable_clear = "none";
defparam ram_block1a5.port_b_address_clear = "none";
defparam ram_block1a5.port_b_address_clock = "clock0";
defparam ram_block1a5.port_b_address_width = 11;
defparam ram_block1a5.port_b_byte_enable_clear = "none";
defparam ram_block1a5.port_b_data_in_clear = "none";
defparam ram_block1a5.port_b_data_out_clear = "none";
defparam ram_block1a5.port_b_data_out_clock = "none";
defparam ram_block1a5.port_b_data_width = 1;
defparam ram_block1a5.port_b_first_address = 0;
defparam ram_block1a5.port_b_first_bit_number = 5;
defparam ram_block1a5.port_b_last_address = 2047;
defparam ram_block1a5.port_b_logical_ram_depth = 2048;
defparam ram_block1a5.port_b_logical_ram_width = 8;
defparam ram_block1a5.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a5.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a5.ram_block_type = "M4K";
defparam ram_block1a5.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a6(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[6]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a6_PORTBDATAOUT_bus));
defparam ram_block1a6.data_interleave_offset_in_bits = 1;
defparam ram_block1a6.data_interleave_width_in_bits = 1;
defparam ram_block1a6.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component1|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a6.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a6.operation_mode = "dual_port";
defparam ram_block1a6.port_a_address_clear = "none";
defparam ram_block1a6.port_a_address_width = 11;
defparam ram_block1a6.port_a_byte_enable_clear = "none";
defparam ram_block1a6.port_a_data_in_clear = "none";
defparam ram_block1a6.port_a_data_out_clear = "none";
defparam ram_block1a6.port_a_data_out_clock = "none";
defparam ram_block1a6.port_a_data_width = 1;
defparam ram_block1a6.port_a_first_address = 0;
defparam ram_block1a6.port_a_first_bit_number = 6;
defparam ram_block1a6.port_a_last_address = 2047;
defparam ram_block1a6.port_a_logical_ram_depth = 2048;
defparam ram_block1a6.port_a_logical_ram_width = 8;
defparam ram_block1a6.port_a_write_enable_clear = "none";
defparam ram_block1a6.port_b_address_clear = "none";
defparam ram_block1a6.port_b_address_clock = "clock0";
defparam ram_block1a6.port_b_address_width = 11;
defparam ram_block1a6.port_b_byte_enable_clear = "none";
defparam ram_block1a6.port_b_data_in_clear = "none";
defparam ram_block1a6.port_b_data_out_clear = "none";
defparam ram_block1a6.port_b_data_out_clock = "none";
defparam ram_block1a6.port_b_data_width = 1;
defparam ram_block1a6.port_b_first_address = 0;
defparam ram_block1a6.port_b_first_bit_number = 6;
defparam ram_block1a6.port_b_last_address = 2047;
defparam ram_block1a6.port_b_logical_ram_depth = 2048;
defparam ram_block1a6.port_b_logical_ram_width = 8;
defparam ram_block1a6.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a6.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a6.ram_block_type = "M4K";
defparam ram_block1a6.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a7(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[7]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a7_PORTBDATAOUT_bus));
defparam ram_block1a7.data_interleave_offset_in_bits = 1;
defparam ram_block1a7.data_interleave_width_in_bits = 1;
defparam ram_block1a7.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component1|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a7.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a7.operation_mode = "dual_port";
defparam ram_block1a7.port_a_address_clear = "none";
defparam ram_block1a7.port_a_address_width = 11;
defparam ram_block1a7.port_a_byte_enable_clear = "none";
defparam ram_block1a7.port_a_data_in_clear = "none";
defparam ram_block1a7.port_a_data_out_clear = "none";
defparam ram_block1a7.port_a_data_out_clock = "none";
defparam ram_block1a7.port_a_data_width = 1;
defparam ram_block1a7.port_a_first_address = 0;
defparam ram_block1a7.port_a_first_bit_number = 7;
defparam ram_block1a7.port_a_last_address = 2047;
defparam ram_block1a7.port_a_logical_ram_depth = 2048;
defparam ram_block1a7.port_a_logical_ram_width = 8;
defparam ram_block1a7.port_a_write_enable_clear = "none";
defparam ram_block1a7.port_b_address_clear = "none";
defparam ram_block1a7.port_b_address_clock = "clock0";
defparam ram_block1a7.port_b_address_width = 11;
defparam ram_block1a7.port_b_byte_enable_clear = "none";
defparam ram_block1a7.port_b_data_in_clear = "none";
defparam ram_block1a7.port_b_data_out_clear = "none";
defparam ram_block1a7.port_b_data_out_clock = "none";
defparam ram_block1a7.port_b_data_width = 1;
defparam ram_block1a7.port_b_first_address = 0;
defparam ram_block1a7.port_b_first_bit_number = 7;
defparam ram_block1a7.port_b_last_address = 2047;
defparam ram_block1a7.port_b_logical_ram_depth = 2048;
defparam ram_block1a7.port_b_logical_ram_width = 8;
defparam ram_block1a7.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a7.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a7.ram_block_type = "M4K";
defparam ram_block1a7.safe_write = "err_on_2clk";

endmodule

module RAM2_altdpram_2 (
	q,
	wren,
	inclock,
	data,
	wraddress,
	rdaddress)/* synthesis synthesis_greybox=0 */;
output 	[7:0] q;
input 	wren;
input 	inclock;
input 	[7:0] data;
input 	[10:0] wraddress;
input 	[10:0] rdaddress;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



RAM2_altsyncram_2 ram_block(
	.q_b({q[7],q[6],q[5],q[4],q[3],q[2],q[1],q[0]}),
	.wren_a(wren),
	.clock0(inclock),
	.data_a({data[7],data[6],data[5],data[4],data[3],data[2],data[1],data[0]}),
	.address_a({wraddress[10],wraddress[9],wraddress[8],wraddress[7],wraddress[6],wraddress[5],wraddress[4],wraddress[3],wraddress[2],wraddress[1],wraddress[0]}),
	.address_b({rdaddress[10],rdaddress[9],rdaddress[8],rdaddress[7],rdaddress[6],rdaddress[5],rdaddress[4],rdaddress[3],rdaddress[2],rdaddress[1],rdaddress[0]}));

endmodule

module RAM2_altsyncram_2 (
	q_b,
	wren_a,
	clock0,
	data_a,
	address_a,
	address_b)/* synthesis synthesis_greybox=0 */;
output 	[7:0] q_b;
input 	wren_a;
input 	clock0;
input 	[7:0] data_a;
input 	[10:0] address_a;
input 	[10:0] address_b;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



RAM2_altsyncram_uqt1_1 auto_generated(
	.q_b({q_b[7],q_b[6],q_b[5],q_b[4],q_b[3],q_b[2],q_b[1],q_b[0]}),
	.wren_a(wren_a),
	.clock0(clock0),
	.data_a({data_a[7],data_a[6],data_a[5],data_a[4],data_a[3],data_a[2],data_a[1],data_a[0]}),
	.address_a({address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.address_b({address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}));

endmodule

module RAM2_altsyncram_uqt1_1 (
	q_b,
	wren_a,
	clock0,
	data_a,
	address_a,
	address_b)/* synthesis synthesis_greybox=0 */;
output 	[7:0] q_b;
input 	wren_a;
input 	clock0;
input 	[7:0] data_a;
input 	[10:0] address_a;
input 	[10:0] address_b;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;


wire [143:0] ram_block1a0_PORTBDATAOUT_bus;
wire [143:0] ram_block1a1_PORTBDATAOUT_bus;
wire [143:0] ram_block1a2_PORTBDATAOUT_bus;
wire [143:0] ram_block1a3_PORTBDATAOUT_bus;
wire [143:0] ram_block1a4_PORTBDATAOUT_bus;
wire [143:0] ram_block1a5_PORTBDATAOUT_bus;
wire [143:0] ram_block1a6_PORTBDATAOUT_bus;
wire [143:0] ram_block1a7_PORTBDATAOUT_bus;

assign q_b[0] = ram_block1a0_PORTBDATAOUT_bus[0];

assign q_b[1] = ram_block1a1_PORTBDATAOUT_bus[0];

assign q_b[2] = ram_block1a2_PORTBDATAOUT_bus[0];

assign q_b[3] = ram_block1a3_PORTBDATAOUT_bus[0];

assign q_b[4] = ram_block1a4_PORTBDATAOUT_bus[0];

assign q_b[5] = ram_block1a5_PORTBDATAOUT_bus[0];

assign q_b[6] = ram_block1a6_PORTBDATAOUT_bus[0];

assign q_b[7] = ram_block1a7_PORTBDATAOUT_bus[0];

cycloneii_ram_block ram_block1a0(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[0]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a0_PORTBDATAOUT_bus));
defparam ram_block1a0.data_interleave_offset_in_bits = 1;
defparam ram_block1a0.data_interleave_width_in_bits = 1;
defparam ram_block1a0.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component2|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a0.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a0.operation_mode = "dual_port";
defparam ram_block1a0.port_a_address_clear = "none";
defparam ram_block1a0.port_a_address_width = 11;
defparam ram_block1a0.port_a_byte_enable_clear = "none";
defparam ram_block1a0.port_a_data_in_clear = "none";
defparam ram_block1a0.port_a_data_out_clear = "none";
defparam ram_block1a0.port_a_data_out_clock = "none";
defparam ram_block1a0.port_a_data_width = 1;
defparam ram_block1a0.port_a_first_address = 0;
defparam ram_block1a0.port_a_first_bit_number = 0;
defparam ram_block1a0.port_a_last_address = 2047;
defparam ram_block1a0.port_a_logical_ram_depth = 2048;
defparam ram_block1a0.port_a_logical_ram_width = 8;
defparam ram_block1a0.port_a_write_enable_clear = "none";
defparam ram_block1a0.port_b_address_clear = "none";
defparam ram_block1a0.port_b_address_clock = "clock0";
defparam ram_block1a0.port_b_address_width = 11;
defparam ram_block1a0.port_b_byte_enable_clear = "none";
defparam ram_block1a0.port_b_data_in_clear = "none";
defparam ram_block1a0.port_b_data_out_clear = "none";
defparam ram_block1a0.port_b_data_out_clock = "none";
defparam ram_block1a0.port_b_data_width = 1;
defparam ram_block1a0.port_b_first_address = 0;
defparam ram_block1a0.port_b_first_bit_number = 0;
defparam ram_block1a0.port_b_last_address = 2047;
defparam ram_block1a0.port_b_logical_ram_depth = 2048;
defparam ram_block1a0.port_b_logical_ram_width = 8;
defparam ram_block1a0.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a0.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a0.ram_block_type = "M4K";
defparam ram_block1a0.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a1(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[1]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a1_PORTBDATAOUT_bus));
defparam ram_block1a1.data_interleave_offset_in_bits = 1;
defparam ram_block1a1.data_interleave_width_in_bits = 1;
defparam ram_block1a1.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component2|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a1.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a1.operation_mode = "dual_port";
defparam ram_block1a1.port_a_address_clear = "none";
defparam ram_block1a1.port_a_address_width = 11;
defparam ram_block1a1.port_a_byte_enable_clear = "none";
defparam ram_block1a1.port_a_data_in_clear = "none";
defparam ram_block1a1.port_a_data_out_clear = "none";
defparam ram_block1a1.port_a_data_out_clock = "none";
defparam ram_block1a1.port_a_data_width = 1;
defparam ram_block1a1.port_a_first_address = 0;
defparam ram_block1a1.port_a_first_bit_number = 1;
defparam ram_block1a1.port_a_last_address = 2047;
defparam ram_block1a1.port_a_logical_ram_depth = 2048;
defparam ram_block1a1.port_a_logical_ram_width = 8;
defparam ram_block1a1.port_a_write_enable_clear = "none";
defparam ram_block1a1.port_b_address_clear = "none";
defparam ram_block1a1.port_b_address_clock = "clock0";
defparam ram_block1a1.port_b_address_width = 11;
defparam ram_block1a1.port_b_byte_enable_clear = "none";
defparam ram_block1a1.port_b_data_in_clear = "none";
defparam ram_block1a1.port_b_data_out_clear = "none";
defparam ram_block1a1.port_b_data_out_clock = "none";
defparam ram_block1a1.port_b_data_width = 1;
defparam ram_block1a1.port_b_first_address = 0;
defparam ram_block1a1.port_b_first_bit_number = 1;
defparam ram_block1a1.port_b_last_address = 2047;
defparam ram_block1a1.port_b_logical_ram_depth = 2048;
defparam ram_block1a1.port_b_logical_ram_width = 8;
defparam ram_block1a1.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a1.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a1.ram_block_type = "M4K";
defparam ram_block1a1.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a2(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[2]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a2_PORTBDATAOUT_bus));
defparam ram_block1a2.data_interleave_offset_in_bits = 1;
defparam ram_block1a2.data_interleave_width_in_bits = 1;
defparam ram_block1a2.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component2|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a2.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a2.operation_mode = "dual_port";
defparam ram_block1a2.port_a_address_clear = "none";
defparam ram_block1a2.port_a_address_width = 11;
defparam ram_block1a2.port_a_byte_enable_clear = "none";
defparam ram_block1a2.port_a_data_in_clear = "none";
defparam ram_block1a2.port_a_data_out_clear = "none";
defparam ram_block1a2.port_a_data_out_clock = "none";
defparam ram_block1a2.port_a_data_width = 1;
defparam ram_block1a2.port_a_first_address = 0;
defparam ram_block1a2.port_a_first_bit_number = 2;
defparam ram_block1a2.port_a_last_address = 2047;
defparam ram_block1a2.port_a_logical_ram_depth = 2048;
defparam ram_block1a2.port_a_logical_ram_width = 8;
defparam ram_block1a2.port_a_write_enable_clear = "none";
defparam ram_block1a2.port_b_address_clear = "none";
defparam ram_block1a2.port_b_address_clock = "clock0";
defparam ram_block1a2.port_b_address_width = 11;
defparam ram_block1a2.port_b_byte_enable_clear = "none";
defparam ram_block1a2.port_b_data_in_clear = "none";
defparam ram_block1a2.port_b_data_out_clear = "none";
defparam ram_block1a2.port_b_data_out_clock = "none";
defparam ram_block1a2.port_b_data_width = 1;
defparam ram_block1a2.port_b_first_address = 0;
defparam ram_block1a2.port_b_first_bit_number = 2;
defparam ram_block1a2.port_b_last_address = 2047;
defparam ram_block1a2.port_b_logical_ram_depth = 2048;
defparam ram_block1a2.port_b_logical_ram_width = 8;
defparam ram_block1a2.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a2.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a2.ram_block_type = "M4K";
defparam ram_block1a2.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a3(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[3]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a3_PORTBDATAOUT_bus));
defparam ram_block1a3.data_interleave_offset_in_bits = 1;
defparam ram_block1a3.data_interleave_width_in_bits = 1;
defparam ram_block1a3.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component2|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a3.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a3.operation_mode = "dual_port";
defparam ram_block1a3.port_a_address_clear = "none";
defparam ram_block1a3.port_a_address_width = 11;
defparam ram_block1a3.port_a_byte_enable_clear = "none";
defparam ram_block1a3.port_a_data_in_clear = "none";
defparam ram_block1a3.port_a_data_out_clear = "none";
defparam ram_block1a3.port_a_data_out_clock = "none";
defparam ram_block1a3.port_a_data_width = 1;
defparam ram_block1a3.port_a_first_address = 0;
defparam ram_block1a3.port_a_first_bit_number = 3;
defparam ram_block1a3.port_a_last_address = 2047;
defparam ram_block1a3.port_a_logical_ram_depth = 2048;
defparam ram_block1a3.port_a_logical_ram_width = 8;
defparam ram_block1a3.port_a_write_enable_clear = "none";
defparam ram_block1a3.port_b_address_clear = "none";
defparam ram_block1a3.port_b_address_clock = "clock0";
defparam ram_block1a3.port_b_address_width = 11;
defparam ram_block1a3.port_b_byte_enable_clear = "none";
defparam ram_block1a3.port_b_data_in_clear = "none";
defparam ram_block1a3.port_b_data_out_clear = "none";
defparam ram_block1a3.port_b_data_out_clock = "none";
defparam ram_block1a3.port_b_data_width = 1;
defparam ram_block1a3.port_b_first_address = 0;
defparam ram_block1a3.port_b_first_bit_number = 3;
defparam ram_block1a3.port_b_last_address = 2047;
defparam ram_block1a3.port_b_logical_ram_depth = 2048;
defparam ram_block1a3.port_b_logical_ram_width = 8;
defparam ram_block1a3.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a3.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a3.ram_block_type = "M4K";
defparam ram_block1a3.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a4(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[4]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a4_PORTBDATAOUT_bus));
defparam ram_block1a4.data_interleave_offset_in_bits = 1;
defparam ram_block1a4.data_interleave_width_in_bits = 1;
defparam ram_block1a4.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component2|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a4.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a4.operation_mode = "dual_port";
defparam ram_block1a4.port_a_address_clear = "none";
defparam ram_block1a4.port_a_address_width = 11;
defparam ram_block1a4.port_a_byte_enable_clear = "none";
defparam ram_block1a4.port_a_data_in_clear = "none";
defparam ram_block1a4.port_a_data_out_clear = "none";
defparam ram_block1a4.port_a_data_out_clock = "none";
defparam ram_block1a4.port_a_data_width = 1;
defparam ram_block1a4.port_a_first_address = 0;
defparam ram_block1a4.port_a_first_bit_number = 4;
defparam ram_block1a4.port_a_last_address = 2047;
defparam ram_block1a4.port_a_logical_ram_depth = 2048;
defparam ram_block1a4.port_a_logical_ram_width = 8;
defparam ram_block1a4.port_a_write_enable_clear = "none";
defparam ram_block1a4.port_b_address_clear = "none";
defparam ram_block1a4.port_b_address_clock = "clock0";
defparam ram_block1a4.port_b_address_width = 11;
defparam ram_block1a4.port_b_byte_enable_clear = "none";
defparam ram_block1a4.port_b_data_in_clear = "none";
defparam ram_block1a4.port_b_data_out_clear = "none";
defparam ram_block1a4.port_b_data_out_clock = "none";
defparam ram_block1a4.port_b_data_width = 1;
defparam ram_block1a4.port_b_first_address = 0;
defparam ram_block1a4.port_b_first_bit_number = 4;
defparam ram_block1a4.port_b_last_address = 2047;
defparam ram_block1a4.port_b_logical_ram_depth = 2048;
defparam ram_block1a4.port_b_logical_ram_width = 8;
defparam ram_block1a4.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a4.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a4.ram_block_type = "M4K";
defparam ram_block1a4.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a5(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[5]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a5_PORTBDATAOUT_bus));
defparam ram_block1a5.data_interleave_offset_in_bits = 1;
defparam ram_block1a5.data_interleave_width_in_bits = 1;
defparam ram_block1a5.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component2|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a5.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a5.operation_mode = "dual_port";
defparam ram_block1a5.port_a_address_clear = "none";
defparam ram_block1a5.port_a_address_width = 11;
defparam ram_block1a5.port_a_byte_enable_clear = "none";
defparam ram_block1a5.port_a_data_in_clear = "none";
defparam ram_block1a5.port_a_data_out_clear = "none";
defparam ram_block1a5.port_a_data_out_clock = "none";
defparam ram_block1a5.port_a_data_width = 1;
defparam ram_block1a5.port_a_first_address = 0;
defparam ram_block1a5.port_a_first_bit_number = 5;
defparam ram_block1a5.port_a_last_address = 2047;
defparam ram_block1a5.port_a_logical_ram_depth = 2048;
defparam ram_block1a5.port_a_logical_ram_width = 8;
defparam ram_block1a5.port_a_write_enable_clear = "none";
defparam ram_block1a5.port_b_address_clear = "none";
defparam ram_block1a5.port_b_address_clock = "clock0";
defparam ram_block1a5.port_b_address_width = 11;
defparam ram_block1a5.port_b_byte_enable_clear = "none";
defparam ram_block1a5.port_b_data_in_clear = "none";
defparam ram_block1a5.port_b_data_out_clear = "none";
defparam ram_block1a5.port_b_data_out_clock = "none";
defparam ram_block1a5.port_b_data_width = 1;
defparam ram_block1a5.port_b_first_address = 0;
defparam ram_block1a5.port_b_first_bit_number = 5;
defparam ram_block1a5.port_b_last_address = 2047;
defparam ram_block1a5.port_b_logical_ram_depth = 2048;
defparam ram_block1a5.port_b_logical_ram_width = 8;
defparam ram_block1a5.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a5.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a5.ram_block_type = "M4K";
defparam ram_block1a5.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a6(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[6]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a6_PORTBDATAOUT_bus));
defparam ram_block1a6.data_interleave_offset_in_bits = 1;
defparam ram_block1a6.data_interleave_width_in_bits = 1;
defparam ram_block1a6.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component2|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a6.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a6.operation_mode = "dual_port";
defparam ram_block1a6.port_a_address_clear = "none";
defparam ram_block1a6.port_a_address_width = 11;
defparam ram_block1a6.port_a_byte_enable_clear = "none";
defparam ram_block1a6.port_a_data_in_clear = "none";
defparam ram_block1a6.port_a_data_out_clear = "none";
defparam ram_block1a6.port_a_data_out_clock = "none";
defparam ram_block1a6.port_a_data_width = 1;
defparam ram_block1a6.port_a_first_address = 0;
defparam ram_block1a6.port_a_first_bit_number = 6;
defparam ram_block1a6.port_a_last_address = 2047;
defparam ram_block1a6.port_a_logical_ram_depth = 2048;
defparam ram_block1a6.port_a_logical_ram_width = 8;
defparam ram_block1a6.port_a_write_enable_clear = "none";
defparam ram_block1a6.port_b_address_clear = "none";
defparam ram_block1a6.port_b_address_clock = "clock0";
defparam ram_block1a6.port_b_address_width = 11;
defparam ram_block1a6.port_b_byte_enable_clear = "none";
defparam ram_block1a6.port_b_data_in_clear = "none";
defparam ram_block1a6.port_b_data_out_clear = "none";
defparam ram_block1a6.port_b_data_out_clock = "none";
defparam ram_block1a6.port_b_data_width = 1;
defparam ram_block1a6.port_b_first_address = 0;
defparam ram_block1a6.port_b_first_bit_number = 6;
defparam ram_block1a6.port_b_last_address = 2047;
defparam ram_block1a6.port_b_logical_ram_depth = 2048;
defparam ram_block1a6.port_b_logical_ram_width = 8;
defparam ram_block1a6.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a6.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a6.ram_block_type = "M4K";
defparam ram_block1a6.safe_write = "err_on_2clk";

cycloneii_ram_block ram_block1a7(
	.portawe(wren_a),
	.portaaddrstall(gnd),
	.portbrewe(vcc),
	.portbaddrstall(gnd),
	.clk0(clock0),
	.clk1(gnd),
	.ena0(vcc),
	.ena1(vcc),
	.clr0(gnd),
	.clr1(gnd),
	.portadatain({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,
gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,data_a[7]}),
	.portaaddr({gnd,gnd,gnd,gnd,gnd,address_a[10],address_a[9],address_a[8],address_a[7],address_a[6],address_a[5],address_a[4],address_a[3],address_a[2],address_a[1],address_a[0]}),
	.portabyteenamasks(1'b1),
	.portbdatain(1'b0),
	.portbaddr({gnd,gnd,gnd,gnd,gnd,address_b[10],address_b[9],address_b[8],address_b[7],address_b[6],address_b[5],address_b[4],address_b[3],address_b[2],address_b[1],address_b[0]}),
	.portbbyteenamasks(1'b1),
	.portadataout(),
	.portbdataout(ram_block1a7_PORTBDATAOUT_bus));
defparam ram_block1a7.data_interleave_offset_in_bits = 1;
defparam ram_block1a7.data_interleave_width_in_bits = 1;
defparam ram_block1a7.logical_ram_name = "alt3pram:alt3pram_component|altdpram:altdpram_component2|altsyncram:ram_block|altsyncram_uqt1:auto_generated|ALTSYNCRAM";
defparam ram_block1a7.mixed_port_feed_through_mode = "dont_care";
defparam ram_block1a7.operation_mode = "dual_port";
defparam ram_block1a7.port_a_address_clear = "none";
defparam ram_block1a7.port_a_address_width = 11;
defparam ram_block1a7.port_a_byte_enable_clear = "none";
defparam ram_block1a7.port_a_data_in_clear = "none";
defparam ram_block1a7.port_a_data_out_clear = "none";
defparam ram_block1a7.port_a_data_out_clock = "none";
defparam ram_block1a7.port_a_data_width = 1;
defparam ram_block1a7.port_a_first_address = 0;
defparam ram_block1a7.port_a_first_bit_number = 7;
defparam ram_block1a7.port_a_last_address = 2047;
defparam ram_block1a7.port_a_logical_ram_depth = 2048;
defparam ram_block1a7.port_a_logical_ram_width = 8;
defparam ram_block1a7.port_a_write_enable_clear = "none";
defparam ram_block1a7.port_b_address_clear = "none";
defparam ram_block1a7.port_b_address_clock = "clock0";
defparam ram_block1a7.port_b_address_width = 11;
defparam ram_block1a7.port_b_byte_enable_clear = "none";
defparam ram_block1a7.port_b_data_in_clear = "none";
defparam ram_block1a7.port_b_data_out_clear = "none";
defparam ram_block1a7.port_b_data_out_clock = "none";
defparam ram_block1a7.port_b_data_width = 1;
defparam ram_block1a7.port_b_first_address = 0;
defparam ram_block1a7.port_b_first_bit_number = 7;
defparam ram_block1a7.port_b_last_address = 2047;
defparam ram_block1a7.port_b_logical_ram_depth = 2048;
defparam ram_block1a7.port_b_logical_ram_width = 8;
defparam ram_block1a7.port_b_read_enable_write_enable_clear = "none";
defparam ram_block1a7.port_b_read_enable_write_enable_clock = "clock0";
defparam ram_block1a7.ram_block_type = "M4K";
defparam ram_block1a7.safe_write = "err_on_2clk";

endmodule
