library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity ALUControl is
-- Functionality should match truth table shown in Figure 4.13 in the textbook.
-- You only need to consider the cases where ALUOp = "00", "01", and "10". ALUOp = "11" is not
--    a valid input and need not be considered; its output can be anything, including "0110",
--    "0010", "XXXX", etc.
-- To ensure proper functionality, you must implement the "don't-care" values in the funct field,
-- for example when ALUOp = '00", Operation must be "0010" regardless of what Funct is.
port(
     ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
     Funct     : in  STD_LOGIC_VECTOR(5 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
);
end ALUControl;

architecture alucontrol_behaviour of ALUControl is

signal tmp : STD_LOGIC_VECTOR(3 downto 0);

begin 
	process (ALUOp,Funct)
	begin
		case (ALUOp) is
			when "00" =>
				tmp <= "0010";
			when "01" =>
				tmp <= "0110";
			when "10" =>
				if (Funct(3 downto 0) = "0000") then
					tmp <= "0010";
				elsif (Funct(3 downto 0) = "0010") then
					tmp <="0110";
				elsif (Funct(3 downto 0) = "0100") then
					tmp <="0000";
				elsif (Funct(3 downto 0) = "0101") then
					tmp <="0001";
				elsif (Funct(3 downto 0) = "1010") then
					tmp <="0111";
				end if;
			when others =>
				tmp <= "0010";
		end case;
	end process;
	Operation <= tmp;
end alucontrol_behaviour;

					

