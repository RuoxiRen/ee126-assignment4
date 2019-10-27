library ieee;
use ieee.std_logic_1164.all;

entity MUX32Jump is -- Two by one mux with 32 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(31 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(31 downto 0)
);
end MUX32Jump;

architecture mux32_example of MUX32Jump is
begin
	process(in0,in1,sel)
	begin
		if sel = '0' then
			output<=in0;
		elsif sel = '1' then
			output<=in1;
		end if;
	end process;
end mux32_example;
