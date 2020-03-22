library ieee;
use ieee.std_logic_1164.all;

entity mux41_tb is
end mux41_tb;

architecture Behavioral of mux41_tb is

  component mux41 is
    port (
      sel : in std_logic_vector (1 downto 0);
      a : in std_logic_vector (15 downto 0);
      b : in std_logic_vector (15 downto 0);
      c : in std_logic_vector (15 downto 0);
      d : in std_logic_vector (15 downto 0);
      e : out std_logic_vector (15 downto 0));
  end component;

    signal sel_tb : std_logic_vector(1 downto 0);
    signal a_tb : std_logic_vector(15 downto 0) := "0000000000001010";
    signal b_tb : std_logic_vector(15 downto 0) := "0000000000001011";
    signal c_tb : std_logic_vector(15 downto 0) := "0000000000001100";
    signal d_tb : std_logic_vector(15 downto 0) := "0000000000001101";
    signal e_tb : std_logic_vector(15 downto 0) := (others => '0');

begin

    UUT : mux41 port map (
        sel=>sel_tb, a=>a_tb, b=>b_tb, c=>c_tb, d=>d_tb, e=>e_tb);

    mux_test : process
    begin
        sel_tb <= "00";
        wait for 100 ns;
        sel_tb <= "01";
        wait for 100 ns;
        sel_tb <= "10";
        wait for 100 ns;
        sel_tb <= "11";
        wait for 100 ns;
    end process;

end Behavioral;
