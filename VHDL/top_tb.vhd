library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture Behavioral of top_tb is

  component top is
    generic (
      N           : integer := 16;  -- N-bits size of word.
      M_ram       : integer := 10;  -- 2^M cells
      M_reg       : integer := 4;  -- 2^M cells
      M_instruct  : integer := 10); -- 2^M registers of N bits each.
    Port (
      clk         : in std_logic;
      RST         : in std_logic);
  end component;

  signal clk_tb         :  std_logic := '1';
  signal RST_tb         :  std_logic := '1';
  signal start : boolean := true;
begin

  UUT : top
  generic map (N=>16, M_ram=>10, M_reg=>4, M_instruct=>10)
  port map (clk=>clk_tb, RST=>RST_tb);

  TEST : process
  begin
    if start = true then
        wait for 100 ns;
        clk_tb <= not clk_tb;  -- Zero
        RST_tb <= '0';
        start <= false;
    end if;
    wait for 100 ns;
    clk_tb <= not clk_tb; -- One / zero alternate
  end process;
end Behavioral;
