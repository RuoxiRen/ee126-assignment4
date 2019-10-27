library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;

entity scCPU_tb is
end scCPU_tb;

architecture tb of scCPU_tb is

	signal clk : STD_LOGIC:='1';
	signal rst : STD_LOGIC:='1';
	signal DEBUG_PC : STD_LOGIC_VECTOR(31 downto 0);
	signal DEBUG_INSTRUCTION : STD_LOGIC_VECTOR(31 downto 0);
	signal DEBUG_TMP_REGS : STD_LOGIC_VECTOR(32*4 - 1 downto 0);
	signal DEBUG_SAVED_REGS : STD_LOGIC_VECTOR(32*4 - 1 downto 0);
	signal DEBUG_MEM_CONTENTS : STD_LOGIC_VECTOR(32*4 - 1 downto 0);

begin
	UUT:entity work.SingleCycleCPU port map(clk,rst,DEBUG_PC,DEBUG_INSTRUCTION,DEBUG_TMP_REGS,DEBUG_SAVED_REGS,DEBUG_MEM_CONTENTS);
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






