library ieee;
use ieee.std_logic_1164.all;

entity arbitrator is
  generic (clock_period : time := 20 ns);
  port (read_request  : in  std_logic_vector (3 downto 0);
        write_request : in  std_logic_vector (3 downto 0);
        grant         : out std_logic_vector (3 downto 0); 
        clock         : in  std_logic;
        skip_wait     : in  std_logic;
        memsel        : out std_logic;
        rwbar         : out std_logic;
        ready         : out std_logic);
end arbitrator;

architecture beh of arbitrator is
  type natural_vector is array(natural range <>) of natural;
  signal wait_states : natural_vector(3 downto 0) := (1, 1, 1, 1); --(3, 3, 3, 3); --(2, 2, 2, 2); 
begin
  wait_cycle: process
  begin
    if clock'event and clock = '1' then
      wait for 1 ns;
      -- highest priority at msb of read_request
      for i in read_request'range loop
        if read_request(i) = '1' or write_request(i) = '1' then  
          grant    <= "0000";
          grant(i) <= '1';
          memsel   <= '1';
          rwbar    <= read_request(i);
          ready    <= '0';
          if wait_states(i) /= 0 then
            for j in 1 to wait_states(i) loop
              exit when skip_wait = '1';
              wait for clock_period;
            end loop;
          end if;
          ready    <= '1';
          exit;
        else
          grant(i) <= '0';
          memsel   <= '0';
        end if;
      end loop;
    end if;
    wait on clock;
  end process wait_cycle;
end architecture beh; 

