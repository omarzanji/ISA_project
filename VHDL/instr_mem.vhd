library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity instr_mem is
  generic (
    N : integer := 16;  -- N-bits size of word.
    M : integer := 10); -- Size of RAM block. 2^M registers of N bits each.
  Port (
    clk       : in std_logic;
    Rs1_Addr  : in std_logic_vector (M-1 downto 0);  -- Read address.
    RST : in std_logic;
    Rs1_out : out std_logic_vector (N-1 downto 0));
end instr_mem;

architecture Behavioral of instr_mem is
  subtype WORD is std_logic_vector (N-1 downto 0);
  type MEMORY is array (0 to 2**M-1) of WORD;
  signal RAM_BLOCK : MEMORY;
  signal STARTUP: boolean := true;
  begin

      process(RST, clk, Rs1_Addr)
        variable RAM_ADDR_IN1: integer range 0 to 2**M-1;  -- RS1
        variable RAM_ADDR_IN3: integer range 0 to 2**M-1;  -- RD
          begin
              if RST = '1' then
                STARTUP <= true;
              end if;
              if clk='1' then
                  if (STARTUP = true) then
                    RAM_BLOCK <= (others => "0000000000000000");
                    RAM_BLOCK(0) <= "0001100100100111";
                    RAM_BLOCK(1) <= "0000000100110111";
                    RAM_BLOCK(2) <= "0011001001000001";
--                    RAM_BLOCK(3) <= "0001010100011110";  -- jump
                    RAM_BLOCK(3) <= "0000010000011001"; --store result "1a" in data mem.
                    RAM_BLOCK(4) <= "0000010101011000";  --  load x3 mem
--                    RAM_BLOCK(3) <= "0010001101100011";  -- branch 
                    RAM_BLOCK(5) <= "0001100100100111";  -- same as block 0
                    STARTUP <= false;
                  else
                    RAM_ADDR_IN1 := conv_integer(Rs1_Addr);
                 end if;
              end if;
              Rs1_out <= RAM_BLOCK(RAM_ADDR_IN1);
      end process;


end Behavioral;
