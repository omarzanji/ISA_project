library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity top is
  generic (
    N           : integer := 16;  -- N-bits size of word.
    M_ram       : integer := 10;  -- 2^M cells
    M_reg       : integer := 4;  -- 2^M cells
    M_instruct  : integer := 10); -- 2^M registers of N bits each.
  Port (
    clk         : in std_logic;
    RST         : in std_logic);
end top;

architecture Behavioral of top is

  signal Instruction : std_logic_vector(N-1 downto 0);

  signal ALUop_top     :  std_logic_vector (3 downto 0);  -- ALU operation.
  -- signal Op1_top       :  signed (N_tb-1 downto 0);  -- Op1.
  signal Op2_top       :  std_logic_vector (N-1 downto 0);  -- Op2.
  signal Dout_top      :  std_logic_vector (N-1 downto 0);  -- Dout.
  signal Zero_top      :  std_logic := '0';  -- Zero flag
  signal Negative_top  :  std_logic := '0';  -- Negative flag.

  signal opcode_top     : std_logic_vector (3 downto 0) := "0000";
  signal RST_top        : std_logic := '0';
  signal Load_top       : std_logic := '0';
  signal Store_top      : std_logic := '0';
  signal Store_top_mem      : std_logic_vector (0 downto 0) := "0";
  signal Jump_top       : std_logic := '0';
  signal Mem_to_Reg_top : std_logic := '0';
  signal IMM_to_Reg_top : std_logic := '0';
  signal IMM_mode_top   : std_logic := '0';
  signal Ble_top        : std_logic := '0';
  signal Beq_top        : std_logic := '0';
  signal Bne_top        : std_logic := '0';
  signal Blt_top        : std_logic := '0';
--  signal ALUop_top      : std_logic_vector (3 downto 0);
  signal BranchOP_top   : std_logic_vector (1 downto 0);

  signal Rs1_Addr_top  : std_logic_vector (M_reg-1 downto 0) := (others => '0');  -- Rs1
  signal Rs2_Addr_top  : std_logic_vector (M_reg-1 downto 0) := (others => '0');  -- Rs2
  signal Rd_Addr_top   : std_logic_vector (M_reg-1 downto 0) := (others => '0');  -- Rd
  signal Din_top       : std_logic_vector (N-1 downto 0);  -- Din
  signal WE_top        : std_logic := '0';  -- Write Enable, behaves as CLK for the model.
--  signal RST_top       : std_logic := '0';  -- Write Enable, behaves as CLK for the model.
  signal Rs1_out_top   : std_logic_vector (N-1 downto 0) := (others => '0');  -- Rs1
  signal Rs2_out_top   : std_logic_vector (N-1 downto 0) := (others => '0');  -- Rs1

--  signal sel_top_21 : std_logic;
--  signal a_top_21   : std_logic_vector (15 downto 0) := "0000000000001010";
--  signal b_top_21   : std_logic_vector (15 downto 0) := "0000000000001011";
--  signal c_top_21   : std_logic_vector (15 downto 0) := (others => '0');

--  signal sel_top_41 : std_logic_vector (1 downto 0);
--  signal a_top_41   : std_logic_vector (15 downto 0) := "0000000000001010";
--  signal b_top_41   : std_logic_vector (15 downto 0) := "0000000000001011";
--  signal c_top_41   : std_logic_vector (15 downto 0) := "0000000000001100";
--  signal d_top_41   : std_logic_vector (15 downto 0) := "0000000000001101";
--  signal e_top_41   : std_logic_vector (15 downto 0) := (others => '0');


  component pc is
    port (
      clk  : in std_logic;
      Din  : in std_logic_vector (15 downto 0);
      Dout : out std_logic_vector (15 downto 0));
  end component;

  component alu is
    generic (
      N : integer := 16);  -- N-bits size of word.
    Port (
      clk       : in std_logic;
      ALUop     : in std_logic_vector (3 downto 0);  -- ALU operation.
      Op1       : in std_logic_vector (N-1 downto 0);  -- Op1.
      Op2       : in std_logic_vector (N-1 downto 0);  -- Op2.
      Dout      : out std_logic_vector (N-1 downto 0);  -- Dout.
      Zero      : out std_logic;  -- Zero flag
      Negative  : out std_logic);  -- Negative flag.
  end component;

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

