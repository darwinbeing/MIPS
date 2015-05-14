------------------------------------------------------------------------
-- Generate pixel coordinates and VGA color signals
--
-- Convert a reference design in Verilog to VHDL
-- jinz@email.sc.edu
------------------------------------------------------------------------
library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity VGA_IF is
  port (
    iCLK      : in std_logic;
   iRST_N     : in std_logic;
   iRed       : in std_logic_vector (9 downto 0);
   iGreen     : in std_logic_vector (9 downto 0);
   iBlue      : in std_logic_vector (9 downto 0);

   -- pixel coordinates
   px         : out std_logic_vector (9 downto 0); 
   py         : out std_logic_vector (9 downto 0);
   video_on   : out std_logic;

   -- VGA Side
   VGA_R      : out std_logic_vector (9 downto 0);
   VGA_G      : out std_logic_vector (9 downto 0);
   VGA_B      : out std_logic_vector (9 downto 0);

   VGA_HSYNC  : out std_logic;
   VGA_VSYNC  : out std_logic;
   VGA_SYNC   : out std_logic; 
   VGA_BLANK  : out std_logic);
end;

architecture beh of VGA_IF is
  signal h_count, v_count : std_logic_vector (9 downto 0);
  signal frame_on, video_h_on, video_v_on : std_logic;
  signal VGA_H_SYNC     : std_logic;
  signal VGA_V_SYNC     : std_logic;
  
   -- Horizontal sync
  -- Generate Horizontal and Vertical Timing Signals for Video Signal
  -- H_count counts pixels (640 + extra time for sync signals)
  --
  --   <-Clock out RGB Pixel Row Data ->   <-H Sync->
  --   ------------------------------------__________--------
  --   0                           640   659       755    799
  --
  constant H_SYNC_TOTAL : integer := 800;
  constant H_PIXELS     : integer := 640;
  constant H_SYNC_START : integer := 659;
  constant H_SYNC_WIDTH : integer := 96;
  
  -- Vertical sync
  -- V_count counts rows of pixels (480 + extra time for sync signals)
  --
  --  <---- 480 Horizontal Syncs (pixel rows) -->  ->V Sync<-
  --  -----------------------------------------------_______------------
  --  0                                       480    493-494          524
  --
  constant V_SYNC_TOTAL : integer := 525;
  constant V_PIXELS     : integer := 480;
  constant V_SYNC_START : integer := 493;
  constant V_SYNC_WIDTH : integer :=   2;
  constant H_START      : integer := 699;

begin
  VGA_BLANK	<= VGA_H_SYNC and VGA_V_SYNC;
  VGA_SYNC	<= '0';  
  VGA_HSYNC <= VGA_H_SYNC;
  VGA_VSYNC <= VGA_V_SYNC;
  px        <= h_count;
  py        <= v_count;
  frame_on  <= video_h_on and video_v_on;
  video_on  <= frame_on;
  VGA_R     <= iRed   when frame_on = '1' else B"0000000000";
  VGA_G     <= iGreen when frame_on = '1' else B"0000000000"; 
  VGA_B     <= iBlue  when frame_on = '1' else B"0000000000"; 

  process (iCLK, iRST_N) begin
    if (iRST_N = '0') then
      h_count    <= B"0000000000";
      v_count    <= B"0000000000";
      VGA_H_SYNC <= '0';
      VGA_V_SYNC <= '0';
    elsif (iCLK'event and iCLK = '1') then
      -- H_Sync Counter
      if (h_count < H_SYNC_TOTAL-1) then
        h_count <= h_count + 1;
      else 
        h_count <= B"0000000000";
      end if;

      if (h_count >= H_SYNC_START) and (h_count < H_SYNC_START + H_SYNC_WIDTH) then
        VGA_H_SYNC <= '0';
      else
        VGA_H_SYNC <= '1';
      end if;

      if (h_count = H_START) then
          -- V_Sync Counter
        if (v_count < V_SYNC_TOTAL-1) then
          v_count <= v_count + 1;
        else 
          v_count <= B"0000000000";
        end if;

        if (h_count >= H_SYNC_START) and (h_count < H_SYNC_START + H_SYNC_WIDTH) then
          VGA_H_SYNC <= '0';

          if (v_count >= V_SYNC_START) and (v_count < V_SYNC_START+V_SYNC_WIDTH) then
            VGA_V_SYNC <= '0';
          else
            VGA_V_SYNC <= '1';
          end if;
        end if;
      end if;

      if (h_count < H_PIXELS) then
        video_h_on <= '1';
      else
        video_h_on <= '0';
      end if;

      if (v_count < V_PIXELS) then
        video_v_on <= '1';
      else
        video_v_on <= '0';
      end if;
    end if;
  end process;

end architecture beh;
