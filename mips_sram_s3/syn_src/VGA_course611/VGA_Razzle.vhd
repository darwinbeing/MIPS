------------------------------------------------------------------------
-- VGA Top-level modules
--
-- jinz@email.sc.edu
------------------------------------------------------------------------
library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity VGA is
  port ( 
    CLOCK_27  : in std_logic;
    SW        : in std_logic_vector (17 downto 0);
    KEY       : in std_logic_vector (3 downto 0);

   -- ALTERA DE2 VGA Side
   VGA_R      : out std_logic_vector (9 downto 0);
   VGA_G      : out std_logic_vector (9 downto 0);
   VGA_B      : out std_logic_vector (9 downto 0);
   VGA_CLK    : out std_logic; 
   VGA_HS     : out std_logic;
   VGA_VS     : out std_logic;
   VGA_SYNC   : out std_logic; 
   VGA_BLANK  : out std_logic);
end;

architecture struct of VGA is

  signal VGA_PLL_RST    : std_logic;
  signal VGA_Sync_RST_N : std_logic;
  signal video_on       : std_logic;
  signal mVGA_R         : std_logic_vector (9 downto 0);
  signal mVGA_G         : std_logic_vector (9 downto 0);
  signal mVGA_B         : std_logic_vector (9 downto 0);
  signal mCoord_X       : std_logic_vector (9 downto 0); 
  signal mCoord_Y       : std_logic_vector (9 downto 0);
  signal VGA_VSYNC      : std_logic;  
  signal VGA_HSYNC      : std_logic;
  signal VGA_CTRL_CLK   : std_logic;
  signal CPU_CLK        : std_logic;
  --signal dither         : std_logic_vector (9 downto 0);
  
  component VGA_PLL is
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
		c2		: OUT STD_LOGIC 
	);
  end component VGA_PLL; 
  
  component Razzle_Display is
    port (
     iCLK        : in std_logic;       
     pixel_count : in std_logic_vector (9 downto 0);
     line_count  : in std_logic_vector (9 downto 0);
     VGA_VSYNC   : in std_logic;
     video_on    : in std_logic; 
     dither      : in std_logic_vector(9 downto 0);

     Red         : out std_logic_vector (9 downto 0);
     Green       : out std_logic_vector (9 downto 0);
     Blue        : out std_logic_vector (9 downto 0)
   );
  end component Razzle_Display; 

  component VGA_IF is
    port (
     iCLK       : in std_logic;
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
  end component VGA_IF; 

begin
  VGA_VS         <= VGA_VSYNC;
  VGA_HS         <= VGA_HSYNC;  
  VGA_PLL_RST    <= not SW(0);
  VGA_Sync_RST_N <= SW(0);

  u1 : Razzle_Display port map
  ( 
    iCLK        => CPU_CLK,
    pixel_count => mCoord_X, 
    line_count  => mCoord_Y, 
    VGA_VSYNC   => VGA_VSYNC,
    dither      => dither,
    --stop        => stop,
    video_on    => video_on,
    Red         => mVGA_R,
    Green       => mVGA_G,
    Blue        => mVGA_B
  );

  u2 : VGA_PLL port map	
  (
    areset      => VGA_PLL_RST,
    inclk0      => CLOCK_27,
    c0          => VGA_CTRL_CLK,
    c1          => CPU_CLK,
    c2          => VGA_CLK
  );

  u3 : VGA_IF port map 
  (
    iCLK       => VGA_CTRL_CLK,
    iRST_N     => VGA_Sync_RST_N,
    iRed       => mVGA_R,
    iGreen     => mVGA_G,
    iBlue      => mVGA_B,

    px         => mCoord_X,
    py         => mCoord_Y,
    video_on   => video_on,

    VGA_R      => VGA_R,
    VGA_G      => VGA_G,
    VGA_B      => VGA_B,
    VGA_HSYNC  => VGA_HSYNC,
    VGA_VSYNC  => VGA_VSYNC,
    VGA_SYNC   => VGA_SYNC,
    VGA_BLANK  => VGA_BLANK
  );

end architecture struct;
