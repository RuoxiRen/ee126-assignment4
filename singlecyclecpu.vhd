library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;

entity SingleCycleCPU is
port(clk :in STD_LOGIC;
     rst :in STD_LOGIC;
     --Probe ports used for testing
     --The current address (AddressOut from the PC)
     DEBUG_PC : out STD_LOGIC_VECTOR(31 downto 0);
     --The current instruction (Instruction output of IMEM)
     DEBUG_INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0);
     --DEBUG ports from other components
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0);
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0);
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0)
);
end SingleCycleCPU;

architecture SingleCycleCPU_arch of SingleCycleCPU is
component PC is 
port(
     clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
     write_enable : in  STD_LOGIC:='1'; -- Only write if '1'
     rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
     AddressIn    : in  STD_LOGIC_VECTOR(31 downto 0); -- Next PC address
     AddressOut   : out STD_LOGIC_VECTOR(31 downto 0) -- Current PC address
);
end component;

component ADDALU is
-- Adds two signed 32-bit inputs
-- output = in1 + in2
port(
     in0    : in  STD_LOGIC_VECTOR(31 downto 0);
     in1    : in  STD_LOGIC_VECTOR(31 downto 0);
     output : out STD_LOGIC_VECTOR(31 downto 0)
);
end component;

component ADDPC is
-- Adds two signed 32-bit inputs
-- output = in1 + in2
port(
     in0    : in  STD_LOGIC_VECTOR(31 downto 0);
     in1    : in  STD_LOGIC_VECTOR(31 downto 0);
     output : out STD_LOGIC_VECTOR(31 downto 0)
);
end component;


component ALU is 
port(
     a         : in     STD_LOGIC_VECTOR(31 downto 0);
     b         : in     STD_LOGIC_VECTOR(31 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(31 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC
);
end component;

component ALUControl is
port(
     ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
     Funct     : in  STD_LOGIC_VECTOR(5 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
);
end component;

component AND2 is
port (
      in0    : in  STD_LOGIC;
      in1    : in  STD_LOGIC;
      output : out STD_LOGIC -- in0 and in1
);
end component;

component CPUControl is
port(Opcode   : in  STD_LOGIC_VECTOR(5 downto 0);
     RegDst   : out STD_LOGIC;
     Branch   : out STD_LOGIC;
     MemRead  : out STD_LOGIC;
     MemtoReg : out STD_LOGIC;
     MemWrite : out STD_LOGIC;
     ALUSrc   : out STD_LOGIC;
     RegWrite : out STD_LOGIC;
     Jump     : out STD_LOGIC;
     ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
);
end component;

component DMEM is
generic(NUM_BYTES : integer := 32);
port(
     WriteData          : in  STD_LOGIC_VECTOR(31 downto 0); -- Input data
     Address            : in  STD_LOGIC_VECTOR(31 downto 0); -- Read/Write address
     MemRead            : in  STD_LOGIC; -- Indicates a read operation
     MemWrite           : in  STD_LOGIC; -- Indicates a write operation
     Clock              : in  STD_LOGIC; -- Writes are triggered by a rising edge
     ReadData           : out STD_LOGIC_VECTOR(31 downto 0); -- Output data
     --Probe ports used for testing
     -- Four 32-bit words: DMEM(0) & DMEM(4) & DMEM(8) & DMEM(12)
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0)
);
end component;

component IMEM is
generic(NUM_BYTES : integer := 128);
port(
     Address  : in  STD_LOGIC_VECTOR(31 downto 0); -- Address to read from
     ReadData : out STD_LOGIC_VECTOR(31 downto 0)
);
end component;

component MUX5 is -- Two by one mux with 5 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(4 downto 0)
);
end component;

component MUX32ALUb is -- Two by one mux with 32 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(31 downto 0)
);
end component;

component MUX32Branch is -- Two by one mux with 32 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(31 downto 0)
);
end component;

component MUX32Jump is -- Two by one mux with 32 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(31 downto 0)
);
end component;

component MUX32WB is -- Two by one mux with 32 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(31 downto 0)
);
end component;

component registers is
port(RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
     RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
     WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
     WD       : in  STD_LOGIC_VECTOR (31 downto 0);
     RegWrite : in  STD_LOGIC;
     Clock    : in  STD_LOGIC;
     RD1      : out STD_LOGIC_VECTOR (31 downto 0);
     RD2      : out STD_LOGIC_VECTOR (31 downto 0);
     --Probe ports used for testing
     -- $t0 & $t1 & t2 & t3
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0);
     -- $s0 & $s1 & s2 & s3
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0)
);
end component;