component data_mem is
  generic (
    N : integer := 16;  -- N-bits size of word.
    M : integer := 10); -- Size of RAM block. 2^M registers of N bits each.
  Port (
    clk       : in std_logic;
    Rs1_Addr  : in std_logic_vector (M-1 downto 0);  -- Read address.
    Rd_Addr   : in std_logic_vector (M-1 downto 0);
    Din : in std_logic_vector (N-1 downto 0);  -- Data to store.
    WE  : in std_logic;  -- Write Enable, behaves as CLK for the model.
    RST : in std_logic;
    Rs1_out : out std_logic_vector (N-1 downto 0));
end component;

component instr_mem is
  generic (
    N : integer := 16;  -- N-bits size of word.
    M : integer := 10); -- Size of RAM block. 2^M registers of N bits each.
  Port (
    clk       : in std_logic;
    Rs1_Addr  : in std_logic_vector (M-1 downto 0);  -- Read address.
    RST : in std_logic;
    Rs1_out : out std_logic_vector (N-1 downto 0));
end component;

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

  component blk_mem_gen_0 IS
  Port (
    clka : IN STD_LOGIC;
    rsta : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    rsta_busy : OUT STD_LOGIC);
 end component;

component mux21 is
port (
  sel : in std_logic;
  a : in std_logic_vector (15 downto 0);
  b : in std_logic_vector (15 downto 0);
  c : out std_logic_vector (15 downto 0));
end component;

component mux41 is
port (
  sel : in std_logic_vector (1 downto 0);
  a : in std_logic;
  b : in std_logic;
  c : in std_logic;
  d : in std_logic;
  e : out std_logic);
end component;

--  -- First Three Lines of Code to Test:
--  -- LDR (0111): x2, 99
--  signal code1 : std_logic_vector (15 downto 0) := "1001100100100111";
--  -- LDR (0111): x3, 1
--  signal code2 : std_logic_vector (15 downto 0) := "0000000100110111";
--  -- ADD (0001): x11, x2, x3 ; 99+1 = 100 stored in x11
--  signal code3 : std_logic_vector (15 downto 0) := "1011001000110001";
--  -- Done


  signal mem_out : std_logic_vector (N-1 downto 0);
  signal rst_mem_flg : std_logic;

  signal PC_in  : std_logic_vector (N-1 downto 0) := (others => '0');  -- holds PC input
  signal PC_out  : std_logic_vector (N-1 downto 0);  -- holds PC output

  signal ble   : std_logic;  -- result of gate
  signal beq   : std_logic;  -- result of gate
  signal bne   : std_logic;  -- result of gate
  signal blt   : std_logic;  -- result of gate
  signal BranchSel : std_logic;  -- to Branch Mux
  signal BranchTo   : std_logic_vector (15 downto 0) := (others => '0'); -- holds branch PC offset
  signal JumpTo     : std_logic_vector (15 downto 0) := (others => '0'); -- holds jump PC offset
  signal PCJump     : std_logic_vector (15 downto 0) := (others => '0'); -- holds PC if jumping
  signal PCBranch   : std_logic_vector (15 downto 0) := (others => '0'); -- holds PC if branching
  signal Imm_large  : std_logic_vector (15 downto 0);

  signal JumpMuxOut : std_logic_vector (15 downto 0); -- output of Jump Mux to PC
  signal BranchMuxOut : std_logic_vector (15 downto 0); -- output of Branch Mux
  signal ImmMode_MuxOut : std_logic_vector (15 downto 0);
  signal ImmReg_MuxOut : std_logic_vector (15 downto 0);
  signal MemReg_MuxOut : std_logic_vector (15 downto 0);

  signal ena_mem : std_logic := '1';

  signal large_imm : signed (7 downto 0);

