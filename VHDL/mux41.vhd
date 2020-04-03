-- 4 to 1 MUX
-- Author: Omar Barazanji
-- Date: March 2020

library ieee;
use ieee.std_logic_1164.all;

entity mux41 is
  port (
    sel : in std_logic_vector (1 downto 0);
    a : in std_logic;
    b : in std_logic;
    c : in std_logic;
    d : in std_logic;
    e : out std_logic);
end mux41;

architecture Behavioral of mux41 is
begin
  process(sel, a, b, c, d)
    begin
    if sel="00" then
      e <= a;
    elsif sel="01" then
      e <= b;
    elsif sel = "10" then
      e <= c;
    else e <= d;
    end if;
  end process;
end Behavioral;
