//alt3pram CBX_SINGLE_OUTPUT_FILE="ON" INDATA_ACLR="OFF" INDATA_REG="INCLOCK" INTENDED_DEVICE_FAMILY=""Cyclone II"" LPM_FILE="../test_data/RAM3.mif" LPM_TYPE="alt3pram" NUMWORDS=256 OUTDATA_ACLR_A="OFF" OUTDATA_ACLR_B="OFF" OUTDATA_REG_A="UNREGISTERED" OUTDATA_REG_B="UNREGISTERED" RDADDRESS_ACLR_A="OFF" RDADDRESS_ACLR_B="OFF" RDADDRESS_REG_A="INCLOCK" RDADDRESS_REG_B="INCLOCK" RDCONTROL_ACLR_A="OFF" RDCONTROL_ACLR_B="OFF" RDCONTROL_REG_A="UNREGISTERED" RDCONTROL_REG_B="UNREGISTERED" WIDTH=8 WIDTHAD=8 WRITE_ACLR="OFF" WRITE_REG="INCLOCK" data inclock qa qb rdaddress_a rdaddress_b wraddress wren
//VERSION_BEGIN 10.0 cbx_mgl 2010:06:27:21:46:34:SJ cbx_stratixii 2010:06:27:21:44:37:SJ cbx_util_mgl 2010:06:27:21:44:37:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 1991-2010 Altera Corporation
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, Altera MegaCore Function License 
//  Agreement, or other applicable license agreement, including, 
//  without limitation, that your use is for the sole purpose of 
//  programming logic devices manufactured by Altera and sold by 
//  Altera or its authorized distributors.  Please refer to the 
//  applicable agreement for further details.



//synthesis_resources = alt3pram 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mgupm1
	( 
	data,
	inclock,
	qa,
	qb,
	rdaddress_a,
	rdaddress_b,
	wraddress,
	wren) /* synthesis synthesis_clearbox=1 */;
	input   [7:0]  data;
	input   inclock;
	output   [7:0]  qa;
	output   [7:0]  qb;
	input   [7:0]  rdaddress_a;
	input   [7:0]  rdaddress_b;
	input   [7:0]  wraddress;
	input   wren;

	wire  [7:0]   wire_mgl_prim1_qa;
	wire  [7:0]   wire_mgl_prim1_qb;

	alt3pram   mgl_prim1
	( 
	.data(data),
	.inclock(inclock),
	.qa(wire_mgl_prim1_qa),
	.qb(wire_mgl_prim1_qb),
	.rdaddress_a(rdaddress_a),
	.rdaddress_b(rdaddress_b),
	.wraddress(wraddress),
	.wren(wren));
	defparam
		mgl_prim1.indata_aclr = "OFF",
		mgl_prim1.indata_reg = "INCLOCK",
		mgl_prim1.intended_device_family = ""Cyclone II"",
		mgl_prim1.lpm_file = "../test_data/RAM3.mif",
		mgl_prim1.lpm_type = "alt3pram",
		mgl_prim1.numwords = 256,
		mgl_prim1.outdata_aclr_a = "OFF",
		mgl_prim1.outdata_aclr_b = "OFF",
		mgl_prim1.outdata_reg_a = "UNREGISTERED",
		mgl_prim1.outdata_reg_b = "UNREGISTERED",
		mgl_prim1.rdaddress_aclr_a = "OFF",
		mgl_prim1.rdaddress_aclr_b = "OFF",
		mgl_prim1.rdaddress_reg_a = "INCLOCK",
		mgl_prim1.rdaddress_reg_b = "INCLOCK",
		mgl_prim1.rdcontrol_aclr_a = "OFF",
		mgl_prim1.rdcontrol_aclr_b = "OFF",
		mgl_prim1.rdcontrol_reg_a = "UNREGISTERED",
		mgl_prim1.rdcontrol_reg_b = "UNREGISTERED",
		mgl_prim1.width = 8,
		mgl_prim1.widthad = 8,
		mgl_prim1.write_aclr = "OFF",
		mgl_prim1.write_reg = "INCLOCK";
	assign
		qa = wire_mgl_prim1_qa,
		qb = wire_mgl_prim1_qb;
endmodule //mgupm1
//VALID FILE
