`define N  4

module test_arbiter;

  reg                 clock;
  reg                 rst;
  reg                 skip_wait;
  reg      [`N-1 : 0] read_request;
  reg      [`N-1 : 0] write_request;
  wire     [`N-1 : 0] grant;
  wire     memsel;
  wire     rwbar;
  wire     ready;
  integer  i;

arbiter rtl (
  clock,
  rst,
  skip_wait,
  read_request,
  write_request,
  grant,
  memsel,
  rwbar,
  ready );

arbitrator beh (
  read_request,
  write_request,
  grant,
  clock,
  skip_wait,
  memsel,
  rwbar,
  ready );

  always #10 clock = ~clock ;

  initial begin
    clock = 1;
    rst = 0;
    read_request = 4'd0;
    write_request = 4'd0;
    skip_wait = 0;
    #100 rst = 1;
    #100 rst = 0;

    #490;
    for (i = 0; i < 20; i=i+1) begin
      read_request = read_request + 1;
      #20;
    end

    read_request = 4'd0;
    write_request = 4'd10;
    skip_wait = 1;

    for (i = 0; i < 20; i=i+1) begin
      if (i > 1) skip_wait = 0;
      write_request = write_request + 1;
      #20;
    end

    write_request = 4'd0;

    #200
    $stop;
  end
endmodule 

