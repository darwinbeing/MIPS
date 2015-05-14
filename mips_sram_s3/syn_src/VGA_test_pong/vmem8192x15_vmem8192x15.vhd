--
-- VHDL Architecture CPU.vmem8192x15.vmem8192x15
--
-- Created:
--          by - jinz.student (quark)
--          at - 16:50:37 11/04/10
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY vmem8192x15 IS
   PORT( 
      clka  : IN     std_logic;
      clkb  : IN     std_logic;
      addra : IN     std_logic_vector ( 12 DOWNTO 0 );
      dataa : OUT    std_logic_vector ( 14 DOWNTO 0 );
      addrb : IN     std_logic_vector ( 12 DOWNTO 0 );
      datab : IN     std_logic_vector ( 14 DOWNTO 0 );
      web   : IN     std_logic
   );

-- Declarations

END vmem8192x15 ;

--
ARCHITECTURE vmem8192x15 OF vmem8192x15 IS
  type MEM is array(0 to 8191) of std_logic_vector(14 downto 0);
  signal ram_block : MEM;
BEGIN
  process (clka)
  begin
    if (clka'event and clka='1') then
      dataa <= ram_block(conv_integer(addra));
    end if;
  end process;
    
  process (clkb)
  begin
    if (clkb'event and clkb='1') then
      if (web = '1') then
        ram_block(conv_integer(addrb)) <= datab;
      end if;
    end if;
  end process;
END ARCHITECTURE vmem8192x15;

