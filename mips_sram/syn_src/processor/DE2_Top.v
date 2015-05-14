`include "MIPS1000_defines.v"

module DE2_Top
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_50,						//	50 MHz
		////////////////////	DPDT Switch		////////////////////
		SW,								//	Toggle Switch[17:0]
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
		LEDG							//	LED Green[8:0]
	);

////////////////////////	Clock Input	 	////////////////////////
input			CLOCK_50;				//	50 MHz
////////////////////////	DPDT Switch		////////////////////////
input	[17:0]	SW;						//	Toggle Switch[17:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digit 0
output	[6:0]	HEX1;					//	Seven Segment Digit 1
output	[6:0]	HEX2;					//	Seven Segment Digit 2
output	[6:0]	HEX3;					//	Seven Segment Digit 3
output	[6:0]	HEX4;					//	Seven Segment Digit 4
output	[6:0]	HEX5;					//	Seven Segment Digit 5
output	[6:0]	HEX6;					//	Seven Segment Digit 6
output	[6:0]	HEX7;					//	Seven Segment Digit 7
////////////////////////////	LED		////////////////////////////
output	[8:0]	LEDG;					//	LED Green[8:0]
//output	[17:0]	LEDR;					//	LED Red[17:0]

wire [`MEM_ADDR_WIDTH-1:0] abus1;
wire [`MEM_ADDR_WIDTH-1:0] abus2;
wire [31:0] dbus1;  
wire [31:0] dbus2o;

/* Debug 
wire       CLOCK_1HZ;
assign	LEDG = PCOut;

SEG7_LUT s0(IROut[3:0],   HEX0);
SEG7_LUT s1(IROut[7:4],   HEX1);
SEG7_LUT s2(IROut[11:8],  HEX2);
SEG7_LUT s3(IROut[15:12], HEX3);

SEG7_LUT s4(IROut[19:16], HEX4);
SEG7_LUT s5(IROut[23:20], HEX5);
SEG7_LUT s6(IROut[27:24], HEX6);
SEG7_LUT s7(IROut[31:28], HEX7);
*/

reg clk;

always @ (posedge CLOCK_50)
  clk <= SW[0];


PPS_Top PPS_Top
(
  .clk(clk), 
  .rst(SW[1]),
  .abus1(abus1), 
  .abus2(abus2), 
  .dbus1(dbus1),
  .dbus2o(dbus2o)
);

endmodule