begin

  PC_TOP          : pc
  port map (clk=>clk, Din =>JumpMuxOut, Dout=>PC_out);

  MUX_BranchOP_41 : mux41
  port map (sel=>BranchOP_top, a=>ble, b=>beq,
            c=>bne, d=>blt, e=>BranchSel);

  MUX_Branch_21   : mux21
  port map (sel=>BranchSel, a=>PC_in, b=>PCBranch,
            c => BranchMuxOut);

  MUX_Jump_21   : mux21
  port map (sel=>Jump_top, a=>BranchMuxOut, b=>PCJump,
            c => JumpMuxOut);

  -- MUX_Rd_21   : mux21
  -- port map (sel=>sel_top_21, a=>a_top_21, b=>b_top_21,
  --                               c => c_top_21);

  MUX_ImmMode_21   : mux21
  port map (sel=>IMM_mode_top, a=>Rs1_out_top, b=>Imm_large,
                                     c => ImmMode_MuxOut);

  MUX_ImmReg_21   : mux21
  port map (sel=>IMM_to_Reg_top, a=>MemReg_MuxOut, b=>Imm_large,  -- *DATA MEM*
                                    c => ImmReg_MuxOut);

  MUX_MemReg_21   : mux21
  port map (sel=>Mem_to_Reg_top, a=>Dout_top, b=>mem_out,  -- *DATA MEM*
                                    c => MemReg_MuxOut);
  MUX_JumpReg_21   : mux21
  port map (sel=>Jump_top, a=>ImmReg_MuxOut, b=>PC_out,  
                                    c => Din_top);

  REG_FILE_TOP    : register_file
  generic map (N => N, M => M_reg)
  port map ( clk=>clk,Rs1_Addr => Rs1_Addr_top, Rs2_Addr => Rs2_Addr_top,
             Rd_Addr => Rd_Addr_top, Din => Din_top, WE => Load_top,
             RST => RST_top, Rs1_out => Rs1_out_top, Rs2_out => Rs2_out_top);

--  DATA_MEM : blk_mem_gen_0
--  port map (clka=>clk,rsta=>RST_top, ena=>ena_mem, wea=>Store_top,
--            addra=>Dout_top, dina=>Rs1_out_top, douta=>mem_out, rsta_busy=>rst_mem_flg);

  DATA_MEMORY : data_mem
  port map (clk=>clk, Rs1_Addr=>Dout_top(9 downto 0), Rd_Addr=>Dout_top(9 downto 0), Din=>Rs1_out_top,
           WE=>Store_top, RST=>RST_top, Rs1_out=>mem_out);

  INSTR_MEMORY : instr_mem
  port map (clk=>clk, Rs1_Addr=>PC_in(9 downto 0), RST=>RST_top, Rs1_out=>Instruction);

  CONTROL_TOP : control
  port map (opcode => opcode_top, RST => RST_top, Load => Load_top, -- *DATA MEM*
            Store => Store_top, Jump => Jump_top, Mem_to_Reg => Mem_to_Reg_top,
            IMM_to_Reg => IMM_to_Reg_top, IMM_mode => IMM_mode_top,
            Ble => Ble_top, Beq => Beq_top, Bne => Bne_top,
            Blt => Blt_top, ALUop => ALUop_top, BranchOP => BranchOP_top);

  ALU_TOP : alu
  generic map (N => N)
  port map (clk=>clk,ALUop => ALUop_top, Op1 => ImmMode_MuxOut,
            Op2 => Rs2_out_top, Dout => Dout_top,
            Zero => Zero_top, Negative => Negative_top);


  main : process(clk, RST)
  begin

    if RST='1' then -- Drive reset signal to all components in datapath
       RST_top <= '1';
       PC_in <= (others => '0');
    elsif Instruction = 0 then
    else -- Do normal process
      if clk='0' and RST_top='1' then
         RST_top <= '0';
      end if;
      
      if clk='0' then
         BranchTo <= std_logic_vector(shift_left(resize(signed(Instruction(7 downto 4)),16), 1));
         JumpTo <= std_logic_vector(shift_left(resize(signed(Instruction(15 downto 8)),16), 1));
         PCJump <= JumpTo + PC_out;
         if PC_out > 0 then
             PCBranch <= BranchTo + PC_out - 1;
         end if;
      end if;

      if rising_edge(clk) then
          PC_in <= PC_out + 1;

          Imm_large <= std_logic_vector(resize(signed(Instruction (15 downto 8)),16));
    
          Rs1_Addr_top <= Instruction (11 downto 8);
          Rs2_Addr_top <= Instruction (15 downto 12);
          Rd_Addr_top <= Instruction (7 downto 4);
          opcode_top <= Instruction (3 downto 0);
    
          ble <= Ble_top and (Zero_top or Negative_top);
          beq <= Beq_top and Zero_top;
          bne <= Bne_top and (not Zero_top);
          blt <= Blt_top and Negative_top;
      end if;
    end if;
  end process main;

end Behavioral;
