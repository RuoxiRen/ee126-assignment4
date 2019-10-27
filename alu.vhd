library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity ALU is
-- Implement: AND, OR, ADD (signed), SUBTRACT (signed)
--    as described in Section 4.4 in the textbook.
-- The functionality of each instruction can be found on the 'MIPS Reference Data' sheet at the
--    front of the textbook.
port(
     a         : in     STD_LOGIC_VECTOR(31 downto 0);
     b         : in     STD_LOGIC_VECTOR(31 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(31 downto 0):=X"00000000";
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC
);
end ALU;

architecture alu_behaviour of ALU is

signal ALU_result : STD_LOGIC_VECTOR(31 downto 0);
signal tmp        : STD_LOGIC_VECTOR(32 downto 0):=X"00000000";

begin 
	process (a,b,operation)
	begin
		case (operation) is
			when "0000" => -- and
				ALU_result <= a and b;
				tmp(32) <= '0';
				tmp(31)	<= '0';
			when "0001" => -- or
				ALU_result <= a or b;
				tmp(32) <= '0';
				tmp(31)	<= '0';
			when "0010" => -- add
				ALU_result <= a+b;
				tmp <= ('0'&a) + ('0'&b);
			when "0110" => -- subtract
				ALU_result <= a-b;
				tmp <= ('0'&a) - ('0'&b);
			when "0111" => -- set less than
				if (a<b) then
					ALU_result <= X"00000001";
				else 
					ALU_result <= X"00000000";
				end if;
			when "1100" => -- nor
				ALU_result <= a nor b;

			when others =>
				ALU_result <= a and b;
				tmp <= ('0'&a) and ('0'&b);
		end case;
	end process;
	process(ALU_result)
	begin
		if (ALU_result = X"00000000") then
			zero <= '1';
		else 
			zero <= '0';
		end if;
	end process;
	result <= ALU_result;
	overflow <= tmp(32) xor tmp(31);
end alu_behaviour;


