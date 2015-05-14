module SDRAM_Top
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLK,							//	50 MHz
    reset_n,
 		mSDR_AS_WR_n,
    mSDR_AS_DATAIN,
    mSDR_AS_ADDR,
    mSDR_Select
	);
  
`include "Sdram_Params.h"

////////////////////////	Clock Input	 	////////////////////////
input			CLK;					//	50 MHz

// Reset
input			reset_n;

// Data Write/Read  enable
input 		mSDR_AS_WR_n;

// Data to be written into SDRAM controller
input [15:0] mSDR_AS_DATAIN;

// Data Read/Write
input [21:0] mSDR_AS_ADDR;
input  [2:0] mSDR_Select;

//	SDRAM
wire [21:0] mSD_ADDR;
wire [15:0] mSD2RS_DATA,mRS2SD_DATA;
wire mSD_WR,mSD_RD,mSD_Done;


//	SDRAM Async Port
wire [15:0] mSDR_AS_DATAOUT_1;
wire [15:0] mSDR_AS_DATAOUT_2;
wire [15:0] mSDR_AS_DATAOUT_3;

//wire [21:0] mSDR_AS_ADDR_1	;
wire [21:0] mSDR_AS_ADDR_2 = 0	;
wire [21:0] mSDR_AS_ADDR_3 = 0	;

//wire [15:0] mSDR_AS_DATAIN_1;
wire [15:0] mSDR_AS_DATAIN_2 = 0;
wire [15:0] mSDR_AS_DATAIN_3 = 0;

wire 		mSDR_AS_WR_n_1	= 0;
wire 		mSDR_AS_WR_n_2	= 0;
wire 		mSDR_AS_WR_n_3	= 0;

// SDRAM interface
//wire     [`ASIZE-1:0]            addr;
wire    [11:0]                  addr;
wire    [1:0]                   ba;
wire    [1:0]                   cs_n;
wire                            cke;
wire                            ras_n;
wire                            cas_n;
wire                            we_n;
wire    [`DSIZE-1:0]            dq;
wire    [`DSIZE/8-1:0]          dqm;
wire                            clk;

Multi_Sdram	Multi_Sdram	
(	
  //	Host Side
  .oHS_DATA(mSD2RS_DATA),
  .iHS_DATA(mRS2SD_DATA),
  .iHS_ADDR(mSD_ADDR),
  .iHS_RD  (mSD_RD),
  .iHS_WR  (mSD_WR),
  .oHS_Done(mSD_Done),
           
  //	Async Side 1
  .oAS1_DATA(mSDR_AS_DATAOUT_1),
  .iAS1_DATA(mSDR_AS_DATAIN),
  .iAS1_ADDR(mSDR_AS_ADDR),
  .iAS1_WR_n(mSDR_AS_WR_n),

  //	Async Side 2
 .oAS2_DATA(mSDR_AS_DATAOUT_2),
 .iAS2_DATA(mSDR_AS_DATAIN_2),
 .iAS2_ADDR(mSDR_AS_ADDR_2),
 .iAS2_WR_n(mSDR_AS_WR_n_2),

  //	Async Side 3
 .oAS3_DATA(mSDR_AS_DATAOUT_3),
 .iAS3_DATA(mSDR_AS_DATAIN_3),
 .iAS3_ADDR(mSDR_AS_ADDR_3),
 .iAS3_WR_n(mSDR_AS_WR_n_3),

	//	Control Signals
  .iSelect(mSDR_Select),
  .iCLK   (CLK),
  .iRST_n (reset_n),

	//	SDRAM Interface
  .SA(addr),
  .BA(ba),
  .CS_N(cs_n),
  .CKE(cke),
  .RAS_N(ras_n),
	.CAS_N(cas_n),
  .WE_N(we_n),
  .DQ(dq),
  .DQM(dqm),
  .SDR_CLK(clk)
);

