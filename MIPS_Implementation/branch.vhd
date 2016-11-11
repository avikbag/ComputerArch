------------------------------------------------------
-- ECEC 355 Computer Architecture (Summer 2015)
-- MIPS Single Cycle Datapath
-- Branch Component
-- Authors: Avik Bag/Kunal Malik 
-- Modified:  08/26/2015
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;
entity branch is
    port (	immediate: in STD_LOGIC_VECTOR (31 downto 0);
    		pc: in  STD_LOGIC_VECTOR (31 downto 0);
        	destination: out STD_LOGIC_VECTOR (31 downto 0)
    );
end branch;

architecture beh of branch is
signal temp: STD_LOGIC_VECTOR(31 downto 0);
begin
	process (pc, immediate)
	begin
		temp <= immediate(29 downto 0) & "00" + pc;
	end process;
	destination <= temp;
	
end beh;