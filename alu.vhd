library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu is
  generic (
    N : integer := 16);  -- N-bits size of word.
  Port (
    ALUop     : in std_logic_vector (3 downto 0);  -- ALU operation.
    Op1       : in signed (N-1 downto 0);  -- Op1.
    Op2       : in signed (N-1 downto 0);  -- Op2.
    RST       : in std_logic;
    Dout      : out signed (N-1 downto 0);  -- Dout.
    Zero      : out std_logic;  -- Zero flag
    Negative  : out std_logic);  -- Negative flag.
end alu;

architecture Behavioral of alu is

  signal Dout_signal : signed (N-1 downto 0);
  signal Negative_signal : std_logic;
  signal Zero_signal : std_logic;
  signal temp        : std_logic;

begin

  process(ALUop, Op1, Op2)
    begin
    case(ALUop) is
      when "0000" =>  -- Add
        Dout_signal <= Op1 + Op2;
      when "0001" =>  -- Sub
        Dout_signal <= Op1 - Op2;
      when "0010" =>  -- AND
        Dout_signal <= op1 and op2;
      when "0011" =>  -- OR
        Dout_signal <= op1 or op2;
      when "0100" =>  -- Shift Left Logical
        Dout_signal <= op1 sll 1;
      when "0101" =>  -- Shift Rigt Logical
        Dout_signal <= op1 srl 1;
      when others => Dout_signal <= Op1 + Op2;
    end case;
  end process;

  process(Dout_signal)
    begin
    if (Dout_signal = 0) then
      Zero_signal <= '1';
      Negative_signal <= '0';
    elsif (Dout_signal < 0) then
      Zero_signal <= '0';
      Negative_signal <= '1';
    elsif (Dout_signal > 0) then
      Zero_signal <= '0';
      Negative_signal <= '0';
    end if;
  end process;

  Dout <= Dout_signal;
  Zero <= Zero_signal;
  Negative <= Negative_signal;

end Behavioral;
