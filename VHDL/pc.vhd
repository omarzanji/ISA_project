-- PC
-- Author: Omar Barazanji
-- Date: March 2020

library ieee;
use ieee.std_logic_1164.all;

entity pc is
  port (
    RST  : in std_logic;
    Din  : in std_logic_vector (15 downto 0);
    Dout : out std_logic_vector (15 downto 0));
end pc;

architecture Behavioral of pc is

  signal PC_val : std_logic_vector(15 downto 0);

begin

    process(Din, RST)
    begin
      if RST='1' then
        PC_val <= (others => '0');
      else
        PC_val <= Din;
      end if;
    end process;

    Dout <= PC_val;

end Behavioral;
