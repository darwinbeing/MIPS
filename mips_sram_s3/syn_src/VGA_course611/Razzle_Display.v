module Razzle_Display
(
  input       iCLK,
  input [9:0] pixel_count,  // V_count
  input [9:0] line_count,   // H_count
  input       VGA_V_SYNC,   //
  input       stop,
  input       video_on,

	output [9:0] red,
  output [9:0] green,
  output [9:0] blue
);

parameter VTH = 11'd240, RTH = 11'd120, HTH = 11'd320, CTH = 11'd160;
reg  [15:0] dither;
reg [10:0] sum, rowdist, coldist;
reg [10:0] nrowdist, ncoldist;

always @ (posedge VGA_V_SYNC) begin
  if (VGA_V_SYNC) begin
    dither <= dither + 16'b1;
  end
end

always @ (posedge iCLK) begin
  if (video_on) begin
    if (pixel_count > VTH)
      rowdist <= pixel_count - VTH;
    else
      rowdist <= VTH - pixel_count;

    if (rowdist > RTH)
      nrowdist <= rowdist - RTH;
    else
      nrowdist <= RTH - rowdist;

    if (line_count > HTH)
      coldist <= line_count - HTH;
    else
      coldist <= HTH - line_count;

    if (coldist > CTH)
      ncoldist <= coldist - CTH;
    else
      ncoldist <= CTH - coldist;

    sum <= nrowdist + ncoldist + dither;
  end
end
  
// Use index to select colors
//assign red   = (idx[0] ? 10'h3ff: 10'h000);
//assign green = (idx[1] ? 10'h3ff: 10'h000);
//assign blue  = (idx[2] ? 10'h3ff: 10'h000);

// Use combination to select colors
assign red   = {sum[10:7], sum[10:7], sum[10:9]};
assign green = {sum[6:3], sum[6:3], sum[6:5]};
assign blue  = {sum[2:0], sum[2:0], sum[2:0], sum[2]};

endmodule

