module VGA_Interface(

//	Clock Input
  input CLOCK_50,	//	50 MHz
  input CLOCK_27,     //      27 MHz
//	Push Button
  input [3:0] KEY,      //	Pushbutton[3:0]
// SW[0]
  input SW,

// VGA
  output VGA_CLK,   						//	VGA Clock
  output VGA_HS,							//	VGA H_SYNC
  output VGA_VS,							//	VGA V_SYNC
  output VGA_BLANK,						//	VGA BLANK
  output VGA_SYNC,						//	VGA SYNC
  output [9:0] VGA_R,   						//	VGA Red[9:0]
  output [9:0] VGA_G,	 						//	VGA Green[9:0]
  output [9:0] VGA_B,   						//	VGA Blue[9:0]

// CPU
  input  [31:0] MEM_data_addr,
  input  [31:0] PROC_data_out, // from processor
  output [31:0] IODataOut,  // to processor
  output        DataOEN;
);
// reset delay gives some time for peripherals to initialize
wire       DLY_RST;
wire		   VGA_CTRL_CLK;
wire		   AUD_CTRL_CLK;
wire [9:0] mVGA_R;
wire [9:0] mVGA_G;
wire [9:0] mVGA_B;
wire [9:0] mCoord_X;
wire [9:0] mCoord_Y;
wire [9:0] paddle_y;
wire [9:0] ball_y;
wire [9:0] ball_x;
wire       reset_sync;
wire       up_sync;
wire       down_sync;

//wire [1:0] speed_x, speed_y;
wire [2:0] paddle_color;
wire [2:0] ball_color;
wire [5:0] paddle_height;
wire [3:0] ball_size;

//--------------------------------------------------------------------
// I/O register read
//--------------------------------------------------------------------

assign IODataOut = mem_data;

// Address decoding
assign isKEY_MMR     = (MEM_data_addr == 32'hfffffff0) ? 1'b1 : 1'b0;
assign isVGA_CTL_MMR = (MEM_data_addr == 32'hfffffff4) ? 1'b1 : 1'b0;
assign isVGA_POS_MMR = (MEM_data_addr == 32'hfffffff8) ? 1'b1 : 1'b0;
assign DataOEN = ~(isKEY_MMR | isVGA_CTL_MMR | isVGA_POS_MMR);

//--------------------------------------------------------------------
// Multiplexing RAM and I/O registers
//--------------------------------------------------------------------
always @ (posedge clk) begin
  case ({isKEY_MMR, isVGA_CTL_MMR, isVGA_POS_MMR}) 
    3'b100:
      mem_data <= KEY_MMR_out;
    3'b010:
      mem_data <= VGA_CTL_MMR_out;
    3'b001:
      mem_data <= VGA_POS_MMR_out;
    default: 
      mem_data <= 32'hz;
  endcase
end

//--------------------------------------------------------------------
// I/O register write
//--------------------------------------------------------------------
always @ (posedge clk) begin
  if (rst) begin
    VGA_CTL_MMR <= 32'b0;
    VGA_POS_MMR <= 32'b0;
  end
  else begin
    case ({isVGA_CTL_MMR, isVGA_POS_MMR}) 
      begin
      2'b10 : VGA_CTL_MMR <= PROC_data_out;
      2'b01 : VGA_POS_MMR <= PROC_data_out;
      default: ;
    endcase
  end
end

//--------------------------------------------------------------------
// Memory-mapped I/O registers
//--------------------------------------------------------------------
assign VGA_CTL_MMR_out = VGA_CTL_MMR;
assign VGA_POS_MMR_out = VGA_POS_MMR;
assign KEY_MMR_out     = KEY_MMR;

synchronizer s0 (CLOCK_50, KEY[3], reset_sync);
synchronizer s1 (CLOCK_50, KEY[2], up_sync);
synchronizer s2 (CLOCK_50, KEY[1], down_sync);

// Memory-mapped I/O address 0xFFFFFFF0 
assign KEY_MMR = {29'b0, up_sync, down_sync, reset_sync};

// Memory-mapped I/O address 0xFFFFFFF4 
assign paddle_color  = VGA_CTL_MMR[15:13];
assign ball_color    = VGA_CTL_MMR[12:10];
assign paddle_height = VGA_CTL_MMR[9:4];
assign ball_size     = VGA_CTL_MMR[3:0];

// Memory-mapped I/O address 0xFFFFFFF8 
assign paddle_y = VGA_POS_MMR[29:20];
assign ball_x   = VGA_POS_MMR[19:10];
assign ball_y   = VGA_POS_MMR[9:0];


//--------------------------------------------------------------------
//--------------------------------------------------------------------
Pong_Display iPong_Display
( 
  .pixel_count  (mCoord_X), 
  .line_count   (mCoord_Y), 
  .paddle_height(paddle_height),
  .paddle_color (paddle_color),
  .ball_color   (ball_color),
  .ball_size    (ball_size),
  .paddle_y     (paddle_y),
  .ball_y       (ball_y),
  .ball_x       (ball_x),

  .red  (mVGA_R),
  .green(mVGA_G),
  .blue (mVGA_B)
);

Reset_Control VGA_Reset_Control
(
  .clk(CLOCK_27), 
  .rst_in(SW), 
  .rst_out(DLY_RST)
);

VGA_Audio_PLL 	p1 (	
	//.areset(~DLY_RST),
	.areset(DLY_RST),
	.inclk0(CLOCK_27),
	.c0(VGA_CTRL_CLK),
	.c1(AUD_CTRL_CLK),
	.c2(VGA_CLK)
);

VGA_Sync iVGA_Sync
(
   .iCLK(VGA_CTRL_CLK),
   .iRST_N(~DLY_RST),
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

