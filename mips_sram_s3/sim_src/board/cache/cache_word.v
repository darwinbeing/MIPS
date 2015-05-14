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
  input         write,
  output reg    ready,
  output reg    grant,
  inout  [31:0] databus,
  input  [31:0] adbus);

  parameter words = 128, asize = 7; 
  parameter bytes = 4, bsize = 2; 

  // Cache size is 128 words
  reg [31:0] ram [0:words-1];
  reg [31-asize-bsize :0] tag [0:words-1];
  reg valid [0:words-1];
  reg hit;

  wire  [asize-1:0] set = adbus[asize + 1 : bsize];
  
  wire [31:0] databus_rxd, mem_databus_rxd;
  reg  [31:0] databus_txd, mem_databus_txd;

  assign databus         = databus_txd;// databus as output
  //assign databus_rxd     = databus;        // databus as input
  assign mem_databus     = mem_databus_txd;// txd from cache perspective
  //assign mem_databus_rxd = mem_databus;

  always @ (posedge clk) begin
    // default
    databus_txd = 32'hz;
    mem_databus_txd = 32'hz;
    mem_adbus = 32'hz;
    read_mem = 1'b0;
    write_mem = 1'b0;
    ready = 1'b0;

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
          mem_adbus       = 32'hz;
          ready           = 1'b0;
        end // read_hit
        else if (write) begin // write_hit
          ram[set]        = databus; //databus_rxd;
          tag[set]        = adbus[31:asize+bsize];
          valid[set]      = 1'b1;
          write_mem       = 1'b1;
          wait (grant_mem);
          mem_databus_txd = databus; //databus_rxd;
          mem_adbus       = adbus;
          wait (ready_mem);
          write_mem       = 1'b0;
          mem_databus_txd = 32'hz;
          ready           = 1'b1;
          wait (write == 1'b0);
          ready           = 1'b0;
        end // write_hit
        //else begin
        //end
      end // hit
      else begin 
        if (write) begin // write_miss
          ram[set]        = databus; //databus_rxd; 
          tag[set]        = adbus[31:asize+bsize];
          valid[set]      = 1'b1;
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
          ram[set]        = mem_databus; //mem_databus_rxd; 
          tag[set]        = adbus[31:asize+bsize];
          valid[set]      = 1'b1;
          databus_txd     = mem_databus; //mem_databus_rxd;
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
