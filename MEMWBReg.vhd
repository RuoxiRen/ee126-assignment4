library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;

entity MEMWBReg is
port(
     clk           : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
     rst           : in  STD_LOGIC;
     write_enable  : in  STD_LOGIC;
     WBsigIn       : in  STD_LOGIC_VECTOR(1 downto 0);
 
     readdataIn    : in  STD_LOGIC_VECTOR(31 downto 0);  
     ALUresultIn   : in  STD_LOGIC_VECTOR(31 downto 0);
 
     WBRegIn       : in  STD_LOGIC_VECTOR(4 downto 0);

     RegWriteOut   : out STD_LOGIC:='0';
     MemtoRegOut   : out STD_LOGIC:='0';

     readdataOut   : out STD_LOGIC_VECTOR(31 downto 0):=x"00000000";  
     ALUresultOut  : out STD_LOGIC_VECTOR(31 downto 0):=x"00000000";

     WBRegOut      : out STD_LOGIC_VECTOR(4 downto 0):="00000"


);
end MEMWBReg;

architecture MEMWB_arch of MEMWBReg is
	process(clk,rst,write_enable) is
	begin
	      if rst = '1' then
	          RegWriteOut <= '0';
	          MemtoRegOut <='0';
	          
	          readdataOut <= x"00000000";  
	          ALUresultOut <= x"00000000";
	          
	          WBRegOut <= "00000";
	      elsif(clk'event and clk = '1' and write_enable = '1')then
	          RegWriteOut <= WBsigIn(1);
	          MemtoRegOut <= WBsigIn(0);
          
	          readdataOut<= readdataIn;
          
	          ALUresultOut <= ALUresultIn;
	          WBregOut<= WBregIn;
	      end if;
	end process;
end MEMWB_arch;



