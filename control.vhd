library ieee;
use ieee.std_logic_1164.all;

entity control is
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
end control;

architecture Behavioral of control is

  signal opcode_tmp     : std_logic_vector (3 downto 0) := "0000";
  signal Load_tmp       : std_logic := '0';
  signal Store_tmp      : std_logic := '0';
  signal Jump_tmp       : std_logic := '0';
  signal Mem_to_Reg_tmp : std_logic := '0';
  signal IMM_to_Reg_tmp : std_logic := '0';
  signal IMM_mode_tmp   : std_logic := '0';
  signal Ble_tmp        : std_logic := '0';
  signal Beq_tmp        : std_logic := '0';
  signal Bne_tmp        : std_logic := '0';
  signal Blt_tmp        : std_logic := '0';
  signal ALUop_tmp      : std_logic_vector (3 downto 0) := "0000";
  signal BranchOP_tmp   : std_logic_vector (1 downto 0) := "00";

begin

  process(RST, opcode)
    begin
    if RST = '0' then
      opcode_tmp <= opcode;
    else
      opcode_tmp <= "0001";
    end if;
  end process;
  
  process(opcode_tmp)
    begin
    case (opcode_tmp) is
      when "0000" =>  -- ADD
        Load_tmp  <= '1';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '0';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0000";
        BranchOP_tmp      <= "00";
      when "0010" =>  -- SUB
        Load_tmp  <= '1';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '0';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0001";
        BranchOP_tmp      <= "00";
      when "1100" =>  -- AND
        Load_tmp  <= '1';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '0';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0010";
        BranchOP_tmp      <= "00";
      when "1101" =>  -- OR
        Load_tmp  <= '1';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '0';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0011";
        BranchOP_tmp      <= "00";
      when "0011" =>  -- BLE
        Load_tmp  <= '0';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '0';
        Ble_tmp        <= '1';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0001";
        BranchOP_tmp      <= "00";
      when "0100" =>  -- BEQ
        Load_tmp  <= '0';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '0';
        Ble_tmp        <= '0';
        Beq_tmp        <= '1';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0001";
        BranchOP_tmp      <= "01";
      when "0101" =>  -- BNE
        Load_tmp  <= '1';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '0';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '1';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0001";
        BranchOP_tmp      <= "10";
      when "0110" =>  -- BLT
        Load_tmp  <= '0';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '0';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '1';
        ALUop_tmp      <= "0001";
        BranchOP_tmp      <= "11";
      when "0111" =>  -- LDR
        Load_tmp  <= '1';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '1';
        IMM_mode_tmp   <= '0';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0000";
        BranchOP_tmp      <= "00";
      when "1110" =>  -- JAL
        Load_tmp  <= '1';
        Store_tmp <= '0';
        Jump_tmp  <= '1';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '0';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0000";
        BranchOP_tmp      <= "00";
      when "1000" =>  -- LDM
        Load_tmp  <= '1';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '1';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '0';
        Ble_tmp        <= '1';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0000";
        BranchOP_tmp      <= "00";
      when "1001" =>  -- STM
        Load_tmp  <= '0';
        Store_tmp <= '1';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp      <= '1';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0000";
        BranchOP_tmp      <= "00";
      when "1010" =>  -- SL
        Load_tmp  <= '1';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '1';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0000";
        BranchOP_tmp      <= "00";
      when "1011" =>  -- SR
        Load_tmp  <= '1';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '1';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0000";
        BranchOP_tmp      <= "00";
      when "1111" =>  -- JALR
        Load_tmp  <= '1';
        Store_tmp <= '0';
        Jump_tmp  <= '1';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '1';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0000";
        BranchOP_tmp      <= "00";
      when others =>
        Load_tmp  <= '0';
        Store_tmp <= '0';
        Jump_tmp  <= '0';
        Mem_to_Reg_tmp <= '0';
        IMM_to_Reg_tmp <= '0';
        IMM_mode_tmp   <= '0';
        Ble_tmp        <= '0';
        Beq_tmp        <= '0';
        Bne_tmp        <= '0';
        Blt_tmp        <= '0';
        ALUop_tmp      <= "0000";
        BranchOP_tmp      <= "00";
    end case;
  end process;

  Load <= Load_tmp;
  Store <= Store_tmp;
  Jump <= Jump_tmp;
  Mem_to_Reg <= Mem_to_Reg_tmp;
  IMM_to_Reg <= IMM_to_Reg_tmp;
  IMM_mode <= IMM_mode_tmp;
  Ble <= Ble_tmp;
  Beq <= Beq_tmp;
  Bne <= Bne_tmp;
  Blt <= Blt_tmp;
  ALUop <= ALUop_tmp;
  BranchOP <= BranchOP_tmp;

end Behavioral;
