//-----------------------------------------------------------------------
// Behavioral direct-mapped cache model
// 
// 10/15/10 add cache enable (ce)
//-----------------------------------------------------------------------
`include "MIPS1000_defines.v"
`include "cache.h"
`define vbs 1

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

module wide_cache_wb (
  input clk,
  // memory signals
  output reg        read_mem,
  output reg        write_mem,
  input             grant_mem,
  input             ready_mem,
  inout  [31:0]     mem_databus,
  output reg [31:0] mem_adbus,

  // cpu signals
  input             read,
  input             write,
  input   [3:0]     bwe,
  output reg        ready,
  output reg        grant,
  inout  [31:0]     databus,
  input  [31:0]     adbus);

  `include "mips_utils.v"

  // number of cache lines
  parameter words = 16, asize = 4; 
  // number of 32-bit words per cache line
  parameter nword = 2,  msize = 1; 
  // number of byte for every word
  parameter nbyte = 4, bsize = 2; 

  // number of write buffer cache lines
  parameter wb_words = 4, wb_asize = 2; 

  //=============================================== 
  // Cache rams
  //=============================================== 
  // cache ram
  reg [31:0] ram3 [0:words-1];
  reg [31:0] ram2 [0:words-1];
  reg [31:0] ram1 [0:words-1];
  reg [31:0] ram0 [0:words-1];

  // cache tag
  reg [31-asize-msize-bsize :0] tag [0:words-1];

  // cache valid
  reg valid [0:words-1];

  //=============================================== 
  // WB rams
  //=============================================== 

  // wb ram
  reg [31:0] wb_ram3     [0:wb_words-1];
  reg [31:0] wb_ram2     [0:wb_words-1];
  reg [31:0] wb_ram1     [0:wb_words-1];
  reg [31:0] wb_ram0     [0:wb_words-1];
  // wb byte valids
  reg  [3:0] wb_ram1_val [0:wb_words-1];
  reg  [3:0] wb_ram0_val [0:wb_words-1];
  // wb tag valid
  reg        wb_tag_val  [0:wb_words-1];
  // wb tag
  reg [26:0] wb_tag      [0:wb_words-1];

  reg [2:0] flush_cnt;

  // 32-bit data bus 
  reg  [31:0] databus_txd;
  reg  [31:0] databus_temp;
  reg  [31:0]  mem_databus_txd;
  reg  [31:0] mem_adbus_temp;
  reg  [31:0] wb_adbus; 
  reg  [2 * nbyte * nword - 1:0] write_mask;
  reg  [3:0] bwe_hi, bwe_lo;
  reg         hit;

  //=========================================================================== 
  // cache set
  //=========================================================================== 
  wire  [asize-1:0] set = adbus[asize + msize + bsize - 1 : msize + bsize];

  //=========================================================================== 
  // wb set
  //=========================================================================== 
  wire  [wb_asize-1:0] wb_set = adbus[wb_asize + msize + bsize - 1 : msize + bsize];

  //=========================================================================== 
  // 32-bit wb or cache word select
  //=========================================================================== 
  wire  [msize-1:0] sel = adbus[msize + bsize - 1 : bsize];

  wire  [32-asize-msize-bsize+32+32:0] cache_data_vector = 
                                     { valid[set], tag[set], ram1[set], ram0[set] };

  wire  [nbyte * nword * 8 - 1 : 0] wb_ram_data_vector = 
                                     { wb_ram3[wb_set], wb_ram2[wb_set], 
                                       wb_ram1[wb_set], wb_ram0[wb_set] };

  reg  [1+32-wb_asize-msize-bsize+8+32+32:0] wb_data_vector;
  reg  [nbyte * nword * 8 - 1 : 0] ram_data_vector;

  // chip enable
  wire ce;

  //=========================================================================== 
  // Display write buffer contents
  //=========================================================================== 
  task display_wb;
    integer i;
    $display("--------------------------------------------------------------------");
    $display("BEH write buffer contents: ");
    for (i = 0; i < wb_words; i = i + 1) begin
      $display("%b-%h -- %b-%h %b-%h %b-%h %b-%h %b-%h %b-%h %b-%h %b-%h",
      wb_tag_val[i], wb_tag[i],
      wb_ram1_val[i][3], wb_ram1[i][31:24],
      wb_ram1_val[i][2], wb_ram1[i][23:16],
      wb_ram1_val[i][1], wb_ram1[i][15:8],
      wb_ram1_val[i][0], wb_ram1[i][7:0],
      wb_ram0_val[i][3], wb_ram0[i][31:24],
      wb_ram0_val[i][2], wb_ram0[i][23:16],
      wb_ram0_val[i][1], wb_ram0[i][15:8],
      wb_ram0_val[i][0], wb_ram0[i][7:0]);
    end
    $display("--------------------------------------------------------------------");
  endtask

  //=========================================================================== 
  // Reset write buffer valid rams at entry wb_set
  //=========================================================================== 
  task flush;
    input [wb_asize-1:0] wb_set;
    wb_tag_val [wb_set] = 1'b0;
    wb_ram1_val[wb_set] = 4'b0;
    wb_ram0_val[wb_set] = 4'b0;
  endtask

  //=========================================================================== 
  // Reset all valid rams of write buffer
  //=========================================================================== 
  task flush_wb;
    integer i;
    $display("Flushing write buffer valid bits");
    for (i = 0; i < wb_words; i = i + 1) flush(i);
  endtask

  //=========================================================================== 
  // write buffer is full with all valid bits set
  //=========================================================================== 
  function wb_full;
    reg full;
    integer i;
    begin
      full = 1'b1;
      for (i = 0; i < wb_words; i = i + 1) begin
        full = full & (wb_tag_val[i] & (&wb_ram1_val[i]) & (&wb_ram0_val[i]));
      end
      if (full) 
       $display($time,, "******** BEH: WB is full now ******** ");
      wb_full = full;
    end
  endfunction

  //=========================================================================== 
  // Read lower-level memory data at mem_adbus
  //=========================================================================== 
  function [15:0] read_mem_data;
    input [`MEM_ADDR_WIDTH - 1 : 0] mem_adbus;
    read_mem_data = check_HiZ(16, DUT_BEH.SRAM.sram[mem_adbus]);
  endfunction

  //=========================================================================== 
  // Read word from cache ram 
  //=========================================================================== 
  function [31:0] ram_read;
    input [nbyte * nword * 8 - 1:0] ram_data;
    input [msize-1:0]  ram_sel;
    begin
      case (ram_sel)
        'd3: ram_read = ram_data[127 : 96];
        'd2: ram_read = ram_data[95  : 64];
        'd1: ram_read = ram_data[63  : 32];
        'd0: ram_read = ram_data[31  :  0];
        default: begin
          $display("Error: Function ram_read: ram sel %b", ram_sel);
          $stop;
        end
      endcase
    end
  endfunction

  //=========================================================================== 
  // Merge cache ram and wb ram with ram valid bits in wb
  //=========================================================================== 
  function [63:0] ram_merge;
    input [nbyte * nword * 8 - 1:0] ram_data;
    input [nbyte * nword * 8 - 1:0] wb_ram_data;
    input [7:0] wb_ram_val;  // ram valid bits in wb

    integer j;
    reg [7:0] merge;

    begin
      $display("ram_data = %h wb_ram_data = %h wb_ram_val = %b", 
                ram_data, wb_ram_data, wb_ram_val);

      merge = wb_ram_val;

      // byte granularity with part selects (Verilg 2001)
      for (j = 0; j < nbyte * nword * 8; j = j + 8) begin
        ram_merge[j +:  8] = merge[j/8] ?  wb_ram_data[j +: 8] : ram_data[j +: 8];
        $display("ram_merge [%d : %d] = %h", j, j + 7, ram_merge[j +: 8]);
      end
    end
  endfunction

  //=========================================================================== 
  // Cache ram memory write
  //=========================================================================== 
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
          default: begin
            $display("Error write byte enable %b", write);
            $stop;
          end
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
        default: begin
          $display("Error write %b", write);
          $stop;
        end
        endcase
      end
    end
  endfunction

  //=========================================================================== 
  // Update wb valid bits with processor byte write enable
  //=========================================================================== 
  function [3:0] valid_write;
    input [3:0] ram_data;     // read wb valid bits
    input [3:0] bwe;
    begin
      case (bwe)
        4'b0000: valid_write = ram_data; /* do nothing */
        4'b1111: valid_write = bwe;
        4'b1000: valid_write = {bwe[3], ram_data[2:0]};
        4'b1100: valid_write = {bwe[3:2], ram_data[1:0]};
        4'b0011: valid_write = {ram_data[3:2], bwe[1:0]};
        4'b0100: valid_write = {ram_data[3], bwe[2], ram_data[1:0]};
        4'b0010: valid_write = {ram_data[3:2], bwe[1], ram_data[0]};
        4'b0001: valid_write = {ram_data[3:1], bwe[0]};
        default: begin
          $display("Error in valid_write: write byte enable %b", write);
          $stop;
        end
      endcase
    end
  endfunction

  //=========================================================================== 
  // Fill cache ram with burst read 16-bit data from SDRAM
  //=========================================================================== 
  function [31:0] ram_fill;
    input [31:0] ram_data;
    input [31:0] databus; // only use low 16 bits
    input  [3:0] write;
    begin
      case (write)
        4'b0000: ram_fill = ram_data; // no ram refill
        4'b0011: ram_fill = {ram_data[31:16], databus[15:0]}; // @ cycle n
        4'b1100: ram_fill = {databus[15:0], ram_data[15:0]};  // @ cycle n + 1
        default: begin
          $display("Error in Function ram_fill: write fill enable %b", write);
          $stop;
        end
      endcase
    end
  endfunction

  //=========================================================================== 
  // Write data to SDRAM  (not used if ther is a write buffer)
  // 1. select data between data cache ram and cpu write data.
  //=========================================================================== 
  function [31:0] mem_write;
    input [31:0] data;  // input write data (write buffer/cpu)
    input [31:0] mem_adbus;
    input  [1:0] write;
    input  [1:0] last_write;  // last cycle write
    reg   [15:0] mem_data;    // memory read data 
    begin
      /* read lower-level memory e.g. 16-bit SDRAM data */
      mem_data  = read_mem_data(mem_adbus);

      mem_write[31:16] = 16'hz; // n = 16 
      case (write)
        2'b00: mem_write[15:0] = mem_data;    
        2'b01: mem_write[15:0] = {mem_data[15:8], data[7:0]};  /* sb */
        2'b10: mem_write[15:0] = {data[7:0],  mem_data[7:0]}; /* sb */
        2'b11: mem_write[15:0] = mem_adbus[0] ? ((last_write == 2'b11) ? 
                                                  data[31:16] /* sw */ : 
                                                  data[15:0] /* sh */
                                                ) : data[15:0];
        default: mem_write[15:0] = 16'bx;
      endcase
      if (`vbs) 
        $display("func(mem_write): write = %b last_write = %b mem_write(16-bit) = %h", 
                  write, last_write, mem_write[15:0]);
    end
  endfunction

  //=========================================================================== 
  // Write 16-bit data from WB to SDRAM 
  // The difference between the function mem_write and wb2mem_write is that
  // The write data always come from WB and write byte is different for sb 
  // instructions.
  //=========================================================================== 
  function [31:0] wb2mem_write;
    input [31:0] wb_data;  // input write data (write buffer/cpu)
    input [31:0] mem_adbus;
    input  [1:0] write;
    reg   [15:0] mem_data; // mem read data 
    begin
      /* read lower-level memory e.g. 16-bit SDRAM data */
      mem_data  = read_mem_data(mem_adbus);

      $display("BEH: wb2mem_write inputs: wb data = %h mem data = %h mem_adbus = %h write = %b",
                  wb_data, mem_data, mem_adbus, write);

      wb2mem_write[31:16] = 16'hz; // 16-bit datapath

      case (write)
        2'b00: wb2mem_write[15:0] = mem_data;    
        2'b01: wb2mem_write[15:0] = {mem_data[15:8], wb_data[7:0]}; /* sb */
        2'b10: wb2mem_write[15:0] = {wb_data[15:8], mem_data[7:0]}; /* sb */
        2'b11: wb2mem_write[15:0] = mem_adbus[0] ? wb_data[31:16] : wb_data[15:0];
        default: begin 
          $display("wb2mem_write: write = %b", write); $stop;
        end 
      endcase
      if (`vbs) 
        $display("func(wb2mem_write): write = %b wb2mem_write(16-bit) = %h", 
                  write, wb2mem_write[15:0]);
    end
  endfunction

  //=========================================================================== 
  // Compare write buffer data with data from SDRAM
  // 
  // Assume write sequence is from ram0, ram1 --- to ramX
  //=========================================================================== 
  task check_wb2mem_write;
    input [31:0] mem_adbus; // first memory write address(x00)
    input [31:0] databus;   // wb write data
    input        sel;       // ram select
    input  [3:0] write;     // cpu write pattern

    reg [`MEM_ADDR_WIDTH - 1 : 0] addr;
    reg [31:0] mem_data;

    begin
      // read lower-level memory: burst write address sequence: 
      // e.g.
      // 1. sel = 0 (mem_adbus)
      //    x00: ram0[15:0]
      //    x01: ram0[31:16]
      // 2. sel = 1 (mem_adbus + 2)
      //    x10: ram1[15:0]
      //    x11: ram1[31:16]
      case (sel) 
        'd3 :  addr = mem_adbus + 6;
        'd2 :  addr = mem_adbus + 4;
        'd1 :  addr = mem_adbus + 2;
        'd0 :  addr = mem_adbus;
      endcase

      // get high and low 16-bit data of a word from lower memory
      mem_data = {read_mem_data(addr + 1), read_mem_data(addr)};

      if (`vbs)
        $display($time,, "check_wb2mem_write: adbus = %h databus = %h sel = %d",
                        mem_adbus, databus, sel);

      // checks based on the byte valid bits
      case (write)
        4'b0000: begin
          $display($time,, "Warning: no memory write occurs");
        end

        4'b0001: 
          if (mem_data[7:0] != databus[7:0]) begin 
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b0010: 
          if (mem_data[15:8] != databus[15:8]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b0011: 
          if (mem_data[15:0] != databus[15:0]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b0100:
          if (mem_data[23:16] != databus[23:16]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b0101:
          if (mem_data[23:16] != databus[23:16] || mem_data[7:0] != databus[7:0]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b0110:
          if (mem_data[23:8] != databus[23:8]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b0111:
          if (mem_data[23:0] != databus[23:0]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b1000:
          if (mem_data[31:24] != databus[31:24]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b1001:
          if (mem_data[31:24] != databus[31:24] || mem_data[7:0] != databus[7:0]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b1010:
          if (mem_data[31:24] != databus[31:24] || mem_data[15:8] != databus[15:8]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b1011:
          if (mem_data[31:24] != databus[31:24] || mem_data[15:0] != databus[15:0]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b1100: 
          if (mem_data[31:16] != databus[31:16]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b1101: 
          if (mem_data[31:16] != databus[31:16] || mem_data[7:0] != databus[7:0]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b1110: 
          if (mem_data[31:8] != databus[31:8]) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
          $stop;
          end

        4'b1111: 
          if (mem_data != databus) begin
          $display($time,, "Error at mem[0x%h-0x%h]: %h <-> write pattern %b", 
                   addr+1, addr, mem_data, write);
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

  //=========================================================================== 
  // Compare CPU write data with data from SDRAM
  // 
  // Assume write sequence is from ram0, ram1 --- to ramX
  // Note the write pattern is very different from that of check_wb2mem_write
  //=========================================================================== 
  task check_mem_write;
    input [31:0] mem_adbus; // first memory write address(x00)
    input [31:0] databus;   // cpu/wb write data
    input        sel;       // ram select
    input  [3:0] write;     // cpu write pattern

    reg [`MEM_ADDR_WIDTH - 1 : 0] addr;
    reg [15:0] mem_data_hi, mem_data_lo;

    begin
      // read lower-level memory: burst write address sequence: 
      // e.g.
      // 1. sel = 0 (mem_adbus)
      //    x00: ram0[15:0]
      //    x01: ram0[31:16]
      // 2. sel = 1 (mem_adbus + 2)
      //    x10: ram1[15:0]
      //    x11: ram1[31:16]
      case (sel) 
        'd3 :  addr = mem_adbus + 6;
        'd2 :  addr = mem_adbus + 4;
        'd1 :  addr = mem_adbus + 2;
        'd0 :  addr = mem_adbus;
      endcase

      // get high and low 16-bit data of a word from lower memory
      mem_data_hi  = read_mem_data(addr + 1);
      mem_data_lo  = read_mem_data(addr);

      if (`vbs)
        $display($time,, "check_mem_write: adbus = %h databus = %h sel = %d",
                        mem_adbus, databus, sel);

      case (write)
        4'b0000: begin
          $display($time,, "Warning: no memory write occurs");
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

  //=========================================================================== 
  // memory address alignment specified by the memory width
  //=========================================================================== 
  function [31:0] mem_addr;
    input [31:0] vaddr; // vaddr[2](i.e. sel) can be 1'bx
    input [31:0] width;
    reg   [31:0] temp_addr;
    begin
      case (width) // memory width
        // word aligned
        'd32: temp_addr = {2'b0, vaddr[31:2]}; 
        // hword aligned and then cache line aligned 
        'd16: temp_addr = {1'b0, vaddr[31:1]} & 32'hFFFF_FFFC; 
        // byte aligned
        'd8 : temp_addr = vaddr;
        default: begin
          $display("Unimplemented memory width");
          $stop;
        end
      endcase
      mem_addr = temp_addr;
    end
  endfunction

  //=========================================================================== 
  // CPU write data to cache (Assume the block size is 4)
  //=========================================================================== 
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
        $stop;
      end
    endcase

    cache_write[31  :  0] = ram_write(cache_ram[31  :  0], databus, write_mask[3:0], hit);
    cache_write[63  : 32] = ram_write(cache_ram[63  : 32], databus, write_mask[7:4], hit);
    cache_write[95  : 64] = ram_write(cache_ram[95  : 64], databus, write_mask[11:8], hit);
    cache_write[127 : 96] = ram_write(cache_ram[127 : 96], databus, write_mask[15:12],hit);

  endfunction

  //=========================================================================== 
  // Write buffer write data to cache (Assume the block size is 4)
  //=========================================================================== 
  function [99 : 0] wb_write;
    input [31:0] adbus;
    input [31:0] databus;
    input [3:0]  bwe;
    input [99:0] wb_ram;

    // mask wb ram and SDRAM write 
    reg  [15:0] write_mask;
    reg         word_sel;
    begin
      word_sel = adbus[2];
      case (word_sel) 
        'd0: write_mask = {12'b0, bwe};      // select ram0
        'd1: write_mask = {8'b0, bwe, 4'b0}; // select ram1
        //'d2: write_mask = {4'b0, bwe, 8'b0}; // select ram2
        //'d3: write_mask = {bwe, 12'b0};      // select ram3
        default: begin
          $display("Error: Function wb_write: ram word sel %b", word_sel);
          $stop;
        end
      endcase

      // wb_tag_val[wb_set],  1  [99]
      // wb_tag[wb_set],      27 [98:72] 
      // wb_ram1_val[wb_set], 4  [71:68] 
      // wb_ram0_val[wb_set], 4  [67:64]
      // wb_ram1[wb_set],     32 [63:32]  
      // wb_ram0[wb_set]});   32 [31:0]

      wb_write[31  :  0] = ram_write(wb_ram[31  :  0], databus, write_mask[3:0], 1'b1);
      wb_write[63  : 32] = ram_write(wb_ram[63  : 32], databus, write_mask[7:4], 1'b1);
      wb_write[67  : 64] = valid_write(wb_ram[67  : 64], write_mask[3:0]);
      wb_write[71  : 68] = valid_write(wb_ram[71  : 68], write_mask[7:4]);
      wb_write[98  : 72] = adbus[31:5];
      wb_write[99]       = 1'b1;
    end
  endfunction

  //=========================================================================== 
  // Write buffer read hit when read patter is equal to wb valid bits
  // precondition: Augment read bwe in CPU
  //=========================================================================== 
  function wb_read_hit;
    input [31:0] adbus;
    input [3:0]  wb_bwe;
    input        wb_tag_val;
    input [26:0] wb_tag;
    input [7:0]  wb_ram_val;

    reg bwe_hit;
    reg wb_sel; 

    begin
      wb_sel  = adbus[2];
      bwe_hit = 1'b0;
      case (wb_sel)
        'd1: 
        begin
          bwe_hit = wb_bwe == wb_ram_val[7:4];
        end
        'd0:
        begin
          bwe_hit = wb_bwe == wb_ram_val[3:0];
        end
        default: begin
          $display("Error: Function wb_read_hit: ram sel %b", wb_sel);
          $stop;
        end
     endcase
     wb_read_hit = wb_tag_val & (wb_tag == adbus[31:5]) & bwe_hit;
     if (wb_read_hit) $display("quick read"); 
   end
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
          $display($time,, "BEH: Accessing cache > Address = %h set = %d tag %h <-> ValidRam %b TagRam %h",
                            adbus, set, tag, val_ram, tag_ram);
          `READ_CACHE_HIT:
          $display($time,, "BEH: Read hit > read cache data = %h", databus);

          `READ_CACHE_MISS:
          $display($time,, "BEH: Read miss > Assert read_mem");

          `READ_MEM:
          $display($time,, "BEH: Read miss > drive memory adbus = %h", adbus);

          `FILLED_CACHE:
          $display($time,, "BEH: Read miss > fill cache: set = %d val = %b tag = %h ram = %h %h", 
                            set, val_ram, tag_ram, data_ram1, data_ram0);
          `READ_CACHE_DATA:
          $display($time,, "BEH: Read miss > read cache data = %h", databus);

          `WRITE_CACHE_HIT:
          $display($time,, "BEH: Write hit > update cache: cache index = %d val = %b tag = %h ram = %h %h", 
                            set, val_ram, tag_ram, data_ram1, data_ram0);

          `WRITE_CACHE_MISS:
          $display($time,, "BEH: Write miss > update cache: cache index = %d val = %b tag = %h ram = %h %h", 
                            set, val_ram, tag_ram, data_ram1, data_ram0);
          `WRITE_CACHE:
          $display($time,, "BEH: Write miss > Assert write_mem");

          `WRITE_MEM:
          $display($time,, "BEH: Write miss > drive memory adbus = %h data = %h", adbus, databus);

        default: begin
          $display("BEH: Error: undefined Debug state");
          $stop;
        end
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

  initial begin : initialize_wb
    integer i;
    for (i = 0; i < words; i = i + 1) begin
      wb_tag_val[i]  = 0;
      wb_tag[i]      = 0;
      wb_ram1_val[i] = 0;
      wb_ram0_val[i] = 0;
    end
  end

  assign databus     = databus_txd;    // databus as output
  assign mem_databus = mem_databus_txd;// memory databus as output

  /* uncached range A000_0000 - BFFF_FFFF */
  assign ce =  adbus[31:29] == 3'b101 ?  1'b0 : 1'b1;    

  //=====================================================================================
  // Cache operations start here
  //=====================================================================================
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

    //=====================================================================================
    // wb_full operation begins
    //=====================================================================================
    if (wb_full()) begin 

      // debug write buffer
      $display("*******************************************");
      $display("BEH: display wb before flushing all entries");
      display_wb();

      for (flush_cnt = 0; flush_cnt < wb_words; flush_cnt = flush_cnt + 1) begin
        $display("flush_cnt = %d", flush_cnt);
        write_mem = 1'b1;
        wait (grant_mem);

        // Get memory write address from 4-entry WB 
        wb_adbus = {wb_tag[flush_cnt], flush_cnt[1:0], 1'bx, 2'b0};

        // aligned half-word address
        mem_adbus = mem_addr(wb_adbus, 16);
        mem_adbus_temp = mem_adbus;

        bwe_lo = 4'b1111; bwe_hi = 4'b1111;

        //===================================================================================
        Debug(`vbs, `WRITE_MEM, mem_adbus, cache_data_vector, databus);
        //===================================================================================

        wait (ready_mem);
        databus_temp = wb_ram0[flush_cnt];
        mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_lo[1:0]);

        @(posedge clk);
        mem_adbus = mem_adbus + 1;
        mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_lo[3:2]);

        @(posedge clk);
        #1 check_wb2mem_write(mem_adbus_temp, databus_temp, 1'b0, bwe_lo);

        mem_adbus = mem_adbus + 1;
        databus_temp = wb_ram1[flush_cnt];
        mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_hi[1:0]);

        @(posedge clk);
        mem_adbus = mem_adbus + 1;
        mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_hi[3:2]);

        @(posedge clk)
        #1 check_wb2mem_write(mem_adbus_temp, databus_temp, 1'b1, bwe_hi);
      end // Done with SDRAM write
      
      flush_wb();

      // debug write buffer
      $display("******************************************");
      $display("BEH: display wb after flushing all entries");
      display_wb();

      write_mem = 1'b0;
      mem_adbus = 32'hz;

      /* ready is not set in RTL 
      ready     = 1'b1;
      @(posedge clk)
      ready = 1'b0;
      */
    end  

    //=====================================================================================
    // wb_full operation ends
    //=====================================================================================

    // data are uncached with I/O address
    if (read || write) begin : request
      //===================================================================================
      Debug(`vbs, `ACCESS_CACHE, adbus, cache_data_vector, databus);
      //===================================================================================
      grant = 1'b1;
      if (tag[set] == adbus[31:asize + msize + bsize] && valid[set])
        hit = 1'b1;
      else
        hit = 1'b0;

      if (hit) begin 
        if (read) begin // read_hit
          ready           = 1'b1;
          ram_data_vector = { ram3[set], ram2[set], ram1[set], ram0[set] };
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
            {ram3[set], ram2[set], ram1[set], ram0[set]} = cache_write(sel, 
                                                                       bwe, 
                                                                       databus,
                                                                       {ram3[set], 
                                                                        ram2[set],
                                                                        ram1[set],
                                                                        ram0[set]},
                                                                       hit);

          //===================================================================================
          #1; // wait for cache_data_vector to get the updated cache values
          Debug(`vbs, `WRITE_CACHE_HIT, adbus, cache_data_vector, databus);
          //===================================================================================
          end
          

          // WB write w/o SDRAM write on invalid tag or valid tag and tag match
          if (!wb_tag_val[wb_set] || 
               wb_tag[wb_set] == adbus[31:wb_asize + msize + bsize]) begin

            wb_data_vector = { wb_tag_val[wb_set], wb_tag[wb_set], 
                               wb_ram1_val[wb_set], wb_ram0_val[wb_set],
                               wb_ram1[wb_set], wb_ram0[wb_set] };

            { wb_tag_val[wb_set], wb_tag[wb_set], 
              wb_ram1_val[wb_set], wb_ram0_val[wb_set], 
              wb_ram1[wb_set], wb_ram0[wb_set] } = wb_write(adbus, 
                                                            databus,
                                                            bwe,
                                                            wb_data_vector);

            // debug write buffer
            $display("DC write hit and WB write w/o SDRAM write");
            display_wb();

            ready = 1'b1;
            mem_adbus = 32'hz;
            wait (!write);
            ready = 1'b0;
          end 
          else begin
            $display("DC write hit and WB write w/ SDRAM write");
          // WB write w/ SDRAM write otherwise
            write_mem = 1'b1;

            wait (grant_mem);
            
            // Get memory write address from WB
            wb_adbus = {wb_tag[wb_set], wb_set, sel, 2'b0};

            // aligned half-word address
            mem_adbus = mem_addr(wb_adbus, 16); 
            
            mem_adbus_temp = mem_adbus;

            bwe_lo = wb_ram0_val[wb_set];
            bwe_hi = wb_ram1_val[wb_set];

            //===================================================================================
            Debug(`vbs, `WRITE_MEM, mem_adbus, cache_data_vector, databus);
            //===================================================================================
            
            wait (ready_mem);

            //-----------------------------------------------------------------------------------
            // In burst mode, the bytes are written in consecutive adresses.
            //-----------------------------------------------------------------------------------
            databus_temp = wb_ram0[wb_set];
            mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_lo[1:0]);

            @(posedge clk);
            mem_adbus = mem_adbus + 1;
            mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_lo[3:2]);

            @(posedge clk);
            #1 check_wb2mem_write(mem_adbus_temp, databus_temp, 1'b0, bwe_lo);

            mem_adbus = mem_adbus + 1;
            databus_temp = wb_ram1[wb_set];
            mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_hi[1:0]);

            @(posedge clk);
            mem_adbus = mem_adbus + 1;
            mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_hi[3:2]);

            @(posedge clk)
            #1 check_wb2mem_write(mem_adbus_temp, databus_temp, 1'b1, bwe_hi);

            // Flush WB at wb_set
            flush(wb_set);

            // debug write buffer
            $display("Display wb after flushing entry %d", wb_set);
            display_wb();

            //-----------------------------------------------------------------------------------
            // Write WB after SDRAM write
            //-----------------------------------------------------------------------------------
            wb_data_vector = { wb_tag_val[wb_set], wb_tag[wb_set], 
                               wb_ram1_val[wb_set], wb_ram0_val[wb_set],
                               wb_ram1[wb_set], wb_ram0[wb_set] };

            { wb_tag_val[wb_set],  wb_tag[wb_set], 
              wb_ram1_val[wb_set], wb_ram0_val[wb_set],
              wb_ram1[wb_set], wb_ram0[wb_set] } = wb_write(adbus,  
                                                            databus, 
                                                            bwe,
                                                            wb_data_vector);

            // debug write buffer
            $display("Display wb after writing entry %d", wb_set);
            display_wb();

            mem_databus_txd = 32'hz;
            mem_adbus       = 32'hz;
            write_mem       = 1'b0;
            ready           = 1'b1;
            wait (!write);

            ready           = 1'b0;
          end
        end // write_hit
      end 

      else begin  // write_miss
        if (write) begin 
          // no cache write
          {ram3[set], ram2[set], ram1[set], ram0[set]} = cache_write(sel, 
                                                                     bwe, 
                                                                     databus,
                                                                     {ram3[set], 
                                                                      ram2[set],
                                                                      ram1[set],
                                                                      ram0[set]},
                                                                     hit);

          //tag[set]   = adbus[31 : asize + msize + bsize];
          //valid[set] = 1'b1;
          //===================================================================================
          #1; // wait for cache_data_vector to get the updated cache values
          Debug(`vbs, `WRITE_CACHE_MISS, adbus, cache_data_vector, databus);
          //===================================================================================
          

          // WB write only on NOT tag valid and tag mismatch
          if (!wb_tag_val[wb_set] || 
               wb_tag[wb_set] == adbus[31:wb_asize + msize + bsize]) begin

            wb_data_vector = { wb_tag_val[wb_set], wb_tag[wb_set], 
                               wb_ram1_val[wb_set], wb_ram0_val[wb_set],
                               wb_ram1[wb_set], wb_ram0[wb_set] };

            { wb_tag_val[wb_set], wb_tag[wb_set],
              wb_ram1_val[wb_set], wb_ram0_val[wb_set],
              wb_ram1[wb_set], wb_ram0[wb_set]} = wb_write(adbus, 
                                                           databus,
                                                           bwe,
                                                           wb_data_vector);
            // debug write buffer
            $display("DC write miss and WB write w/o SDRAM write");
            display_wb();

            ready           = 1'b1;
            mem_adbus     = 32'hz;
            wait (!write);
            ready           = 1'b0;

          end 
          else begin
            $display("DC write miss and WB write w/ SDRAM write");
            write_mem = 1'b1;

            wait (grant_mem);

            // Get memory write address from WB
            wb_adbus = {wb_tag[wb_set], wb_set, sel, 2'b0};

            // aligned half-word address
            mem_adbus = mem_addr(wb_adbus, 16); 
            
            mem_adbus_temp = mem_adbus;

            bwe_lo = wb_ram0_val[wb_set];
            bwe_hi = wb_ram1_val[wb_set];

            //===================================================================================
            Debug(`vbs, `WRITE_MEM, mem_adbus, cache_data_vector, databus);
            //===================================================================================
            
            wait (ready_mem);

            //-----------------------------------------------------------------------------------
            // In burst mode, the bytes are written in consecutive adresses.
            //-----------------------------------------------------------------------------------
            databus_temp = wb_ram0[wb_set];
            mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_lo[1:0]);

            @(posedge clk);
            mem_adbus = mem_adbus + 1;
            mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_lo[3:2]);

            @(posedge clk);
            #1 check_wb2mem_write(mem_adbus_temp, databus_temp, 1'b0, bwe_lo);

            mem_adbus = mem_adbus + 1;
            databus_temp = wb_ram1[wb_set];
            mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_hi[1:0]);

            @(posedge clk);
            mem_adbus = mem_adbus + 1;
            mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_hi[3:2]);

            @(posedge clk)
            #1 check_wb2mem_write(mem_adbus_temp, databus_temp, 1'b1, bwe_hi);

            // Flush WB at wb_set
            $display("Display wb after flushing entry %d", wb_set);
            flush(wb_set);

            //-----------------------------------------------------------------------------------
            // Write WB after SDRAM write
            //-----------------------------------------------------------------------------------
            wb_data_vector = { wb_tag_val[wb_set], wb_tag[wb_set], 
                               wb_ram1_val[wb_set], wb_ram0_val[wb_set],
                               wb_ram1[wb_set], wb_ram0[wb_set] };

            { wb_tag_val[wb_set], wb_tag[wb_set], 
              wb_ram1_val[wb_set], wb_ram0_val[wb_set], 
              wb_ram1[wb_set], wb_ram0[wb_set]} = wb_write(adbus, 
                                                           databus,
                                                           bwe,
                                                           wb_data_vector);

            // debug write buffer
            $display("Display wb after writing entry %d", wb_set);
            display_wb();

            mem_databus_txd = 32'hz;
            mem_adbus       = 32'hz;
            write_mem       = 1'b0;
            ready           = 1'b1;
            wait (!write);
            ready           = 1'b0;
          end 
        end
        else if (read) begin // read_miss
          //===================================================================================
          //Debug(`vbs, `READ_WB, mem_adbus, cache_data_vector, databus);
          //===================================================================================

          // WB read only on WB hit
          if (wb_read_hit(adbus, 
                          bwe,
                          wb_tag_val[wb_set],
                          wb_tag[wb_set], 
                          {wb_ram1_val[wb_set], wb_ram0_val[wb_set]}))
          begin
            databus_txd   = ram_read(wb_ram_data_vector, sel); 
            mem_adbus     = 32'hz;
            ready         = 1'b1;
            wait (!read);
            ready         = 1'b0;
          end

          else begin

          if (wb_tag_val[wb_set] &&
               wb_tag[wb_set] != adbus[31:wb_asize + msize + bsize]) begin

            $display("DC read miss and WB read miss w/o SDRAM merge read");
            write_mem = 1'b1;

            wait (grant_mem);

            // Get memory write address from WB
            wb_adbus = {wb_tag[wb_set], wb_set, sel, 2'b0};

            // aligned half-word address
            mem_adbus = mem_addr(wb_adbus, 16); 
            
            mem_adbus_temp = mem_adbus;

            bwe_lo = wb_ram0_val[wb_set];
            bwe_hi = wb_ram1_val[wb_set];

            //===================================================================================
            Debug(`vbs, `WRITE_MEM, mem_adbus, cache_data_vector, databus);
            //===================================================================================
            
            wait (ready_mem);

            //-----------------------------------------------------------------------------------
            // In burst mode, the bytes are written in consecutive adresses.
            //-----------------------------------------------------------------------------------
            databus_temp = wb_ram0[wb_set];
            mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_lo[1:0]);

            @(posedge clk);
            mem_adbus = mem_adbus + 1;
            mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_lo[3:2]);

            @(posedge clk);
            #1 check_wb2mem_write(mem_adbus_temp, databus_temp, 1'b0, bwe_lo);

            mem_adbus = mem_adbus + 1;
            databus_temp = wb_ram1[wb_set];
            mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_hi[1:0]);

            @(posedge clk);
            mem_adbus = mem_adbus + 1;
            mem_databus_txd = wb2mem_write(databus_temp, mem_adbus, bwe_hi[3:2]);

            @(posedge clk)
            #1 check_wb2mem_write(mem_adbus_temp, databus_temp, 1'b1, bwe_hi);

            // Flush WB at wb_set
            $display("Display wb after flushing entry %d", wb_set);
            flush(wb_set);
            display_wb();

            mem_databus_txd = 32'hz;
            mem_adbus       = 32'hz;
            write_mem       = 1'b0;
            #1; 
          end

            // two cases: 1. invalid tag 2. valid and match tag
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

              //===================================================================================
              Debug(`vbs, `FILLED_CACHE, mem_adbus, cache_data_vector, databus);
              //===================================================================================
            end

            ram_data_vector = { ram3[set], ram2[set], ram1[set], ram0[set] };

            { ram3[set], ram2[set], ram1[set], ram0[set] } = ram_merge( ram_data_vector, 
                                                                        wb_ram_data_vector, 
                                                                        {wb_ram1_val[wb_set], 
                                                                         wb_ram0_val[wb_set]});

            ram_data_vector = { ram3[set], ram2[set], ram1[set], ram0[set] };
            databus_txd   = ram_read(ram_data_vector, sel);
            mem_adbus     = 32'hz;
            read_mem      = 1'b0; 
            ready         = 1'b1;
            //===================================================================================
            Debug(`vbs, `READ_CACHE_DATA, mem_adbus, cache_data_vector, databus_txd);
            //===================================================================================
            
            wait (!read);

            ready         = 1'b0;
          end
        end // read_miss
      end 
    end // request
  end

endmodule 
