library ieee;
use ieee.std_logic_1164.all;

entity SignExtend is
port(
     x : in  STD_LOGIC_VECTOR(15 downto 0);
     y : out STD_LOGIC_VECTOR(31 downto 0) -- sign-extend(x)
);
end SignExtend;

architecture signextend_example of SignExtend is
begin
	process(x)
	begin 
		if x(15)='0' then
			y(15 downto 0)<=x;
			y(31 downto 16)<=X"0000";
		elsif x(15)='1' then
			y(15 downto 0)<=x;
			y(31 downto 16)<=X"FFFF";
		end if;
	end process;
end signextend_example;
