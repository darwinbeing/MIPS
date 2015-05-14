module Display
(
  input       clka,
  input       clkb,

  input [9:0] pixel_count,  // V_count
  input [9:0] line_count,   // H_count

  input [31:0] mem_waddr, 
  input [31:0] mem_wdata, 
  input        mem_web, 

  output [9:0] red,
  output [9:0] green,
  output [9:0] blue
);

wire [14:0] mem_rdata;
wire [12:0] mem_raddr;

assign mem_raddr = {line_count[9:4], pixel_count[9:3]};

vmem8192x15 vmem8192x15 (
   .clka  (clka),
   .addra (mem_raddr),
   .dataa (mem_rdata),
   .clkb  (clkb),
   .addrb (mem_waddr),
   .datab (mem_wdata),
   .web   (mem_web)
   );

assign red   = {mem_rdata[14:10], mem_rdata[14:10]};
assign green = {mem_rdata[9:5], mem_rdata[9:5]};
assign blue  = {mem_rdata[4:0], mem_rdata[4:0]};

endmodule

