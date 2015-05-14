`include "MIPS1000_defines.v"
`include "cache.h"

module test_beh (
  // FPGA clock
  input clk,
  input rst,
  input run_inst,
  input run_data,
  output done
  /*
  output [`MEM_ADDR_WIDTH-1:0] abus1,
  output [`MEM_ADDR_WIDTH-1:0] abus2,
  output [31:0] dbus1,  
  output [31:0] dbus2i,   // proc <- memory
  output [31:0] dbus2o
  */
  );   // proc -> memory


wire [31:0] inst_addr;
wire [31:0] inst;
wire [31:0] data_addr;
wire [31:0] data;
wire  [3:0] dc_bwe;
//wire  [3:0] bwe;

wire [31:0] mem_databus;
wire [31:0] mem_adbus;
wire  [3:0] grant_mem;
wire dc_write;
wire dc_grant_mem, ic_grant_mem;
wire dc_read, ic_read;
wire dc_ready, ic_ready;
wire dc_read_mem, dc_write_mem;
wire ic_read_mem, ic_write_mem;
wire rw_n;

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
//Test_Sync Test_Sync
//(
//  .clk        (clk),
//  .rst        (rst),
//  .data_read  (dc_read),
//  .data_write (|dc_write),
//  .data_ready (dc_ready),
//  .inst_ready (ic_ready),
//  .pc         (inst_addr),
//  .data       (data),
//  .addr       (data_addr),
//  .check_en   (check_en),
//  .check_pc   (check_pc),
//  .check_data (check_data),
//  .check_addr (check_addr)
//);

//------------------------------------------------------
// behavioral processor
//------------------------------------------------------
mips_cache_behav Processor(
  .clk       (clk),
  .rst       (rst),
  .run_inst  (run_inst),
  .run_data  (run_data),
  .inst_addr (inst_addr),
  .inst_read (ic_read),
  .inst_ready(ic_ready),
  .inst      (inst),
  .data_addr (data_addr),
  .data_read (dc_read),
  .data_write(dc_write),
  .data_bwe  (dc_bwe),
  .data_ready(dc_ready),
  .data      (data),
  .done      (done)
);
 
//------------------------------------------------------
// direct-mapped inst cache 
//------------------------------------------------------
wide_cache #(`ICACHESIZE, `IC_INDEXSIZE, `BSIZE, `BINDEX, `INSNWIDTH/8, 2)
icache (
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
  .write      (1'b0),
  .bwe        (4'b0),
  .ready      (ic_ready),
  .grant      (ic_grant), // unused
  .databus    (inst),
  .adbus      (inst_addr)
);
//------------------------------------------------------
// direct-mapped data cache 
//------------------------------------------------------
wide_cache_wb #(`DCACHESIZE, `DC_INDEXSIZE, `BSIZE, `BINDEX, `DATAWIDTH/8, 2)
  dcache (
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
  .bwe        (dc_bwe),
  .write      (dc_write),
  .ready      (dc_ready),
  .grant      (dc_grant),
  .databus    (data),
  .adbus      (data_addr)
);

//------------------------------------------------------
// 4-port priority arbiter
//------------------------------------------------------
  arbiter_beh arbiter_beh (
    .clk          (clk),
    .rst          (rst),
    .skip_wait    (1'b0), //skip_wait),

    // caches
    .read_request ({1'b0, dc_read_mem, ic_read_mem, 1'b0}),
    .write_request({1'b0, dc_write_mem, 1'b0, 1'b0}),
    .grant        (grant_mem),

    // memory
    .memory_sel   (cs),
    .rwbar        (rwbar),
    .ready        (ready_mem)
  );

//------------------------------------------------------
// Simple SRAM
//------------------------------------------------------
  memory SRAM (
    .clk    (clk),
    .cs     (cs),
    .rwbar  (rwbar),
    .adbus  (mem_adbus[`MEM_ADDR_WIDTH - 1 : 0]),
    .databus(mem_databus)
  );

endmodule 
