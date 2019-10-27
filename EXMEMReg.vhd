library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;


entity EXMEMReg is
port(
     clk           : in STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
     rst           : in STD_LOGIC;
     write_enable  : in STD_LOGIC;
     WBsigIn       : in STD_LOGIC_VECTOR(1 downto 0);
     MsigIn        : in STD_LOGIC_VECTOR(2 downto 0);
  
     branchDstIn   : in STD_LOGIC_VECTOR(31 downto 0);  
     zeroIn        : in STD_LOGIC;
  
     ALUresultIn   : in  STD_LOGIC_VECTOR(31 downto 0); -- Only write if '1'
     RD2In         : in  STD_LOGIC_VECTOR(31 downto 0); -- Asynchronous reset! Sets AddressOut to 0x0
     
     WBRegIn       : in  STD_LOGIC_VECTOR(4 downto 0);
  
  
  
     WBsigOut      : out STD_LOGIC_VECTOR(1 downto 0):="00";
     branchOut     : out STD_LOGIC:='0';
     MemRegOut     : out STD_LOGIC:='0';
     MemWriteOut   : out STD_LOGIC:='0';
  
     BranchDstOut  : out STD_LOGIC_VECTOR(31 downto 0):=x"00000000";  
     zeroOut       : out STD_LOGIC:='0';
  
     ALUresultOut  : out STD_LOGIC_VECTOR(31 downto 0):=x"00000000"; -- Only write if '1'
     RD2Out        : out STD_LOGIC_VECTOR(31 downto 0):=x"00000000"; -- Asynchronous reset! Sets AddressOut to 0x0
     
     WBRegOut      : out STD_LOGIC_VECTOR(4 downto 0):="00000"


);
end EXMEMReg;

architecture EXMEM_arch of EXMEMReg is
begin 
	process(clk,rst,write_enable) is
	begin
	if rst = '1' then
	    WBsigOut <= "00";
        branchOut <= '0';
        MemRegOut <= '0';
        MemWriteOut <= '0';
     
        BranchDstOut <= x"00000000";  
        zeroOut <= '0';
     
        ALUresultOut <= x"00000000"; -- Only write if '1'
        RD2Out <= x"00000000"; -- Asynchronous reset! Sets AddressOut to 0x0
     
        WBRegOut <= "00000";
    elsif(clk'event and clk = '1' and write_enable = '1')then
        WBsigOut <= WBsigIn;

        branchDstOut<= branchDstIn;
        
        zeroOut <= zeroIn;
        ALUresultOut<= ALUresultIn;
        
        RD2Out<= RD2In;
        WBRegOut<= WBRegIn;
        
        
        branchOut  <= MsigIn(2);
        MemRegOut <= MsigIn(1);
        MemWriteOut <= MsigIn(0);
    end if;
	end process;

end EXMEM_arch;


