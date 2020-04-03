library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity register_file_tb is
    generic (
        N : integer := 16;
        M : integer := 5);
end register_file_tb;

architecture Behavioral of register_file_tb is
    
    signal clk_tb        : std_logic;
    signal Rs1_Addr_tb  : std_logic_vector (M-1 downto 0) := (others => '0');  -- Rs1
    signal Rs2_Addr_tb  : std_logic_vector (M-1 downto 0) := (others => '0');  -- Rs2
    signal Rd_Addr_tb   : std_logic_vector (M-1 downto 0) := (others => '0');  -- Rd
    signal Din_tb       : std_logic_vector (N-1 downto 0);  -- Din
    signal WE_tb        : std_logic := '0';  -- Write Enable, behaves as CLK for the model.
    signal RST_tb          : std_logic := '0';  -- Write Enable, behaves as CLK for the model.
    signal Rs1_out_tb  : std_logic_vector (N-1 downto 0) := (others => '0');  -- Rs1
    signal Rs2_out_tb  : std_logic_vector (N-1 downto 0) := (others => '0');  -- Rs1

    component register_file is
      generic (
        N : integer := 16;  -- N-bits size of word.
        M : integer := 5); -- Size of RAM block. 2^M registers of N bits each.
      Port (
        clk       : in std_logic;
        Rs1_Addr  : in std_logic_vector (M-1 downto 0);  -- Read address.
        Rs2_Addr  : in std_logic_vector (M-1 downto 0);  -- Read address.
        Rd_Addr   : in std_logic_vector (M-1 downto 0);
        Din : in std_logic_vector (N-1 downto 0);  -- Data to store.
        WE  : in std_logic := '0';  -- Write Enable, behaves as CLK for the model.
        RST : in std_logic;
        Rs1_out : out std_logic_vector (N-1 downto 0);
        Rs2_out : out std_logic_vector (N-1 downto 0));  -- Output from Read Address.
    end component;

    begin

    REG_FILE : register_file
    generic map (N => N, M => M)
    port map ( clk=>clk_tb,Rs1_Addr => Rs1_Addr_tb, Rs2_Addr => Rs2_Addr_tb,
      Rd_Addr => Rd_Addr_tb, Din => Din_tb, WE => WE_tb,
      RST => RST_tb, Rs1_out => Rs1_out_tb, Rs2_out => Rs2_out_tb);

    Din_tb <= "1001111110011111";

testProc : process
    begin
    RST_tb <= '1';
    wait for 100 ns;
    RST_tb <= '0';
    wait for 100 ns;
    Rd_Addr_tb <= "00000";
    Rs1_Addr_tb <= "00000";
    Rs2_Addr_tb <= "00001";
    WE_tb <= '1';
    wait for 100 ns;
    WE_tb <= '0';
    Rd_Addr_tb <= "00001";
    wait for 100 ns;
    WE_tb <= '1';
    wait for 100 ns;
    WE_tb <= '0';
    wait for 1000 ns;
    end process;

end Behavioral;
