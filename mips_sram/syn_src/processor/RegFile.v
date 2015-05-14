module RegFile
  (
   clk,
   rst,
   Wen,
   Wa, 
   Wd, 
   Ren1,
   Ra1,
   Rd1,
   Ren2,
   Ra2,
   Rd2
   );
 
  input clk;
  input rst;
  
  // RegFile Write enable
  input Wen;

  // RegFile Write address port
  input [4:0] Wa;

  // RegFile Write port  
  input [31:0] Wd;
 
  // RegFile Read port 1 enable
  input  Ren1;

  // RegFile Read address port 1
  input  [4:0] Ra1;

  // RegFile Read data port 1
  output [31:0] Rd1;

  // RegFile Read port 2 enable
  input  Ren2;

  // RegFile Read address port 2
  input  [4:0] Ra2;

  // RegFile Read data port 2
  output [31:0] Rd2;

  // Registers memory
  reg [31:0] RF_mem[0:31];
  
  always @(posedge clk or posedge rst)
  begin
    if(rst)
    begin
      RF_mem[0] <= 32'b0;
      RF_mem[1] <= 32'h0;
      RF_mem[2] <= 32'h0;
      RF_mem[3] <= 32'h0;
      RF_mem[4] <= 32'h0;
      RF_mem[5] <= 32'h0;
      RF_mem[6] <= 32'h0;
      RF_mem[7] <= 32'h0;
      RF_mem[8] <= 32'h0;
      RF_mem[9] <= 32'h0;
      RF_mem[10] <= 32'h0;
      RF_mem[11] <= 32'h0;
      RF_mem[12] <= 32'h0;
      RF_mem[13] <= 32'h0;
      RF_mem[14] <= 32'h0;
      RF_mem[15] <= 32'h0;
      RF_mem[16] <= 32'h0;
      RF_mem[17] <= 32'h0;
      RF_mem[18] <= 32'h0;
      RF_mem[19] <= 32'h0;
      RF_mem[20] <= 32'h0;
      RF_mem[21] <= 32'h0;
      RF_mem[22] <= 32'h0;
      RF_mem[23] <= 32'h0;
      RF_mem[24] <= 32'h0;
      RF_mem[25] <= 32'h0;
      RF_mem[26] <= 32'h0;
      RF_mem[27] <= 32'h0;
      RF_mem[28] <= 32'h0; // gp
      //RF_mem[29] <= 32'h001ffe00; // sp
      RF_mem[29] <= 32'h0;
      RF_mem[30] <= 32'h0;
      RF_mem[31] <= 32'h0; // ra
    end 
    else begin
      if (Wen && Wa != 0)
      begin
	      RF_mem[Wa] <= Wd;
      end
    end
  end
 
  assign Rd1 = Ren1 ? RF_mem[Ra1] : 32'b0;
  assign Rd2 = Ren2 ? RF_mem[Ra2] : 32'b0;
            

endmodule 
