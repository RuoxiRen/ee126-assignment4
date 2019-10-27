library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;

entity plCPU_tb is
end plCPU_tb;

architecture tb of plCPU_tb is

     signal clk :  STD_LOGIC;
     signal rst :  STD_LOGIC;
     --Probe ports used for testing or for the tracker.
     --The current address (in various pipe stages)
     signal DEBUG_PC, DEBUG_PCPlus4_ID, DEBUG_PCPlus4_EX, DEBUG_PCPlus4_MEM,DEBUG_PCPlus4_WB:  STD_LOGIC_VECTOR(31 downto 0);
     -- instruction is a store.
     signal DEBUG_MemWrite, DEBUG_MemWrite_EX, DEBUG_MemWrite_MEM:  STD_LOGIC;
     -- instruction writes the regfile.
     signal DEBUG_RegWrite, DEBUG_RegWrite_EX, DEBUG_RegWrite_MEM, DEBUG_RegWrite_WB:  std_logic;
     -- instruction is a branch or a jump.
     signal DEBUG_Branch, DEBUG_Jump:  std_logic;

     --The current instruction (Instruction output of IMEM)
     signal DEBUG_INSTRUCTION :  STD_LOGIC_VECTOR(31 downto 0);
     --DEBUG ports from other components
     signal DEBUG_TMP_REGS     :  STD_LOGIC_VECTOR(32*4 - 1 downto 0);
     signal DEBUG_SAVED_REGS   :  STD_LOGIC_VECTOR(32*4 - 1 downto 0);
     signal DEBUG_MEM_CONTENTS :  STD_LOGIC_VECTOR(32*4 - 1 downto 0);

begin
	UUT:entity work.PipelinedCPU0 port map(clk,rst,DEBUG_PC, DEBUG_PCPlus4_ID, DEBUG_PCPlus4_EX, DEBUG_PCPlus4_MEM,DEBUG_PCPlus4_WB,DEBUG_MemWrite, DEBUG_MemWrite_EX, DEBUG_MemWrite_MEM, DEBUG_RegWrite, DEBUG_RegWrite_EX, DEBUG_RegWrite_MEM, DEBUG_RegWrite_WB, DEBUG_Branch, DEBUG_Jump,DEBUG_INSTRUCTION,DEBUG_TMP_REGS,DEBUG_SAVED_REGS,DEBUG_MEM_CONTENTS);
	clk_pro:process
		constant clk_period: time := 10 ns;
		begin
			clk <= '1';
			wait for clk_period;
			clk <= '0';
			wait for clk_period;
		end process;
	rst_pro:process
		constant rst_period : time := 5 ns;
		constant rst_no : time := 10000 ns;
		begin
		rst <= '1';
		wait for rst_period;
		rst <= '0';
		wait for rst_no;
	end process;
end tb;






