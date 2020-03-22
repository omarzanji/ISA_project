library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity register_file is
  generic (
    N : integer := 16;  -- N-bits size of word.
    M : integer := 5); -- Size of RAM block. 2^M registers of N bits each.
  Port (
    Rs1_Addr  : in std_logic_vector (M-1 downto 0);  -- Read address.
    Rs2_Addr  : in std_logic_vector (M-1 downto 0);  -- Read address.
    Rd_Addr   : in std_logic_vector (M-1 downto 0);
    Din : in std_logic_vector (N-1 downto 0);  -- Data to store.
    WE  : in std_logic;  -- Write Enable, behaves as CLK for the model.
    RST : in std_logic;
    Rs1_out : out std_logic_vector (N-1 downto 0);
    Rs2_out : out std_logic_vector (N-1 downto 0));  -- Output from Read Address.
end register_file;

architecture Behavioral of register_file is
  subtype WORD is std_logic_vector (N-1 downto 0);
  type MEMORY is array (0 to 2**M-1) of WORD;
  signal RAM_BLOCK : MEMORY;
  signal STARTUP: boolean := true;
  begin

      process(RST, Rs1_Addr, Rs2_Addr, Rd_Addr, Din, WE)
        variable RAM_ADDR_IN1: integer range 0 to 2**M-1;  -- RS1
        variable RAM_ADDR_IN2: integer range 0 to 2**M-1;  -- RS2
        variable RAM_ADDR_IN3: integer range 0 to 2**M-1;  -- RD
          begin
              if RST = '1' then
                STARTUP <= true;
              end if;
              if (STARTUP = true) then
                RAM_BLOCK <= (others => "0000000000000000");
                Rs1_out <= "XXXXXXXXXXXXXXXX";
                Rs2_out <= "XXXXXXXXXXXXXXXX";
                STARTUP <= false;
              else
                RAM_ADDR_IN1 := conv_integer(Rs1_Addr);
                RAM_ADDR_IN2 := conv_integer(Rs2_Addr);
                RAM_ADDR_IN3 := conv_integer(Rd_Addr);
                if (WE='1') then
                  RAM_BLOCK(RAM_ADDR_IN3) <= Din;
                end if;
                Rs1_out <= RAM_BLOCK(RAM_ADDR_IN1);
                Rs2_out <= RAM_BLOCK(RAM_ADDR_IN2);
             end if;
          end process;

end Behavioral;
