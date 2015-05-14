//-----------------------------------------------------------------------
// Behavioral direct-mapped cache model
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

  // Cache depth is 128 words
  reg [31:0]      ram [0:127];
  reg [31-7-2 :0] tag [0:127];
  reg             valid [0:127];

  reg         hit;
  reg  [31:0] databus_txd, mem_databus_txd;
  wire  [6:0] set = adbus[8:2];

  function [31:0] ram_write;
    input [31:0] ram[set];
    input [31:0] databus;
    input  [3:0] write;
    input        hit;
    reg   [31:0] temp;
    begin
      temp = ram[set];
      if (hit) begin
        case (write)
          4'b1000: ram_write = {databus[31:24], temp[23:0]};
          4'b0100: ram_write = {temp[31:24], databus[23:16], temp[15:0]};
          4'b0010: ram_write = {temp[31:16], databus[15:8], temp[7:0]};
          4'b0001: ram_write = {temp[31:8], databus[7:0]};
          4'b1100: ram_write = {databus[31:16], temp[15:0]};
          4'b0011: ram_write = {temp[31:16], databus[15:0]};
          4'b1111: ram_write = databus;
          default: $display("Error write %b", write);
        endcase
      end
      else begin 
        case (write)
          4'b1000: ,
          4'b0100: ,
          4'b0010: ,
          4'b0001: ,
          4'b1100: ,
          4'b0011: ram_write = temp;     // no cache write
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
          4'b1000: ,
          4'b0100: ,
          4'b0010: ,
          4'b0001: ,
          4'b1100: ,
          4'b0011: valid_write = 1'b0; // invalidate 
          4'b1111: valid_write = 1'b1;
          default: $display("Error write %b", write);
        endcase
      end
    end
  endfunction

  assign databus     = databus_txd;    // databus as output
  assign mem_databus = mem_databus_txd;// memory databus as output

  always @ (posedge clk) begin
    // default
    databus_txd     = 32'hz;
    mem_databus_txd = 32'hz;
    mem_adbus       = 32'hz;
    read_mem        = 1'b0;
    write_mem       = 1'b0;
    ready = 1'b0;

    if (read || write) begin : request
      grant = 1'b1;
      if (tag[set] == adbus[31:9] && valid[set])
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
        end // read_hit
        else if (write) begin // write_hit
          ram[set]        = ram_write(ram[set], databus, write, hit);
          valid[set]      = valid_write(write, hit);
          write_mem       = 1'b1;
          wait (grant_mem);
          mem_databus_txd = databus; //databus_rxd;
          mem_adbus       = adbus;
          wait (ready_mem);
          write_mem       = 1'b0;
          mem_databus_txd = 32'hz;
          mem_adbus       = 32'hz;
          ready           = 1'b1;
          wait (write == 1'b0);
          ready           = 1'b0;
        end // write_hit
        //else begin
        //end
      end // hit
      else begin 
        if (write) begin // write_miss
          ram[set]        = ram_write(ram[set], databus, write, hit);
          tag[set]        = adbus[31:9];
          //$display("set = %d", set);
          valid[set]      = valid_write(write, hit);
          write_mem       = 1'b1;
          wait (grant_mem);
          mem_databus_txd = databus; //databus_rxd;
          mem_adbus       = adbus;
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
          wait (ready_mem);
          read_mem        = 1'b0;
          ram[set]        = mem_databus;
          tag[set]        = adbus[31:9];
          valid[set]      = 1'b1;
          databus_txd     = mem_databus;
          mem_adbus       = 32'hz;
          ready           = 1'b1;
          wait (read == 1'b0);
          ready           = 1'b0;
        end // read_miss
      end 
    end //: request
    else begin //: no_request
      read_mem  = 1'b0;
      write_mem = 1'b0;
      grant     = 1'b0;
      ready     = 1'b0;
      hit       = 1'b0;
    end //: no_request
  end

endmodule 
