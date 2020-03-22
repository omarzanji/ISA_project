library ieee;
use ieee.std_logic_1164.all;

entity mux21_tb is
end mux21_tb;

architecture Behavioral of mux21_tb is

    component mux21 is
      port (
        sel : in std_logic;
        a : in std_logic_vector (15 downto 0);
        b : in std_logic_vector (15 downto 0);
        c : out std_logic_vector (15 downto 0));
    end component;

    signal sel_tb : std_logic;
    signal a_tb : std_logic_vector(15 downto 0) := "0000000000001010";
    signal b_tb : std_logic_vector(15 downto 0) := "0000000000001011";

begin

    UUT : mux21 port map (
        sel=>sel_tb, a=>a_tb, b=>b_tb);

    mux_test : process
    begin
        sel_tb <= '0';
        wait for 100 ns;
        sel_tb <= '1';
        wait for 100 ns;
    end process;

end Behavioral;
