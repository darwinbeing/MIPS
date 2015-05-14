module Sdram_Multiplexer	(	//	Host Side
							oHS_DATA,iHS_DATA,iHS_ADDR,iHS_RD,iHS_WR,oHS_Done,
							//	Async Side 1
							oAS1_DATA,iAS1_DATA,iAS1_ADDR,iAS1_WR,iAS1_RD, 
							//	Async Side 2
							oAS2_DATA,iAS2_DATA,iAS2_ADDR,iAS2_WR_n,
							//	Async Side 3
							oAS3_DATA,iAS3_DATA,iAS3_ADDR,iAS3_WR_n,
							//	SDRAM Side
							oSDR_DATA,iSDR_DATA,oSDR_ADDR,oSDR_RD,oSDR_WR,
							//	Control Signals
              iSDR_Done, 
              iSDR_TxD, 
              oSDR_TxD, 
              iSDR_RxD,
              oSDR_RxD, 
              iMBE,
              oSDR_DM,
							iSelect,iCLK,iRST_n	);
//	Host Side
input	[21:0]	iHS_ADDR;
input	[15:0]	iHS_DATA;
input			iHS_RD;
input			iHS_WR;
output	[15:0]	oHS_DATA;
output			oHS_Done;

//	Async Side 1
input	[21:0]	iAS1_ADDR;
input	[15:0]	iAS1_DATA;
//input			iAS1_WR_n;
input			iAS1_WR;
input			iAS1_RD;
output	[15:0]	oAS1_DATA;

//	Async Side 2
input	[21:0]	iAS2_ADDR;
input	[15:0]	iAS2_DATA;
input			iAS2_WR_n;
output	[15:0]	oAS2_DATA;

//	Async Side 3
input	[21:0]	iAS3_ADDR;
input	[15:0]	iAS3_DATA;
input			iAS3_WR_n;
output	[15:0]	oAS3_DATA;

//	SDRAM Side
input	[15:0]	iSDR_DATA;
output	[21:0]	oSDR_ADDR;
output	[15:0]	oSDR_DATA;
output			oSDR_RD;
output			oSDR_WR;

//	Control Signals
input			iSDR_Done;
input			iSDR_TxD;
input			iSDR_RxD;
output 	  oSDR_RxD;
output 	  oSDR_TxD;
output [1:0] oSDR_DM;
input  [3:0] iMBE;

input	[1:0]	iSelect;
input			iCLK;
input			iRST_n;

//	Internal Register
reg		[15:0]	mSDR_DATA;
reg		[1:0]	ST;
reg				mSDR_RD;
reg				mSDR_WR;
reg				mSDR_RxD;
reg		[1:0]	mSDR_DM;
reg         flip;

wire			mAS_WR_n;

//	Host Side Select
assign	oHS_DATA	=	(iSelect==0)	?	iSDR_DATA	:	16'h0000;
assign	oHS_Done	=	(iSelect==0)	?	iSDR_Done	:	1'b1	;
//	ASync Side
assign	oAS1_DATA	=	(iSelect==1)	?	mSDR_DATA	:	16'h0000;
assign	oAS2_DATA	=	(iSelect==2)	?	mSDR_DATA	:	16'h0000;
assign	oAS3_DATA	=	(iSelect==3)	?	mSDR_DATA	:	16'h0000;
//	SDRAM Side
assign	oSDR_DATA	=	(iSelect==0)	?	iHS_DATA	:
						(iSelect==1)	?	iAS1_DATA	:
						(iSelect==2)	?	iAS2_DATA	: iAS3_DATA	;
assign	oSDR_ADDR	= 	(iSelect==0)	?	iHS_ADDR	:
						(iSelect==1)	?	iAS1_ADDR	:
						(iSelect==2)	?	iAS2_ADDR	: iAS3_ADDR	;
assign	oSDR_RD		=	(iSelect==0)	?	iHS_RD		:	mSDR_RD	;
assign	oSDR_WR		=	(iSelect==0)	?	iHS_WR		:	mSDR_WR	;
assign	oSDR_RxD  =	(iSelect==0)	?	1'b0 : mSDR_RxD	;
assign	oSDR_TxD  =	(iSelect==0)	?	1'b0 : iSDR_TxD	;
assign	oSDR_DM  =	(iSelect==0)	?	2'b0 : mSDR_DM	;

//	Internal Async Write/Read Select
assign	mAS_WR =	(iSelect==0)	?	1'b0		:
						(iSelect==1)	?	iAS1_WR :
						(iSelect==2)	?	iAS2_WR_n	: iAS3_WR_n	;

assign	mAS_RD =	(iSelect==0)	?	1'b0		:
						(iSelect==1)	?	iAS1_RD:
						(iSelect==2)	?	~iAS2_WR_n	: ~iAS3_WR_n	;

always@(posedge iCLK or negedge iRST_n) begin
  if (!iRST_n) begin
    flip <= 1'b0;
  end
  else begin
    if (iSDR_TxD) begin
      flip <= ~flip;
      mSDR_DM <= flip ? ~iMBE[1:0] : ~iMBE[3:2]; 
    end
    else begin
      mSDR_DM <= ~iMBE[1:0];
    end
  end
end

always@(posedge iCLK or negedge iRST_n)
begin
	if(!iRST_n)
    mSDR_RxD <= 1'b0;
  else if (iSDR_RxD)
    mSDR_RxD <= 1'b1;
  else
    mSDR_RxD <= 1'b0;
end


//	Async Control & SDRAM Data Lock
always@(posedge iCLK or negedge iRST_n)
begin
	if(!iRST_n)
	begin
		mSDR_DATA<=0;
		mSDR_RD<=0;
		mSDR_WR<=0;
		ST<=0;
	end
	else
	begin
		if(iSelect!=0)
		begin
			case(ST)
			0:	begin
            if(mAS_WR | mAS_RD)
            begin
              mSDR_RD<=mAS_RD;
              mSDR_WR<=mAS_WR;
              ST<=1;
            end
				  end
			1:	begin
					  //if(iSDR_Done)
            if (iSDR_Done) begin
              mSDR_RD<=0;
              mSDR_WR<=0;
              ST<=2;
            end

            if(iSDR_RxD) begin
              mSDR_DATA<=iSDR_DATA;
            end
				  end
			2:	ST<=3;
			3:	ST<=0;
			endcase
		end
		else
		begin
			mSDR_RD<=0;
			mSDR_WR<=0;
			ST<=0;		
		end
	end
end
endmodule
