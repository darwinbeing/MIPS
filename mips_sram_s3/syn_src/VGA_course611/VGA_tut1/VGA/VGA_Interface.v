module VGA_Interface(

//	Clock Input
  input CLK,	//	27 MHz

  input RST,	//	

//	Push Button
  input [3:0] KEY,      //	Pushbutton[3:0]

// SW
  input [17:0] SW,

// CPU
  input [31:0] IO_DataAddr,
  input [31:0] IO_DataIn,
  input        IO_DataWe,

// VGA
  output VGA_CLK,   						//	VGA Clock
  output VGA_HS,							//	VGA H_SYNC
  output VGA_VS,							//	VGA V_SYNC
  output VGA_BLANK,						//	VGA BLANK
  output VGA_SYNC,						//	VGA SYNC
  output [9:0] VGA_R,   						//	VGA Red[9:0]
  output [9:0] VGA_G,	 						//	VGA Green[9:0]
  output [9:0] VGA_B   						//	VGA Blue[9:0]
);


// reset delay gives some time for peripherals to initialize
wire       VGA_CTRL_CLK;
wire       AUD_CTRL_CLK;
wire [9:0] mVGA_R;
wire [9:0] mVGA_G;
wire [9:0] mVGA_B;
wire [9:0] mCoord_X;
wire [9:0] mCoord_Y;


//--------------------------------------------------------------------
Display Display
( 
  .clka         (VGA_CTRL_CLK),
  .pixel_count  (mCoord_X), 
  .line_count   (mCoord_Y), 

  .clkb         (CLK),
  .mem_waddr    (IO_DataAddr),
  .mem_wdata    (IO_DataIn),
  .mem_web      (IO_DataWe),

  .red          (mVGA_R),
  .green        (mVGA_G),
  .blue         (mVGA_B)
);

VGA_Audio_PLL 	p1 (	
	.areset(RST),
	.inclk0(CLK),
	.c0(VGA_CTRL_CLK),
	.c1(AUD_CTRL_CLK),
	.c2(VGA_CLK)
);

VGA_Sync iVGA_Sync
(
   .iCLK(VGA_CTRL_CLK),
   .iRST_N(~RST),
   .iRed(mVGA_R),
   .iGreen(mVGA_G),
   .iBlue(mVGA_B),

   // pixel coordinates
   .px(mCoord_X),
   .py(mCoord_Y),

   // VGA Side
   .VGA_R(VGA_R),
   .VGA_G(VGA_G),
   .VGA_B(VGA_B),
   .VGA_H_SYNC(VGA_HS),
   .VGA_V_SYNC(VGA_VS),
   .VGA_SYNC(VGA_SYNC),
   .VGA_BLANK(VGA_BLANK)
);

endmodule

