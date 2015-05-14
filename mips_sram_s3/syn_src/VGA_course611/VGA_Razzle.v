module VGA_Interface(

//	Clock Input
  input CLOCK_50,	//	50 MHz
  input CLOCK_27,     //      27 MHz

//	Push Button
  input [3:0] KEY,      //	Pushbutton[3:0]

// SW
  input [17:0] SW,

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
wire		   VGA_CTRL_CLK;
wire		   AUD_CTRL_CLK;
wire       rst;
wire       video_on;
wire [9:0] mVGA_R;
wire [9:0] mVGA_G;
wire [9:0] mVGA_B;
wire [9:0] mCoord_X;
wire [9:0] mCoord_Y;


//--------------------------------------------------------------------
//--------------------------------------------------------------------

Reset_Control Reset_Control
(
  .clk          (CLOCK_50), 
  .rst_in       (SW[0]), 
  .rst_out      (rst)
);

wire stop = 1'b0;

Razzle_Display iRazzle_Display
( 
  .iCLK         (CLOCK_27),
  .pixel_count  (mCoord_X), 
  .line_count   (mCoord_Y), 
  .VGA_V_SYNC   (VGA_VS),
  .stop         (stop),
  .video_on     (video_on),

  .red          (mVGA_R),
  .green        (mVGA_G),
  .blue         (mVGA_B)
);

VGA_Audio_PLL 	p1 (	
	.areset(rst),
	.inclk0(CLOCK_27),
	.c0(VGA_CTRL_CLK),
	.c1(AUD_CTRL_CLK),
	.c2(VGA_CLK)
);

VGA_Sync iVGA_Sync
(
   .iCLK(VGA_CTRL_CLK),
   .iRST_N(~rst),
   .iRed(mVGA_R),
   .iGreen(mVGA_G),
   .iBlue(mVGA_B),

   // pixel coordinates
   .px(mCoord_X),
   .py(mCoord_Y),
   .video_on(video_on),

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

