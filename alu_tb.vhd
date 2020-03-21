library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu_tb is
  generic (
    N_tb : integer := 16);
end alu_tb;

architecture Behavioral of alu_tb is

  signal ALUop_tb     :  std_logic_vector (3 downto 0);  -- ALU operation.
  signal Op1_tb       :  signed (N_tb-1 downto 0);  -- Op1.
  signal Op2_tb       :  signed (N_tb-1 downto 0);  -- Op2.
  signal Dout_tb      :  signed (N_tb-1 downto 0);  -- Dout.
  signal Zero_tb      :  std_logic := '0';  -- Zero flag
  signal Negative_tb  :  std_logic := '0';  -- Negative flag.

component alu is
  generic (
    N : integer := 16);  -- N-bits size of word.
  Port (
    ALUop     : in std_logic_vector (3 downto 0);  -- ALU operation.
    Op1       : in signed (N-1 downto 0);  -- Op1.
    Op2       : in signed (N-1 downto 0);  -- Op2.
    Dout      : out signed (N-1 downto 0);  -- Dout.
    Zero      : out std_logic;  -- Zero flag
    Negative  : out std_logic);  -- Negative flag.
end component;

begin

  UUT : alu
  generic map (N => N_tb)
  port map (ALUop => ALUop_tb, Op1 => Op1_tb,
    Op2 => Op2_tb, Dout => Dout_tb,
    Zero => Zero_tb, Negative => Negative_tb);

  TEST : process
    begin
      CASE_TEST : for I in 0 to 5 loop
        wait for 100 ns;
        case (I) is
            when 0 =>  -- Add
              ALUop_tb <= "0000";
              Op1_tb <= "0000000011110000";
              Op2_tb <= "0000000000001111";
              wait for 100 ns;
            when 1 =>  -- Sub
              ALUop_tb <= "0001";
              Op1_tb <= "0000000011110000";
              Op2_tb <= "0000000011110000";  -- Zero FLag High
              wait for 100 ns;
              Op1_tb <= "0000000000000000";
              op2_tb <= "0000000000000001";  -- Negative Flag High
              wait for 100 ns;
            when 2 =>  -- AND
              ALUop_tb <= "0010";
              Op1_tb <= "0000000011111111";
              Op2_tb <= "1111111100000000";  -- Zero Flag High
              wait for 100 ns;
            when 3 =>  -- OR
              ALUop_tb <= "0011";
              Op1_tb <= "0000000011111111";
              Op2_tb <= "1111111100000000";
              wait for 100 ns;
            when 4 =>  -- Shift Left Logical
              ALUop_tb <= "0100";
              Op1_tb <= "0000000011111111";
              wait for 100 ns;
            when 5 =>  -- Shift Right Logical
              ALUop_tb <= "0101";
              Op1_tb <= "0000000011111110";
              wait for 100 ns;
        end case;
      end loop CASE_TEST;
  end process;


end Behavioral;
