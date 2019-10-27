library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity registers is
-- This component is described in the textbook, starting on page 2.52
-- The indices of each of the registers can be found on the MIPS reference page at the front of the
--    textbook
-- Keep in mind that register 0(zero) has a constant value of 0 and cannot be overwritten

-- This should only write on the negative edge of Clock when RegWrite is asserted.
-- Reads should be purely combinatorial, i.e. they don't depend on Clock
-- HINT: Use the provided dmem.vhd as a starting point
port(RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
     RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
     WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
     WD       : in  STD_LOGIC_VECTOR (31 downto 0);
     RegWrite : in  STD_LOGIC;
     Clock    : in  STD_LOGIC;
     RD1      : out STD_LOGIC_VECTOR (31 downto 0);
     RD2      : out STD_LOGIC_VECTOR (31 downto 0);
     --Probe ports used for testing
     -- $t0 & $t1 & t2 & t3
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0);
     -- $s0 & $s1 & s2 & s3
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0)
);
end registers;

architecture reg_behaviour of registers is
type reg_type is array (0 to 32) of STD_LOGIC_VECTOR(31 downto 0);
signal reg_array : reg_type;
begin
     process(Clock,WR,WD,RegWrite)
     variable addr:integer;
     variable first:boolean :=true;
     begin
          if(first) then
               reg_array(0) <= X"00000000";
               reg_array(8) <= X"00000000";
               reg_array(9) <= X"00000001";
               reg_array(10) <= X"00000004";
               reg_array(11) <= X"00000008";
               reg_array(16) <= X"00000015";
               reg_array(17) <= X"00000007";
               reg_array(18) <= X"00000000";
               reg_array(19) <= X"00000016";
               first := false;
          end if;

          if Clock = '0' and Clock'event and RegWrite='1' then
               addr := to_integer(unsigned(WR));
               if addr = 0 then
                    reg_array(addr) <= X"00000000";
               else
                    reg_array(addr) <= WD;
               end if;
          end if;
     end process;


     RD1 <= X"00000000" when RR1 = "00000" else reg_array(to_integer(unsigned(RR1)));
     RD2 <= X"00000000" when RR2 = "00000" else reg_array(to_integer(unsigned(RR2)));
     DEBUG_TMP_REGS <= reg_array(8) & reg_array(9) & reg_array(10) & reg_array(11);
     DEBUG_SAVED_REGS <= reg_array(16) & reg_array(17) & reg_array(18) & reg_array(19);

end reg_behaviour;