mt48lc8m16a2 m0      
( 
  .Dq(dq),
  .Addr(addr),
  .Ba(ba),
  .Clk(clk),
  .Cke(cke),
  .Cs_n(cs_n[0]),
  .Cas_n(cas_n),
  .Ras_n(ras_n),
  .We_n(we_n),
  .Dqm(dqm)
);


endmodule

`timescale 1ns/1ns
module TestBench;
  reg CLK;							//	50 MHz
  reg reset_n;
  reg mSDR_AS_WR_n;
  reg [15:0] mSDR_AS_DATAIN;
  reg [21:0] mSDR_AS_ADDR;
  reg  [2:0] mSDR_Select;

  integer i;
  reg [15:0] j;
  reg [15:0] start_value, read_data;

  parameter NLOOP = 64;

  `include "Sdram_Params.h"

  SDRAM_Top DUT
    (
      CLK,
      reset_n,
      mSDR_AS_WR_n,
      mSDR_AS_DATAIN,
      mSDR_AS_ADDR,
      mSDR_Select
    );

  always #10 CLK = ~CLK;

  initial begin
    $readmemh("simpletest.txt", DUT.m0.Bank0);
    mSDR_AS_WR_n = 0;
    mSDR_AS_ADDR= 0;
    mSDR_AS_DATAIN= 0;
    mSDR_Select = 0;
    CLK = 1;
    reset_n = 0; 
    #100 reset_n = 1;

    #99500
    mSDR_Select = 1;

    //----------------------------------------
    // Try to read some data 
    //----------------------------------------
    mSDR_AS_WR_n = 0;

    for (i = 0; i < NLOOP; i = i + 1) begin
      @(posedge DUT.Multi_Sdram.Sdram_Multiplexer.iSDR_Done);
    end

    // wait until the last sdram read is done
    @(negedge DUT.Multi_Sdram.Sdram_Multiplexer.iSDR_Done)

    //----------------------------------------
    // Write 
    //----------------------------------------
    mSDR_AS_WR_n = 1;
    mSDR_AS_ADDR= 0;
    mSDR_AS_DATAIN= 16'h0;
    start_value = mSDR_AS_DATAIN;
    
    for (i = 0; i < NLOOP; i = i + 1) begin
      @(posedge DUT.Multi_Sdram.Sdram_Controller.IN_REQ);
       //------------------------------------------------------
       // Add half-cycle delay so that the data will be 
       // incremented only 4 times (waveforms)
       //------------------------------------------------------
        @(negedge CLK); 
        while (DUT.Multi_Sdram.Sdram_Controller.IN_REQ) begin
          mSDR_AS_DATAIN = mSDR_AS_DATAIN + 16'b1;
          @(negedge CLK); 
        end
    end
    
    // wait until the last sdram write is done
    @(negedge DUT.Multi_Sdram.Sdram_Multiplexer.iSDR_Done)

    //----------------------------------------
    // Read what are written
    //----------------------------------------
    mSDR_AS_WR_n = 0;
    mSDR_AS_ADDR= 0;
    j = 0;

    for (i = 0; i < NLOOP; i = i + 1) begin
      /* wait until valid output data */
      @(posedge DUT.Multi_Sdram.Sdram_Controller.OUT_VALID);

      while(DUT.Multi_Sdram.Sdram_Controller.OUT_VALID) begin

        /* capture at the middle of the data */
        @(negedge CLK); 
        read_data = DUT.Multi_Sdram.Sdram_Controller.DATAOUT;

        /* Check data */
        if (read_data != start_value + j) begin
          $display($time,, "Read error read %h expected %h", read_data, (start_value + j));
          $stop;
        end

        /* j is not incremented when OUT_VALID is 0 at the negative clock */
        if (!DUT.Multi_Sdram.Sdram_Multiplexer.iSDR_Done)
          j = j + 1;
      end
    end

    $stop;
  end

  /* Address plus 4 when iSDR_Done is asserted */
  always @(negedge DUT.Multi_Sdram.Sdram_Multiplexer.iSDR_Done) begin
    mSDR_AS_ADDR = mSDR_AS_ADDR + SC_BL;
  end


endmodule 
