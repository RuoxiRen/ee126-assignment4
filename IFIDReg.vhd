library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;

entity IFIDReg is 
port(
     clk            : in   STD_LOGIC; 
     rst            : in   STD_LOGIC;
     write_enable   : in   STD_LOGIC;
     addressIn      : in   STD_LOGIC_VECTOR(31 downto 0); 
     instructionIn  : in   STD_LOGIC_VECTOR(31 downto 0); 
     addressOut     : out  STD_LOGIC_VECTOR(31 downto 0):=X"00000000"; 
     instructionOut : out  STD_LOGIC_VECTOR(31 downto 0):=X"00000000" 
);
end IFIDReg;

architecture IFID_arch of IFIDReg is
begin
	process(clk,rst,write_enable) is
	begin
	      if rst = '1' then
	          addressOut <= X"00000000";
	          instructionOut <= X"00000000";
	      elsif(clk'event and clk = '1' and write_enable = '1')then
	          addressOut <= addressIn;
	          instructionOut<= instructionIn;
	      end if;
	end process;
end IFID_arch;