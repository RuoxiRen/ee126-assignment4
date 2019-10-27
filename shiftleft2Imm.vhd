library ieee;
use ieee.std_logic_1164.all;

entity ShiftLeft2Imm is -- Shifts the input by 2 bits
port(
     x : in  STD_LOGIC_VECTOR(31 downto 0);
     y : out STD_LOGIC_VECTOR(31 downto 0) -- x << 2
);
end ShiftLeft2Imm;

architecture shiftleft2_example of ShiftLeft2Imm is
begin
	y<=x sll 2;
end shiftleft2_example;


