//-----------------------------------------------------------------------
// Behavioral direct-mapped cache model
// 
// 10/15/10 add cache enable (ce)
//-----------------------------------------------------------------------
module cache (
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
  input   [3:0] write,
  output reg    ready,
  output reg    grant,
  inout  [31:0] databus,
  input  [31:0] adbus);

  parameter words = 64, asize = 6; 
  parameter bytes = 4, bsize = 2; 

  reg [31:0] ram [0:words-1];
  reg [31-asize-bsize :0] tag [0:words-1];
  reg valid [0:words-1];

  reg         hit;
  reg  [31:0] databus_txd, mem_databus_txd;
  wire  [asize-1:0] set = adbus[asize + 1 : bsize];
  wire ce;

  function [31:0] ram_write;
    input [31:0] ram_data;
    input [31:0] databus;
    input  [3:0] write;
    input        hit;
    begin
      if (hit) begin
        case (write)
          4'b1000: ram_write = {databus[31:24], ram_data[23:0]};
          4'b0100: ram_write = {ram_data[31:24], databus[23:16], ram_data[15:0]};
          4'b0010: ram_write = {ram_data[31:16], databus[15:8], ram_data[7:0]};
          4'b0001: ram_write = {ram_data[31:8], databus[7:0]};
          4'b1100: ram_write = {databus[31:16], ram_data[15:0]};
          4'b0011: ram_write = {ram_data[31:16], databus[15:0]};
          4'b1111: ram_write = databus;
          default: $display("Error write %b", write);
        endcase
      end
      else begin 
        case (write)
          4'b1000,
          4'b0100,
          4'b0010,
          4'b0001,
          4'b1100,
          4'b0011: ram_write = ram_data;     // no cache write
          4'b1111: ram_write = databus;
          default: $display("Error write %b", write);
        endcase
      end
    end
  endfunction

  function valid_write;
    input  [3:0] write;
    input        hit;
    begin
      if (hit) 
        valid_write = 1'b1;
      else begin
        case (write)
          4'b1000,
          4'b0100,
          4'b0010,
          4'b0001,
          4'b1100,
          4'b0011: valid_write = 1'b0; // invalidate 
          4'b1111: valid_write = 1'b1;
          default: $display("Error write %b", write);
        endcase
      end
    end
  endfunction

  assign databus     = databus_txd;    // databus as output
  assign mem_databus = mem_databus_txd;// memory databus as output
  assign ce =  adbus[31:29] == 3'b101 ? 
               1'b0 : 1'b1;    // uncached range A000_0000 - BFFF_FFFF 

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
      grant = 1'b1;
      if (tag[set] == adbus[31:asize + bsize] && valid[set])
        hit = 1'b1;
      else
        hit = 1'b0;
      if (hit) begin 
        if (read) begin // read_hit
          ready           = 1'b1;
          databus_txd     = ram[set];
          wait (read == 1'b0);
          databus_txd     = 32'hz;
          ready           = 1'b0;
        end 
        else if (write) begin // write_hit
          if (ce) begin
            ram[set]        = ram_write(ram[set], databus, write, hit);
            tag[set]        = adbus[31:asize+bsize];
            valid[set]      = valid_write(write, hit);
          end
          write_mem       = 1'b1;
          wait (grant_mem);
          mem_databus_txd = databus; //databus_rxd;
          mem_adbus       = adbus;
          //write_mem       = 1'b0;
          wait (ready_mem);
          write_mem       = 1'b0;
          mem_databus_txd = 32'hz;
          mem_adbus       = 32'hz;
          ready           = 1'b1;
          wait (write == 1'b0);
          ready           = 1'b0;
        end // write_hit
      end 
      else begin 
        if (write) begin // write_miss
          if (ce) begin
            ram[set]        = ram_write(ram[set], databus, write, hit);
            tag[set]        = adbus[31:asize+bsize];
            valid[set]      = valid_write(write, hit);
          end
          write_mem       = 1'b1;
          wait (grant_mem);
          mem_databus_txd = databus; //databus_rxd;
          mem_adbus       = adbus;
          //write_mem       = 1'b0;
          wait (ready_mem);
          write_mem       = 1'b0;
          mem_databus_txd = 32'hz;
          mem_adbus       = 32'hz;
          ready           = 1'b1;
          wait (write == 1'b0);
          ready           = 1'b0;
        end // write_miss
        else if (read) begin // read_miss
          read_mem        = 1'b1;
          wait (grant_mem);
          mem_adbus       = adbus;
          //read_mem       = 1'b0;
          wait (ready_mem);
          read_mem        = 1'b0;
          if (ce) begin
            ram[set]        = mem_databus;
            tag[set]        = adbus[31:asize+bsize];
            valid[set]      = 1'b1;
          end
          databus_txd     = mem_databus;
          mem_adbus       = 32'hz;
          ready           = 1'b1;
          wait (read == 1'b0);
          ready           = 1'b0;
        end // read_miss
      end 
    end //: request
    /*
    else begin //: no_request
      read_mem  = 1'b0;
      write_mem = 1'b0;
      grant     = 1'b0;
      ready     = 1'b0;
      hit       = 1'b0;
    end //: no_request
    */
  end

endmodule 
