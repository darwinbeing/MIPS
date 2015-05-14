`include "MIPS1000_defines.v"
`include "cache.h"
`define N  4

//======================================================================
// For beh system model
//======================================================================
module arbiter_beh (
  input                 clk,
  input                 rst,
  input                 skip_wait,
  input      [`N-1 : 0] read_request,
  input      [`N-1 : 0] write_request,
  output reg [`N-1 : 0] grant,
  output     memory_sel,
  output reg rwbar,
  output reg ready );

  parameter IDLE = 2'd0, GRANT = 2'd1, MEMORY = 2'd2;

  // assume `MEM_DELAY >= 2
  parameter read_wait_p0 = `MEM_DELAY,  read_wait_p1 = `MEM_DELAY,  
            read_wait_p2 = `MEM_DELAY,  read_wait_p3 = `MEM_DELAY;
  parameter write_wait_p0 =`MEM_DELAY-1,  write_wait_p1 = `MEM_DELAY-1,  
            write_wait_p2 =`MEM_DELAY-1,  write_wait_p3 = `MEM_DELAY-1;

  wire [`N-1 : 0] request_int;
  wire [`N-1 : 0] request;
  wire [`N-1 : 0] grant_int;
  wire            enable;
  wire            read_enable;
  wire            write_enable;
  wire            wait_done;

  reg [3:0] wait_cnt;
  reg [3:0] mem_cnt;
  reg [1:0] state;
  reg memsel;
  
  /*
  --   grant[3] = req[3];
  --   grant[2] = ~req[3] & req[2];
  --   grant[1] = ~req[3] & ~req[2] & req[1];
  --   grant[0] = ~req[3] & ~req[2] & ~req[1] & req[0];
  --   ...etc...
  --
  --   The above assignments are equivalent to the followings:
  --
  --   grant[3] = ~0                          & req[3];
  --   grant[2] = ~(0 | req[3])               & req[2];
  --   grant[1] = ~(reg[3] | req[2])          & req[1];
  --   grant[0] = ~(reg[3] | req[2] | req[1]) & req[0];
  --
  --   Thus, given an intermediate signal req_inter, we have:
  --
  --   req_inter[3] = 1'b0;
  --   req_inter[2] = (reg_iter[3] | req[3]) = (0 | req[3])              
  --   req_inter[1] = (reg_iter[2] | req[2]) = (reg[3] | req[2])         
  --   req_inter[0] = (reg_iter[1] | req[1]) = (reg[3] | req[2] | req[1])
  */

  assign request               = read_request | write_request;
  assign request_int[3]        = 1'b0;
  assign request_int[`N-2 : 0] = request_int[`N-1 : 1] | request[`N-1 : 1];
  assign read_enable           = | read_request; 
  assign write_enable          = | write_request; 
  assign grant_int             = ~request_int & request;
  assign memory_sel            = memsel; //~skip_wait & memsel;

  always @ (posedge clk) begin
    if (rst) begin
      state  <= IDLE;
      grant  <= 4'b0;
      memsel <= 1'b0;
      rwbar  <= 1'b0;
      ready  <= 1'b0;
      mem_cnt <= 4'd0;
    end
    else begin
      case (state)
        IDLE  :
        begin
          if (read_enable || write_enable) begin
            state  <= GRANT;
            grant  <= grant_int; 
            rwbar  <= read_enable;
            ready  <= skip_wait;
            // priority load
            casex (grant_int)
              4'b1xxx: wait_cnt <= read_enable ? read_wait_p3 : write_wait_p3;
              4'b01xx: wait_cnt <= read_enable ? read_wait_p2 : write_wait_p2;
              4'b001x: wait_cnt <= read_enable ? read_wait_p1 : write_wait_p1;
              4'b0001: wait_cnt <= read_enable ? read_wait_p0 : write_wait_p0;
              default: begin
                $display("Error: check grant signals");
                $stop;
              end
            endcase
          end
          else begin
            grant  <= 4'b0; 
            //memsel <= 1'b0;
            rwbar  <= 1'b0;
          end
        end

        GRANT : 
        begin
          if (wait_cnt == 4'd0 || skip_wait) begin
            state    <= MEMORY; 
            ready    <= 1'b1;
            mem_cnt  <= rwbar ? `BURST_COUNT : `BURST_COUNT - 1; // sim
            memsel   <= ~skip_wait; 
          end
          else begin
            wait_cnt <= wait_cnt - 4'd1;
          end
        end

        MEMORY:
        begin
          if (mem_cnt == 4'd0) begin
            state   <= IDLE;
            ready   <= 1'b0;
            memsel  <= 1'b0;
          end
          else begin
            memsel  <= ~skip_wait;
            mem_cnt <= mem_cnt - 1;
          end
        end
        default:;
      endcase
    end
  end

endmodule 

