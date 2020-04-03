-- 2 to 1 MUX
-- Author: Omar Barazanji
-- Date: March 2020

library ieee;
use ieee.std_logic_1164.all;

entity mux21 is
  port (
    sel : in std_logic;
    a : in std_logic_vector (15 downto 0);
    b : in std_logic_vector (15 downto 0);
    c : out std_logic_vector (15 downto 0));
end mux21;

architecture Behavioral of mux21 is
begin

    c <= a when (sel='0') else b;

end Behavioral;
