------------------------------------------------------
-- ECEC 355 Computer Architecture (Summer 2015)
-- MIPS Single Cycle Datapath
-- Instruction Memory Component
-- Authors: Avik Bag/Kunal Malik 
-- Modified:  08/26/2015
------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity instructionMemory is
port(AddressIn:in std_logic_vector(31 downto 0);
     machineCode:out std_logic_vector(31 downto 0));
end instructionMemory;

architecture beh of instructionMemory is
type instr is array (0 to 6) of std_logic_vector(31 downto 0);
signal binCode: instr:= (	-- Machine Code for Part A/B in hex, set array max to 6
							X"8d100000",
							X"8d110004",
							X"12110002",
							X"02959820",
							X"08000006",
							X"02959822",
							X"ad130008"

							-- Machine Code for Part C in hex, set array max to 14
							--X"2008000a",
							--X"20090014",
							--X"00005020",
							--X"0128c02a",
							--X"1300000F",
							--X"01285820",
							--X"214d0030",
							--X"000a7020",
							--X"8dcf0000",
							--X"01eb7820",
							--X"adaf0000",
							--X"2108ffff",
							--X"2129fffd",
							--X"214a0001",
							--X"08000003"
						);
signal index: integer:= 0;
BEGIN
	process(AddressIn, index)
	begin	
		index <= to_integer(unsigned(AddressIn));
		machineCode <= binCode(index / 4);
	end process;
	
end beh;