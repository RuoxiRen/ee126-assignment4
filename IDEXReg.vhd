library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;

entity IDEXReg is 
port(
     clk            : in STD_LOGIC;
     rst            : in STD_LOGIC;
     write_enable   : in STD_LOGIC;
     -- Control Signal 
     RegDstIn       : in STD_LOGIC;
     BranchIn       : in STD_LOGIC;
     MemReadIn      : in STD_LOGIC;
     MemtoRegIn     : in STD_LOGIC;
     MemWriteIn     : in STD_LOGIC;
     ALUSrcIn       : in STD_LOGIC;
     RegWriteIn     : in STD_LOGIC;
     ALUOpIn        : in STD_LOGIC_VECTOR(1 downto 0);
     -- PC
     addressIn      : in  STD_LOGIC_VECTOR(31 downto 0);  
     -- Register Data
     RD1In          : in  STD_LOGIC_VECTOR(31 downto 0);
     RD2In          : in  STD_LOGIC_VECTOR(31 downto 0); 
     extendedIn     : in  STD_LOGIC_VECTOR(31 downto 0);
     -- Instructions
     Ins2016In      : in STD_LOGIC_VECTOR(4 downto 0);
     Ins1511In      : in STD_LOGIC_VECTOR(4 downto 0);
     -- Signal for WB and MEM
     WBsigOut       : out STD_LOGIC_VECTOR(1 downto 0):="00";
     MsigOut        : out STD_LOGIC_VECTOR(2 downto 0):="000";
    
    
     RegDstOut      : out STD_LOGIC:='0';
     ALUSrcOut      : out STD_LOGIC:='0';
     ALUOpOut       : out STD_LOGIC_VECTOR(1 downto 0):="00";
    
     addressOut     : out STD_LOGIC_VECTOR(31 downto 0):=x"00000000";
    
     RD1Out         : out STD_LOGIC_VECTOR(31 downto 0):=x"00000000";
     RD2Out         : out STD_LOGIC_VECTOR(31 downto 0):=x"00000000"; 
     extendedOut    : out STD_LOGIC_VECTOR(31 downto 0):=x"00000000";
    
     Ins2016Out     : out STD_LOGIC_VECTOR(4 downto 0):="00000";
     Ins1511Out     : out STD_LOGIC_VECTOR(4 downto 0):="00000"
);
end IDEXReg;

architecture IDEX_arch of IDEXReg is
	signal WBsig : STD_LOGIC_VECTOR(1 downto 0);
	signal Msig  : STD_LOGIC_VECTOR(2 downto 0);
begin
	WBsig <= RegWriteIn & MemtoRegIn;
	Msig <= BranchIn & MemReadIn & MemWriteIn;
	process(clk,rst,write_enable) is
	begin
	if rst = '1' then
	    WBsigOut <= "00";
        MsigOut  <= "000";
        RegDstOut <= '0';
        ALUSrcOut <= '0';
        ALUOpOut <= "00";
        addressOut <= x"00000000";
        RD1Out <= x"00000000";
        RD2Out <= x"00000000"; 
        extendedOut <= x"00000000";
        Ins2016Out <= "00000";
        Ins1511Out <= "00000";
    elsif(clk'event and clk = '1' and write_enable = '1')then
        RegDstOut <= RegDstIn;
        ALUOpOut<= ALUOpIn;
        ALUSrcOut <= ALUSrcIn;
        
        addressOut<= addressIn;
        
        RD1Out <= RD1In;
        RD2Out <= RD2In;
        
        extendedOut <= extendedIn;
        
        Ins2016Out<= Ins2016In;
        Ins1511Out<= Ins1511In;

        WBsigOut <= WBsig;
        MsigOut<= Msig;
    end if;
	end process;
end IDEX_arch;




