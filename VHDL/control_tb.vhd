library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity control_tb is
end control_tb;

architecture Behavioral of control_tb is

  signal opcode_tb     : std_logic_vector (3 downto 0) := "0000";
  signal RST_tb        : std_logic := '0';
  signal Load_tb       : std_logic := '0';
  signal Store_tb      : std_logic := '0';
  signal Jump_tb       : std_logic := '0';
  signal Mem_to_Reg_tb : std_logic := '0';
  signal IMM_to_Reg_tb : std_logic := '0';
  signal IMM_mode_tb   : std_logic := '0';
  signal Ble_tb        : std_logic := '0';
  signal Beq_tb        : std_logic := '0';
  signal Bne_tb        : std_logic := '0';
  signal Blt_tb        : std_logic := '0';
  signal ALUop_tb      : std_logic_vector (3 downto 0) := "0000";
  signal BranchOP_tb   : std_logic_vector (1 downto 0) := "00";

  component control is
    Port (
      opcode     : in std_logic_vector (3 downto 0);
      RST        : in std_logic;
      Load       : out std_logic;
      Store      : out std_logic;
      Jump       : out std_logic;
      Mem_to_Reg : out std_logic;
      IMM_to_Reg : out std_logic;
      IMM_mode   : out std_logic;
      Ble        : out std_logic;
      Beq        : out std_logic;
      Bne        : out std_logic;
      Blt        : out std_logic;
      ALUop      : out std_logic_vector (3 downto 0);
      BranchOP   : out std_logic_vector (1 downto 0));
  end component;

begin

  UUT : control
  port map (opcode => opcode_tb, RST => RST_tb, Load => Load_tb,
            Store => Store_tb, Jump => Jump_tb, Mem_to_Reg => Mem_to_Reg_tb,
            IMM_to_Reg => IMM_to_Reg_tb, IMM_mode => IMM_mode_tb,
            Ble => Ble_tb, Beq => Beq_tb, Bne => Bne_tb,
            Blt => Blt_tb, ALUop => ALUop_tb, BranchOP => BranchOP_tb);

  TEST : process
    begin
    RST_tb <= '1';
    wait for 100 ns;
    RST_tb <= '0';
    wait for 100 ns;
    OP_LOOP : for I in 0 to (2**4)-1 loop
      opcode_tb <= std_logic_vector(to_unsigned(I,4));
      wait for 100 ns;
    end loop OP_LOOP;
  end process;

end Behavioral;
