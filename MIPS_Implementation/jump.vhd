------------------------------------------------------
-- ECEC 355 Computer Architecture (Summer 2015)
-- MIPS Single Cycle Datapath
-- Jump Component
-- Authors: Avik Bag/Kunal Malik 
-- Modified:  08/26/2015
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;
entity jump is
    port (	instr: in STD_LOGIC_VECTOR (25 downto 0);
    		pc: in  STD_LOGIC_VECTOR (31 downto 0);
        	destination: out STD_LOGIC_VECTOR (31 downto 0)
    );
end jump;

architecture beh of jump is
begin
	destination <= pc(31 downto 28) & instr(25 downto 0) & "00" - "00000000000000000000000000000100";
end beh;