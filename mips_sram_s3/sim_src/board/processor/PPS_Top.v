`include "MIPS1000_defines.v"

module PPS_Top (clk, rst, abus1, abus2, dbus1, dbus2i, dbus2o);
  // FPGA clock
  input clk;
  input rst;
  output [`MEM_ADDR_WIDTH-1:0] abus1;
  output [`MEM_ADDR_WIDTH-1:0] abus2;
  output [31:0] dbus1;  
  output [31:0] dbus2i;   // proc <- memory
  output [31:0] dbus2o;   // proc -> memory


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
wire dc_read_mem, dc_write_mem;
wire ic_read_mem, ic_write_mem;
wire dma_read_mem, dma_write_mem;
wire rw_n;

/*
assign dbus1  = inst;
assign dbus2i = data_in;
assign dbus2o = data_out;
*/

// data cache access has highest priority
assign dc_grant_mem  = grant_mem[2];
assign ic_grant_mem  = grant_mem[1];
assign dma_grant_mem = grant_mem[0];

wire [31:0] check_pc;
wire [31:0] check_data;
wire [31:0] check_addr;

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
  .Clk          (clk)
  .Reset        (rst),
  .DStrobe      (1'b1),
  .DRW          (ic_read_mem),
  .DAddress     (inst_addr),
  .DData        (inst),
  .DReady       (ic_ready),

  .Miss         (),
  .MStrobe      (),
  .MRW          (ic_read_mem),
  .MAddress     (mem_addr),
  .MData        (mem_databus),

  .mSDR_TxD     (),
  .mSDR_RxD     (mSDR_RxD),
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

 host host (
  .clk            (clk),
  .hclk           (hclk),
  .adbus          (mem_adbus),
  .databus        (mem_databus), 
  .rw_n           (rw_n),
  .data_rcv       (dev_rcv),
  .data_txd       (dev_txd),
  .data_rdy       (dev_rdy),
  .dev_out        (dev_out), 
  .dev_in         (dev_in) 
 );

 addr_decode addr_decode (
  .adbus          (mem_adbus),
  .active         (skip_wait), 
  .select         (select)
 );

 dma_controller dma_controller (
  .clk            (clk),
  .rst            (rst),
  // memory signals
  .read_mem       (dma_read_mem),
  .write_mem      (dma_write_mem),
  .databus        (mem_databus),
  .adbus          (mem_adbus),
  .ready          (ready_mem),
  .grant          (dma_grant_mem),
  .status_wr      (dc_write),
  .status_rd      (dc_read),

  // cpu signals
  .select_reg     (select),

  // device signals
  .error1         (1'b0), 
  .error2         (1'b0),
  .dev_rdy        (dev_rdy),  // device ready
  .dma_rcv        (dev_rcv),  // dma received data
  .dma_txd        (dev_txd),  // dat sent data
  .dev_wdata      (dev_out),  // device -> dma
  .dev_rdata      (dev_in)    // device <- dma
 );

//------------------------------------------------------
// Simple SRAM
//------------------------------------------------------
  memory SRAM (
    .clk    (clk),
    .cs     (cs),
    .rwbar  (rwbar),
    .adbus  (mem_adbus[`MEM_ADDR_WIDTH + 1 : 2]),
    .databus(mem_databus)
  );

  /*
Multi_Sdram			u3	(	//	Host Side
							mSD2RS_DATA,mRS2SD_DATA,mSD_ADDR,mSD_RD,mSD_WR,mSD_Done,
							//	Async Side 1
							mSDR_AS_DATAOUT_1,mSDR_AS_DATAIN_1,mSDR_AS_ADDR_1,mSDR_AS_WR_n_1,
							//	Async Side 2
							mSDR_AS_DATAOUT_2,mSDR_AS_DATAIN_2,mSDR_AS_ADDR_2,mSDR_AS_WR_n_2,
							//	Async Side 3
							mSDR_AS_DATAOUT_3,mSDR_AS_DATAIN_3,mSDR_AS_ADDR_3,mSDR_AS_WR_n_3,
							//	Control Signals
							mSDR_Select,OSC_50,KEY[0],
							//	SDRAM Interface
        					DRAM_ADDR,{DRAM_BA_1,DRAM_BA_0},DRAM_CS_N,DRAM_CKE,DRAM_RAS_N,
							DRAM_CAS_N,DRAM_WE_N,DRAM_DQ,{DRAM_UDQM,DRAM_LDQM},DRAM_CLK);
            */

endmodule 
