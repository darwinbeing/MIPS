module TestBench;
reg        clk;       
reg [12:0] mem_waddr;
reg [14:0] mem_wdata;
reg        mem_web;
reg        rst;        
wire [9:0] VGA_R;
wire [9:0] VGA_G;
wire [9:0] VGA_B;
wire       VGA_BLANK  ;
wire       VGA_CLK    ;
wire       VGA_H_SYNC ;
wire       VGA_SYNC   ;
wire       VGA_V_SYNC ;

always #18.518 clk = ~clk;

initial begin
  clk = 1'b0;
  rst = 1'b1;
  mem_waddr = 0;
  mem_web = 0;
  mem_wdata = 15'h7fff;
  #300;
  rst = 1'b0;
end

Display_IF Display_IF
(
  clk,       
  mem_waddr,
  mem_wdata,
  mem_web,
  rst,        
  VGA_B,
  VGA_BLANK  ,
  VGA_CLK    ,
  VGA_G,
  VGA_H_SYNC ,
  VGA_R,
  VGA_SYNC   ,
  VGA_V_SYNC
);

endmodule 
