`include "MIPS1000_defines.v"
`define RTL 1

module test_cache_sdram (clk, rst, sdram_rst, abus1, abus2, dbus1, dbus2i, dbus2o);
  // FPGA clock
  input clk;
  input rst;
  input sdram_rst;
  output [`MEM_ADDR_WIDTH-1:0] abus1;
  output [`MEM_ADDR_WIDTH-1:0] abus2;
  output [31:0] dbus1;  
  output [31:0] dbus2i;   // proc <- memory
  output [31:0] dbus2o;   // proc -> memory

  `include "Sdram_Params.h"

wire [31:0] inst_addr;
wire [31:0] inst;
wire [31:0] data_addr;
wire [31:0] data;
//wire  [3:0] bwe;

wire [31:0] dev_out, dev_in;
wire  [3:0] select;

wire [31:0] mem_databus;
wire [31:0] mem_adbus;
wire  [3:0] grant_mem;
wire  [3:0] dc_write;
wire dc_grant_mem, ic_grant_mem, dma_grant_mem;
wire dc_read, ic_read;
wire dc_ready, ic_ready;
wire dc_read_mem;
wire dc_write_mem;
wire ic_read_mem;
wire ic_write_mem = 1'b0;
wire dma_read_mem = 1'b0;
wire dma_write_mem = 1'b0;
wire rw_n;

// data cache access has highest priority
assign dc_grant_mem  = grant_mem[2];
assign ic_grant_mem  = grant_mem[1];
assign dma_grant_mem = grant_mem[0];

wire [31:0] check_pc;
wire [31:0] check_data;
wire [31:0] check_addr;

//	SDRAM controller
wire [21:0] mSD_ADDR;
wire [15:0] mSD2RS_DATA,mRS2SD_DATA;
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

wire mSDR_WR;
wire mSDR_RD;
wire mSDR_Done;

// SDRAM
wire    [11:0]                  sdr_addr;
wire                            sdr_clk;
wire    [1:0]                   ba;
wire    [1:0]                   cs_n;
wire                            cke;
wire                            ras_n;
wire                            cas_n;
wire                            we_n;
wire    [`DSIZE-1:0]            dq;
wire    [`DSIZE/8-1:0]          dqm;

//------------------------------------------------------
// Synchronize the machine states comparison between
// rtl(3-stage pipeline) and behavioral(1 cycle) model
//------------------------------------------------------
Test_Sync Test_Sync
(
  .clk        (clk),
  .rst        (rst),
  .data_read  (dc_read),
  .data_write (|dc_write),
  .data_ready (dc_ready),
  .inst_ready (ic_ready),
  .pc         (inst_addr),
  .data       (data),
  .addr       (data_addr),
  .check_en   (check_en),
  .check_pc   (check_pc),
  .check_data (check_data),
  .check_addr (check_addr)
);

//------------------------------------------------------
// 3-stage pipelined processor
//------------------------------------------------------
PPS_Processor Processor
(
  .clk        (clk),
  .rst        (rst),

  // instruction cache signals
  .inst_addr  (inst_addr),
  .inst_read  (ic_read),
  .inst_ready (ic_ready),
  .inst       (inst),

  // data cache signals
  .data_addr  (data_addr),
  .data       (data),
  .bwe        (dc_write),
  .data_read  (dc_read),
  .data_ready (dc_ready)
);
 
//------------------------------------------------------
// direct-mapped inst cache 
//------------------------------------------------------
`ifdef BEH
cache icache (
  .clk        (clk),
  // memory signals
  .read_mem   (ic_read_mem),
  .write_mem  (ic_write_mem),
  .grant_mem  (ic_grant_mem),
  .ready_mem  (ready_mem),
  .mem_databus(mem_databus),
  .mem_adbus  (mem_adbus),

  // cpu signals
  .read       (ic_read),
  .write      (4'b0),
  .ready      (ic_ready),
  .grant      (ic_grant), // unused
  .databus    (inst),
  .adbus      (inst_addr)
);

`else // RTL
ICache ICache
(
  .Clk          (clk),
  .Reset        (rst),
  .DStrobe      (1'b1),
  .DRW          (ic_read),
  .DAddress     (inst_addr),
  .DData        (inst),
  .DReady       (ic_ready),

  .Miss         (),
  .MStrobe      (), 
  .MRW          (ic_read_mem),
  .MGrant       (ic_grant_mem),
  .MAddress     (mem_adbus),
  .MData        (mem_databus),

  .mSDR_TxD     (),
  .mSDR_RxD     (mSDR_RxD)
);
`endif 

//------------------------------------------------------
// direct-mapped data cache
//------------------------------------------------------
cache dcache (
  .clk        (clk),
  // memory signals
  .read_mem   (dc_read_mem),
  .write_mem  (dc_write_mem),
  .grant_mem  (dc_grant_mem),
  .ready_mem  (ready_mem),
  .mem_databus(mem_databus),
  .mem_adbus  (mem_adbus),

  // cpu signals
  .read       (dc_read),
  .write      (dc_write),
  .ready      (dc_ready),
  .grant      (dc_grant),
  .databus    (data),
  .adbus      (data_addr)
);

//------------------------------------------------------
// 4-port priority arbiter
//------------------------------------------------------
  arbiter arbiter (
    .clk          (clk),
    .rst          (rst),
    .skip_wait    (skip_wait),

    // caches
    .read_request ({1'b0, dc_read_mem, ic_read_mem, dma_read_mem}),
    .write_request({1'b0, dc_write_mem, 1'b0, dma_write_mem}),
    .grant        (grant_mem),

    // memory
    .memory_sel   (cs),
    .rwbar        (rwbar),
    .ready        (ready_mem)
  );

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
    .oAS1_DATA(mem_databus),
    .iAS1_DATA(),
    .iAS1_ADDR(mem_adbus),
    .iAS1_WR(dc_grant_mem & dc_write_mem), //(cs & ~rwbar),
    .iAS1_RD(ic_grant_mem & ic_read_mem | dc_grant_mem & dc_read_mem), //(cs & rwbar), 

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
    .iSelect(3'd1), //(mSDR_Select),
    .oSDR_RxD(mSDR_RxD),
    .iCLK   (clk),
    .iRST_n (sdram_rst),

    //	SDRAM Interface
    .SA(sdr_addr),
    .BA(ba),
    .CS_N(cs_n),
    .CKE(cke),
    .RAS_N(ras_n),
    .CAS_N(cas_n),
    .WE_N(we_n),
    .DQ(dq),
    .DQM(dqm),
    .SDR_CLK(sdr_clk)
  );

  mt48lc8m16a2 m0      
  ( 
    .Dq(dq),
    .Addr(sdr_addr),
    .Ba(ba),
    .Clk(sdr_clk),
    .Cke(cke),
    .Cs_n(cs_n[0]),
    .Cas_n(cas_n),
    .Ras_n(ras_n),
    .We_n(we_n),
    .Dqm(dqm)
  );

//Reset_Control Reset_Control (clk, rst, sdram_rst);

endmodule 


`timescale 1ns/1ns
module TestBench;

  reg clk;							//	50 MHz
  reg rst;
  reg sdram_rst;

  test_cache_sdram DUT
  (clk, rst, sdram_rst, abus1, abus2, dbus1, dbus2i, dbus2o);

  always #10 clk = ~clk;

  initial begin
    $readmemh("simpletest.txt", DUT.m0.Bank0);
    clk = 1;
    rst = 1; 
    sdram_rst = 0; 
    //DUT.mSDR_Select = 0;
    #100
    sdram_rst = 1; 

    // SDRAM initialization
    #99500
    rst = 0; 
    //DUT.mSDR_Select = 1;
    
    #5000
    $stop;

  end

endmodule 

