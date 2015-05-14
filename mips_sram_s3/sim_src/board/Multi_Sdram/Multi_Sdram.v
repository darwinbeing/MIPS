`include "Sdram_Params.h"

//===============================================================
// SDRAM controller top-level
//===============================================================
module Multi_Sdram(	//	Host Side
					oHS_DATA,iHS_DATA,iHS_ADDR,iHS_RD,iHS_WR,oHS_Done,
					//	Async Side 1
					oAS1_DATABUS,iAS1_DATA,iAS1_ADDR,iAS1_WR, iAS1_RD,
					//	Async Side 2
					oAS2_DATA,iAS2_DATA,iAS2_ADDR,iAS2_WR_n,
					//	Async Side 3
					oAS3_DATA,iAS3_DATA,iAS3_ADDR,iAS3_WR_n,
					//	Control Signals
					iSelect,iCLK, iRST_n, oSDR_TxD, oSDR_RxD, iMBE,
					//	SDRAM Interface
        			SA,BA,CS_N,CKE,RAS_N,CAS_N,WE_N,DQ,DQM,SDR_CLK);
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
input			iAS1_WR;
input			iAS1_RD;
output	[31:0]	oAS1_DATABUS;  // 32-bit databus

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
//	Control Signals
input	[1:0]	iSelect;
input			iCLK;
input			iRST_n;
input  [3:0]  iMBE;
output    oSDR_RxD;
output    oSDR_TxD;

//	SDRAM Interface
output	[11:0]	SA;
output	[1:0]	BA;
output			CS_N;
output			CKE;
output			RAS_N;
output			CAS_N;
output			WE_N;
inout	[15:0]	DQ;
output	[1:0]	DQM;
output			SDR_CLK;

//	Internal SDRAM Link
wire	[15:0]	oAS1_DATA;
wire	[21:0]	mSDR_ADDR;
wire	[15:0]	mM2C_DATA;
wire	[15:0]	mC2M_DATA;
wire			mSDR_RD;
wire			mSDR_WR;
wire			mSDR_Done;
wire	[1:0]	mSDR_DM;

assign oAS1_DATABUS = oSDR_RxD ? {16'hz, oAS1_DATA} : 32'hz;

Sdram_Multiplexer	Sdram_Multiplexer	(	//	Host Side
							oHS_DATA,iHS_DATA,iHS_ADDR,iHS_RD,iHS_WR,oHS_Done,
							//	Async Side 1
							oAS1_DATA,iAS1_DATA,iAS1_ADDR, iAS1_WR, iAS1_RD,
							//	Async Side 2
							oAS2_DATA,iAS2_DATA,iAS2_ADDR,iAS2_WR_n,
							//	Async Side 3
							oAS3_DATA,iAS3_DATA,iAS3_ADDR,iAS3_WR_n,
							//	SDRAM Side
							mM2C_DATA,mC2M_DATA,mSDR_ADDR,mSDR_RD,mSDR_WR,
							//	Control Signals
              mSDR_Done, 
              mSDR_TxD, // in
              oSDR_TxD, // out 
              mSDR_RxD, // in 
              oSDR_RxD, // out 
              iMBE,     // in
              mSDR_DM,  // out
							iSelect,iCLK,iRST_n	);

Sdram_Controller	Sdram_Controller	(	//	HOST
  .REF_CLK(iCLK),
  .RESET_N(iRST_n),
  .ADDR({1'b0,mSDR_ADDR}),
  .WR(mSDR_WR),
  .RD(mSDR_RD),
  .DONE(mSDR_Done),
  .DATAIN(mM2C_DATA),
  .DATAOUT(mC2M_DATA),
  .IN_REQ(mSDR_TxD),
  .OUT_VALID(mSDR_RxD),
  .DM(mSDR_DM),
  .LENGTH(`LENGTH),
  
  //	SDRAM
  .SA(SA),
  .BA(BA),
  .CS_N(CS_N),
  .CKE(CKE),
  .RAS_N(RAS_N),
  .CAS_N(CAS_N),
  .WE_N(WE_N),
  .DQ(DQ),
  .DQM(DQM),
  .SDR_CLK(SDR_CLK)
);

endmodule
