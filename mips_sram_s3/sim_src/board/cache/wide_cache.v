//-----------------------------------------------------------------------
// Behavioral direct-mapped cache model
// 
// 10/15/10 add cache enable (ce)
//-----------------------------------------------------------------------
`include "MIPS1000_defines.v"
`include "cache.h"
`define vbs 0

// Debug codes
`define ACCESS_CACHE      0
`define READ_CACHE_HIT    1
`define READ_CACHE_MISS   2
`define READ_MEM          3
`define FILLED_CACHE      4
`define READ_CACHE_DATA   5
`define WRITE_CACHE       6
`define WRITE_CACHE_HIT   7
`define WRITE_CACHE_MISS  8
`define WRITE_MEM         9

module wide_cache (
  input clk,
  // memory signals
  output reg    read_mem,
  output reg    write_mem,
  input         grant_mem,
  input         ready_mem,
  inout  [31:0] mem_databus,
  output reg [31:0] mem_adbus,

  // cpu signals
  input         read,
  input         write,
  input   [3:0] bwe,
  output reg    ready,
  output reg    grant,
  inout  [31:0] databus,
  input  [31:0] adbus);

  // number of cache lines
  parameter words = 16, asize = 4; 
  // number of 32-bit words per cache line
  parameter nword = 2,  msize = 1; 
  // number of byte for every word
  parameter nbyte = 4, bsize = 2; 

  // cache ram
  reg [31:0] ram3 [0:words-1];
  reg [31:0] ram2 [0:words-1];
  reg [31:0] ram1 [0:words-1];
  reg [31:0] ram0 [0:words-1];

  // cache tag
  reg [31-asize-msize-bsize :0] tag [0:words-1];

  // cache valid
  reg valid [0:words-1];

  // 32-bit data bus 
  reg  [31:0] databus_txd, mem_databus_txd;
  reg         hit;
  reg  [31:0] mem_adbus_temp, databus_temp;
  reg  [2 * nbyte * nword - 1:0] write_mask;
  reg  [3:0] bwe_hi, bwe_lo;

  wire  [asize-1:0] set = adbus[asize + msize + bsize - 1 : msize + bsize];
  wire  [msize-1:0] sel = adbus[msize + bsize - 1 : bsize];
  wire  [nbyte * nword * 8 - 1 : 0] ram_data_vector = 
                                     { ram3[set], ram2[set], ram1[set], ram0[set] };
  wire  [32-asize-msize-bsize+32+32:0] cache_data_vector = 
                                     { valid[set], tag[set], ram1[set], ram0[set] };

  wire ce;

  /* lower-level memory read */
  function [15:0] read_mem_data;
    input [`MEM_ADDR_WIDTH - 1 : 0] mem_adbus;
    read_mem_data = DUT_BEH.SRAM.sram[mem_adbus];
  endfunction

  /* Cache ram memory read */
  function [31:0] ram_read;
    input [nbyte * nword * 8 - 1:0] ram_data;
    input [msize-1:0]  ram_sel;
    begin
      case (ram_sel)
        'd3: ram_read = ram_data[127 : 96];
        'd2: ram_read = ram_data[95  : 64];
        'd1: ram_read = ram_data[63  : 32];
        'd0: ram_read = ram_data[31  :  0];
        default: $display("Error ram sel %b", ram_sel);
      endcase
    end
  endfunction

  /* Cache ram memory write */
  function [31:0] ram_write;
    input [31:0] ram_data;
    input [31:0] databus;
    input  [3:0] write;
    input        hit;
    begin
      if (hit) begin
        case (write)
          4'b0000: ram_write = ram_data; /* do nothing */
          4'b1111: ram_write = databus;
          4'b1000: ram_write = {databus[7:0], ram_data[23:0]};
          4'b1100: ram_write = {databus[15:0], ram_data[15:0]};
          4'b0100: ram_write = {ram_data[31:24], databus[7:0], ram_data[15:0]};
          4'b0010: ram_write = {ram_data[31:16], databus[7:0], ram_data[7:0]};
          4'b0001: ram_write = {ram_data[31:8], databus[7:0]};
          4'b0011: ram_write = {ram_data[31:16], databus[15:0]};
          default: $display("Error write byte enable %b", write);
        endcase
      end
      else begin /* no cache write on write miss */ 
        case (write)
          4'b0000,
          4'b1000,
          4'b0100,
          4'b0010,
          4'b0001,
          4'b0011, 
          4'b1100,
          4'b1111: ram_write = ram_data;
          default: $display("Error write %b", write);
        endcase
      end
    end
  endfunction

  /* Burst-read burst-length n-bit data from SDRAM */
  function [31:0] ram_fill;
    input [31:0] ram_data;
    input [31:0] databus; /* low n bits */
    input  [3:0] write;
    begin
      case (write)
        4'b0000: ram_fill = ram_data; /* no ram refill */
        4'b0011: ram_fill = {ram_data[31:16], databus[15:0]};
        4'b1100: ram_fill = {databus[15:0], ram_data[15:0]};
        default: $display("Error write fill enable %b", write);
      endcase
    end
  endfunction

  /* Burst-write burst-length n-bit wide data to SDRAM every cycle */
  function [31:0] mem_write;
    input [31:0] databus;  // cpu write data
    input [31:0] mem_adbus;
    input  [1:0] write;
    input  [1:0] last_write;
    reg   [15:0] mem_data; // mem read data 
    begin
      /* read lower-level memory e.g. 16-bit SDRAM data */
      mem_data  = read_mem_data(mem_adbus);

      mem_write[31:16] = 16'hz; // n = 16 
      case (write)
        2'b00: mem_write[15:0] = mem_data;    
        2'b01: mem_write[15:0] = {mem_data[15:8], databus[7:0]};
        2'b10: mem_write[15:0] = {databus[7:0],   mem_data[7:0]};
        2'b11: mem_write[15:0] = mem_adbus[0] ?
        ((last_write == 2'b11) ? databus[31:16] /* sw */  : 
                                 databus[15:0]  /* sh */) : 
                                 databus[15:0]  /* mem_adbus[0] = 0 */;
        default: mem_write[15:0] = 16'bx;
      endcase
      if (`vbs) 
        $display("func(mem_write): write = %b last_write = %b mem_write(16-bit) = %h", 
                  write, last_write, mem_write[15:0]);
    end
  endfunction

  /* Assume cache line aligned write */
  task check_mem_write;
    input [31:0] mem_adbus; // first memory write address(x00)
    input [31:0] databus;   // cpu write data
    input        sel;       // ram select
    input  [3:0] write;     // cpu write pattern

    reg [`MEM_ADDR_WIDTH - 1 : 0] addr;
    reg [15:0] mem_data_hi, mem_data_lo;

    begin
      // read lower-level memory: burst write address sequence: 
      // e.g.
      // 1. sel = 0
      //    x00: ram0[15:0]
      //    x01: ram0[31:16]
      // 2. sel = 1
      //    x10: ram1[15:0]
      //    x11: ram1[31:16]
      case (sel) 
        'd3 :  addr = mem_adbus + 6;
        'd2 :  addr = mem_adbus + 4;
        'd1 :  addr = mem_adbus + 2;
        'd0 :  addr = mem_adbus;
      endcase

      // get high and low 16-bit data of a word 
      mem_data_hi  = read_mem_data(addr + 1);
      mem_data_lo  = read_mem_data(addr);

      if (`vbs)
        $display($time,, "check_mem_write: adbus = %h databus = %h sel = %d",
                        mem_adbus, databus, sel);

      case (write)
        4'b0000: begin
          $display($time,, "is it memory write?"); $stop;
        end

        4'b0001: 
          if (mem_data_lo[7:0] != databus[7:0]) begin 
          $display($time,, "Error at mem[0x%h-0x%h]: %h %h <-> write pattern %b", 
                   addr+1, addr, mem_data_hi, mem_data_lo, write);
          $stop;
          end

        4'b0010: 
          if (mem_data_lo[15:8] != databus[7:0]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h %h <-> write pattern %b", 
                   addr+1, addr, mem_data_hi, mem_data_lo, write);
          $stop;
          end

        4'b0100:
          if (mem_data_hi[7:0] != databus[7:0]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h %h <-> write pattern %b", 
                   addr+1, addr, mem_data_hi, mem_data_lo, write);
          $stop;
          end

        4'b1000:
          if (mem_data_hi[15:8] != databus[7:0]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h %h <-> write pattern %b", 
                   addr+1, addr, mem_data_hi, mem_data_lo, write);
          $stop;
          end

        4'b0011: 
          if (mem_data_lo != databus[15:0]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h %h <-> write pattern %b", 
                   addr+1, addr, mem_data_hi, mem_data_lo, write);
          $stop;
          end

        4'b1100: 
          if (mem_data_hi != databus[15:0]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h %h <-> write pattern %b", 
                   addr+1, addr, mem_data_hi, mem_data_lo, write);
          $stop;
          end

        4'b1111: 
          if ({mem_data_hi, mem_data_lo} != databus) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h %h <-> write pattern %b", 
                   addr+1, addr, mem_data_hi, mem_data_lo, write);
          $stop;
          end

        default: 
        begin 
          $display("Unknown write pattern %b", write);
          $stop;
        end
      endcase
    end
  endtask

  /* memory address alignment based on the memory width */
  function [31:0] mem_addr;
    input [31:0] vaddr;
    input [31:0] width;
    reg [31:0] temp_addr;
    begin
      case (width) // memory width
        'd32: temp_addr = {2'b0, vaddr[31:2]};                 // word aligned
        'd16: temp_addr = {1'b0, vaddr[31:1]} & 32'hFFFF_FFFC; // cache line aligned 
        'd8 : temp_addr = vaddr;
        default: begin
          $display("Unimplemented memory width");
          $stop;
        end
      endcase
      mem_addr = temp_addr;
    end
  endfunction

  /* Assume the block size is 4 */
  function [127 : 0] cache_write;
    input [1:0]   word_sel;
    input [3:0]   bwe;
    input [31:0]  databus;
    input [127:0] cache_ram;
    input         hit;

    // mask cache ram and SDRAM write 
    reg  [15:0] write_mask;
    case (word_sel) 
      'd0: write_mask = {12'b0, bwe};      // ram0
      'd1: write_mask = {8'b0, bwe, 4'b0}; // ram1
      'd2: write_mask = {4'b0, bwe, 8'b0}; // ram2
      'd3: write_mask = {bwe, 12'b0};      // ram3
      default: begin
        $display("Error ram word sel %b", word_sel);
        //$stop;
      end
    endcase

    cache_write[31  :  0] = ram_write(cache_ram[31  :  0], databus, write_mask[3:0], hit);
    cache_write[63  : 32] = ram_write(cache_ram[63  : 32], databus, write_mask[7:4], hit);
    cache_write[95  : 64] = ram_write(cache_ram[95  : 64], databus, write_mask[11:8], hit);
    cache_write[127 : 96] = ram_write(cache_ram[127 : 96], databus, write_mask[15:12],hit);

  endfunction

  task Debug;
    input        dbg_en;
    input [3:0]  state;
    input [31:0] adbus;
    input [1+25+32+32 - 1:0] cache_data_vector;
    input [31:0] databus; 

    reg [asize-1:0] set;
    reg [msize-1:0] sel;
    reg [24:0] tag;

    reg [31:0] data_ram1, data_ram0;
    reg [24:0] tag_ram;
    reg        val_ram;

    begin
      if (dbg_en) begin
        // extracted from cpu address
        set = adbus[asize + msize + bsize - 1 : msize + bsize];
        sel = adbus[msize + bsize - 1 : bsize];
        tag = adbus[31 : asize + msize + bsize];

        // extracted from cache ram
        val_ram   = cache_data_vector[89];
        tag_ram   = cache_data_vector[88:64];
        data_ram1 = cache_data_vector[63:32];
        data_ram0 = cache_data_vector[31: 0];

        case (state)
          `ACCESS_CACHE:
          $display($time,, "Accessing cache > Address = %h set = %d tag %h <-> ValidRam %b TagRam %h",
                            adbus, set, tag, val_ram, tag_ram);
          `READ_CACHE_HIT:
          $display($time,, "Read hit > read cache data = %h", databus);

          `READ_CACHE_MISS:
          $display($time,, "Read miss > Assert read_mem");

          `READ_MEM:
          $display($time,, "Read miss > drive memory adbus = %h", adbus);

          `FILLED_CACHE:
          $display($time,, "Read miss > fill cache: set = %d val = %b tag = %h ram = %h %h", 
                            set, val_ram, tag_ram, data_ram1, data_ram0);
          `READ_CACHE_DATA:
          $display($time,, "Read miss > read cache data = %h", databus);

          `WRITE_CACHE_HIT:
          $display($time,, "Write hit > update cache: cache index = %d val = %b tag = %h ram = %h %h", 
                            set, val_ram, tag_ram, data_ram1, data_ram0);

          `WRITE_CACHE_MISS:
          $display($time,, "Write miss > update cache: cache index = %d val = %b tag = %h ram = %h %h", 
                            set, val_ram, tag_ram, data_ram1, data_ram0);
          `WRITE_CACHE:
          $display($time,, "Write miss > Assert write_mem");

          `WRITE_MEM:
          $display($time,, "Write miss > drive memory adbus = %h data = %h", adbus, databus);

          default:
          $display("");
        endcase
      end
    end
  endtask

  // Memory read/write checker
  always @ (posedge clk) begin
    if (read && write) begin
     $display($stime,, "Error: Simultaneous Cache reads & writes not supported.");
     $stop;
    end

    if (read_mem && write_mem) begin
     $display($stime,, "Error: Simultaneous lower-level memory reads & writes not supported.");
     $stop;
    end
  end

  initial begin : initialize_cache
    integer i;
    for (i = 0; i < words; i = i + 1) begin
      tag[i]   = 0;
      valid[i] = 0;
    end
  end

  assign databus     = databus_txd;    // databus as output
  assign mem_databus = mem_databus_txd;// memory databus as output

  /* uncached range A000_0000 - BFFF_FFFF */
  assign ce =  adbus[31:29] == 3'b101 ?  1'b0 : 1'b1;    

  always @ (posedge clk) begin
    // default
    databus_txd     = 32'hz;
    mem_databus_txd = 32'hz;
    mem_adbus       = 32'hz;
    read_mem        = 1'b0;
    write_mem       = 1'b0;
    ready           = 1'b0;
    grant           = 1'b0;
    ready           = 1'b0;
    hit             = 1'b0;
    // data are uncached with I/O address
    if (read || write) begin : request
      //===================================================================================
      Debug(`vbs, `ACCESS_CACHE, adbus, cache_data_vector, databus);
      //===================================================================================
      //#(`PERIOD) // SRAM access
      grant = 1'b1;
      if (tag[set] == adbus[31:asize + msize + bsize] && valid[set])
        hit = 1'b1;
      else
        hit = 1'b0;
      if (hit) begin 
        if (read) begin // read_hit
          ready           = 1'b1;
          databus_txd     = ram_read(ram_data_vector, sel); 
          //===================================================================================
          Debug(`vbs, `READ_CACHE_HIT, adbus, cache_data_vector, databus_txd);
          //===================================================================================

          wait (read == 1'b0);

          databus_txd     = 32'hz;
          ready           = 1'b0;
        end 
        else if (write) begin  // write_hit
          if (ce) begin
            {ram3[set], ram2[set], ram1[set], ram0[set]} = cache_write(sel, bwe, databus, 
            {ram3[set], ram2[set], ram1[set], ram0[set]}, hit);
          //===================================================================================
          #1; // wait for cache_data_vector to get the updated cache values
          Debug(`vbs, `WRITE_CACHE_HIT, adbus, cache_data_vector, databus);
          //===================================================================================
          end
          //===================================================================================
          Debug(`vbs, `WRITE_CACHE, mem_adbus, cache_data_vector, databus);
          //===================================================================================
          write_mem = 1'b1;

          wait (grant_mem);

          // aligned half-word address 
          mem_adbus = mem_addr(adbus, 16);
          mem_adbus_temp = mem_adbus;
          databus_temp = databus;

          case (sel) // at most write one word to memory
            'd3: write_mask = 16'hF000;
            'd2: write_mask = 16'h0F00;
            'd1: write_mask = 16'h00F0;
            'd0: write_mask = 16'h000F;
            default: write_mask = 16'h0000;
          endcase
          $display("Select cache ram %d for memory write", sel);

          bwe_lo = bwe & write_mask[3:0]; 
          bwe_hi = bwe & write_mask[7:4]; 

          //===================================================================================
          Debug(`vbs, `WRITE_MEM, mem_adbus, cache_data_vector, databus);
          //===================================================================================

          wait (ready_mem);

          //-----------------------------------------------------------------------------------
          // In burst mode, the bytes are written in consecutive adresses.
          //-----------------------------------------------------------------------------------
          mem_databus_txd = mem_write(databus, mem_adbus, bwe_lo[1:0], 2'bx);
          @(posedge clk);
          mem_adbus = mem_adbus + 1;
          mem_databus_txd = mem_write(databus, mem_adbus, bwe_lo[3:2], bwe_lo[1:0]);
          @(posedge clk);
          mem_adbus = mem_adbus + 1;
          mem_databus_txd = mem_write(databus, mem_adbus, bwe_hi[1:0], 2'bx);
          @(posedge clk);
          mem_adbus = mem_adbus + 1;
          mem_databus_txd = mem_write(databus, mem_adbus, bwe_hi[3:2], bwe_hi[1:0]);
          @(posedge clk)
          #1;
          //===================================================================================
          // Check memory data write 
          //===================================================================================
          check_mem_write(mem_adbus_temp, databus_temp, sel, bwe);

          mem_databus_txd = 32'hz;
          mem_adbus       = 32'hz;
          write_mem       = 1'b0;
          ready           = 1'b1;
          wait (!write);

          ready           = 1'b0;
        end // write_hit
      end 
      else begin  // write_miss
        if (write) begin 
          // no cache write
          {ram3[set], ram2[set], ram1[set], ram0[set]} = cache_write(sel, bwe, databus, 
          {ram3[set], ram2[set], ram1[set], ram0[set]}, hit);
          //tag[set]   = adbus[31 : asize + msize + bsize];
          //valid[set] = 1'b1;
          //===================================================================================
          Debug(`vbs, `WRITE_CACHE, adbus, cache_data_vector, databus);
          //===================================================================================
          write_mem = 1'b1;

          //===================================================================================
          #1; // wait for cache_data_vector to get the updated cache values
          Debug(`vbs, `WRITE_CACHE_MISS, adbus, cache_data_vector, databus);
          //===================================================================================
          wait (grant_mem);

          mem_adbus = mem_addr(adbus, 16);
          mem_adbus_temp = mem_adbus;
          databus_temp = databus;

          case (sel)
            'd3: write_mask = 16'hF000;
            'd2: write_mask = 16'h0F00;
            'd1: write_mask = 16'h00F0;
            'd0: write_mask = 16'h000F;
            default: write_mask = 16'h0000;
          endcase

          bwe_lo = bwe & write_mask[3:0]; 
          bwe_hi = bwe & write_mask[7:4]; 

          //===================================================================================
          Debug(`vbs, `WRITE_MEM, mem_adbus, cache_data_vector, databus);
          //===================================================================================
          
          wait (ready_mem);

          //-----------------------------------------------------------------------------------
          // In burst mode, the bytes are written in consecutive adresses.
          //-----------------------------------------------------------------------------------
          mem_databus_txd = mem_write(databus, mem_adbus, bwe_lo[1:0], 2'bx);
          @(posedge clk);
          mem_adbus = mem_adbus + 1;
          mem_databus_txd = mem_write(databus, mem_adbus, bwe_lo[3:2], bwe_lo[1:0]);
          @(posedge clk);
          mem_adbus = mem_adbus + 1;
          mem_databus_txd = mem_write(databus, mem_adbus, bwe_hi[1:0], 2'bx);
          @(posedge clk);
          mem_adbus = mem_adbus + 1;
          mem_databus_txd = mem_write(databus, mem_adbus, bwe_hi[3:2], bwe_hi[1:0]);
          @(posedge clk)
          #1;
          //===================================================================================
          // Check memory data write 
          //===================================================================================
          check_mem_write(mem_adbus_temp, databus_temp, sel, bwe);
          mem_databus_txd = 32'hz;
          write_mem       = 1'b0;
          ready           = 1'b1;

          wait (!write);

          ready           = 1'b0;
        end 
        else if (read) begin // read_miss
          read_mem        = 1'b1;
          //===================================================================================
          Debug(`vbs, `READ_CACHE_MISS, mem_adbus, cache_data_vector, databus);
          //===================================================================================

          wait (grant_mem);

          mem_adbus = mem_addr(adbus, 16);
          //===================================================================================
          Debug(`vbs, `READ_MEM, mem_adbus, cache_data_vector, databus);
          //===================================================================================

          wait (ready_mem);

          if (ce) begin     
          //-----------------------------------------------------------------------------------
          // In burst mode, the bytes are read in consecutive adresses.  
          // Instruction cache(sram) is refilled from LSB to MSB: 16-bit data per cycle
          //-----------------------------------------------------------------------------------
            @(posedge clk);
            #1;
            ram0[set] = ram_fill(ram0[set], mem_databus, 4'h3);
            mem_adbus = mem_adbus + 1;
            @(posedge clk);
            #1;
            ram0[set] = ram_fill(ram0[set], mem_databus, 4'hC);
            mem_adbus = mem_adbus + 1;
            @(posedge clk);
            #1;
            ram1[set] = ram_fill(ram1[set], mem_databus, 4'h3);
            mem_adbus = mem_adbus + 1;
            @(posedge clk);
            #1;
            ram1[set] = ram_fill(ram1[set], mem_databus, 4'hC);
            @(posedge clk);
            tag[set]    = adbus[31 : asize + msize + bsize];
            valid[set]  = 1'b1;

            #1; // wait for cache_data_vector to get the updated cache values
            //===================================================================================
            Debug(`vbs, `FILLED_CACHE, mem_adbus, cache_data_vector, databus);
            //===================================================================================
          end

          databus_txd   = ram_read(ram_data_vector, sel); 
          mem_adbus     = 32'hz;
          read_mem      = 1'b0; 
          ready         = 1'b1;
          //===================================================================================
          Debug(`vbs, `READ_CACHE_DATA, mem_adbus, cache_data_vector, databus_txd);
          //===================================================================================
          
          wait (!read);

          ready         = 1'b0;
        end // read_miss
      end 
    end // request
  end

endmodule 
