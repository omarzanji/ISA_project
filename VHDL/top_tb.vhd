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
      RST         : in std_logic;
      Ram_Addr    : inout std_logic_vector(M_ram-1 downto 0);
      Ram_Datain  : inout std_logic_vector(N-1 downto 0);
      Ram_Dataout : inout std_logic_vector(N-1 downto 0);
      Instruction : in    std_logic_vector(N-1 downto 0));
  end component;

  signal clk_tb         :  std_logic := '1';
  signal RST_tb         :  std_logic := '1';
  signal Ram_Addr_tb    :  std_logic_vector(9 downto 0);
  signal Ram_Datain_tb  :  std_logic_vector(15 downto 0);
  signal Ram_Dataout_tb :  std_logic_vector(15 downto 0);
  signal Instruction_tb :  std_logic_vector(15 downto 0) := (others => '0');

  -- First Three Lines of Code to Test:
  -- LDR (0111): x2, 19
  signal code1 : std_logic_vector (15 downto 0) := "0001100100100111";
  -- LDR (0111): x3, 1
  signal code2 : std_logic_vector (15 downto 0) := "0000000100110111";
  -- ADD (0000): x4, x2, x3 ; 19+1 = 1a stored in x4
  signal code3 : std_logic_vector (15 downto 0) := "0011001001000001";
  -- SUB (0010): x5, x4, x3 ; 1a-1 = 19 stored in x5
  signal code4 : std_logic_vector (15 downto 0) := "0011010001010010";
  -- BLE (0011): x3,x2,label ; if 1 < 19 then branch label (here label = 0x4)
  signal code5 : std_logic_vector (15 downto 0) := "0010001101000011";
  -- JAL (0111): x1,label ; store PC into x1 and jump to label (here label = 0x8)
  signal code6 : std_logic_vector (15 downto 0) := "0000100000011110";
  -- JALR (1111): x0,0(x1) ; store PC into x1 and jump to label (here label = 0x8)
  signal code7 : std_logic_vector (15 downto 0) := "0000000100001111";
  -- Done

begin

  UUT : top
  generic map (N=>16, M_ram=>10, M_reg=>4, M_instruct=>10)
  port map (clk=>clk_tb, RST=>RST_tb, Ram_Addr=>Ram_Addr_tb,
            Ram_Datain=>Ram_Datain_tb, Ram_Dataout=>Ram_Dataout_tb,
            Instruction=>Instruction_tb);



  TEST : process
  begin
      for I in 1 to 9 loop
        wait for 100 ns;
        clk_tb <= not clk_tb;  -- Zero
        RST_tb <= '0';
        wait for 100 ns;
        clk_tb <= not clk_tb; -- One
        if Instruction_tb = "0000000000000000" then
          Instruction_tb <= code1;
        elsif Instruction_tb = code1 then
          Instruction_tb <= code2;
        elsif Instruction_tb = code2 then
          Instruction_tb <= code3;
        elsif Instruction_tb = code3 then
          Instruction_tb <= code4;
        elsif Instruction_tb = code4 then
          Instruction_tb <= code5; 
        elsif Instruction_tb = code5 then
          Instruction_tb <= code6;
        elsif Instruction_tb = code6 then
          Instruction_tb <= code7;
        end if;
        wait for 100 ns;
      end loop;
  end process;
end Behavioral;