component ShiftLeft2Jump is -- Shifts the input by 2 bits
port(
     x : in  STD_LOGIC_VECTOR(31 downto 0);
     y : out STD_LOGIC_VECTOR(31 downto 0) -- x << 2
);
end component;

component ShiftLeft2Imm is -- Shifts the input by 2 bits
port(
     x : in  STD_LOGIC_VECTOR(31 downto 0);
     y : out STD_LOGIC_VECTOR(31 downto 0) -- x << 2
);
end component;

component SignExtend is
port(
     x : in  STD_LOGIC_VECTOR(15 downto 0);
     y : out STD_LOGIC_VECTOR(31 downto 0) -- sign-extend(x)
);
end component;


signal PCenSt : STD_LOGIC;
signal PCin , PCout , PCadd4: STD_LOGIC_VECTOR(31 downto 0);
signal Instruction : STD_LOGIC_VECTOR(31 downto 0);
signal RegDst , Branch , MemRead , MemtoReg , MemWrite , ALUSrc , RegWrite , Jump: STD_LOGIC;
signal WriteReg : STD_LOGIC_VECTOR(4 downto 0);
signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
signal ALUOperation : STD_LOGIC_VECTOR(3 downto 0);
signal JumpAddr : STD_LOGIC_VECTOR(31 downto 0);
signal Imm , Imm4 : STD_LOGIC_VECTOR(31 downto 0);
signal BranchAddr : STD_LOGIC_VECTOR(31 downto 0);
signal Writedata , ReadData1 , ReadData2 : STD_LOGIC_VECTOR(31 downto 0);
signal ALURes , ALUb: STD_LOGIC_VECTOR(31 downto 0);
signal ALUzero , ALUoverflow : STD_LOGIC;
signal MEMRData : STD_LOGIC_VECTOR(31 downto 0);
signal IAddr0: STD_LOGIC_VECTOR(31 downto 0);
signal BranchSig : STD_LOGIC;




signal tmpReg , savedReg : STD_LOGIC_VECTOR(32*4-1 downto 0);
signal MEMContents: STD_LOGIC_VECTOR(32*4-1 downto 0);

begin
U0: PC port map(clk,PCenSt,rst,PCin,PCout);
U1: IMEM port map(PCout,Instruction);
U2: MUX5 port map(Instruction(20 downto 16),Instruction(15 downto 11),RegDst,WriteReg);
U3: CPUControl port map(Instruction(31 downto 26),RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump,ALUOp);
U4: ShiftLeft2Jump port map("000000"&Instruction(25 downto 0),JumpAddr);
U5: ADDPC port map(PCout,X"00000004",PCadd4);
U6: registers port map(Instruction(25 downto 21),Instruction(20 downto 16),WriteReg,Writedata,RegWrite,clk,ReadData1,ReadData2,tmpReg,savedReg);
U7: SignExtend port map(Instruction(15 downto 0),Imm);
U8: ShiftLeft2Imm port map(Imm,Imm4);
U9: ADDALU port map(PCadd4,Imm4,BranchAddr);
U10: MUX32ALUb port map(ReadData2,Imm,ALUSrc,ALUb);
U11: ALUControl port map(ALUOp,Instruction(5 downto 0),ALUOperation);
U12: ALU port map(ReadData1,ALUb,ALUOperation,ALURes,ALUzero,ALUoverflow);
U13: DMEM port map(ReadData2,ALURes,MemRead,MemWrite,clk,MEMRData,MEMContents);
U14: MUX32WB port map(ALURes,MEMRData,MemtoReg,WriteData);
U15: MUX32Branch port map(PCadd4,BranchAddr,BranchSig,IAddr0);
U16: MUX32Jump port map (IAddr0,JumpAddr,Jump,PCin);
U17: AND2 port map(Branch,ALUzero,BranchSig);



DEBUG_PC <= PCout;
PCenSt <='1';
DEBUG_INSTRUCTION <= Instruction;
DEBUG_TMP_REGS <= tmpReg;
DEBUG_SAVED_REGS <= savedReg;
DEBUG_MEM_CONTENTS <= MEMContents;










end architecture SingleCycleCPU_arch;