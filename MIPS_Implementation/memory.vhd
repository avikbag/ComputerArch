------------------------------------------------------
-- ECEC 355 Computer Architecture (Summer 2015)
-- MIPS Single Cycle Datapath
-- Data Memory Component
-- Authors: Avik Bag/Kunal Malik 
-- Modified:  08/26/2015
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity memory is
	port (
		address, write_data: in STD_LOGIC_VECTOR (31 downto 0);
		MemWrite, MemRead,ck: in STD_LOGIC;
		read_data, memCHK: out STD_LOGIC_VECTOR (31 downto 0)
	);
end memory;


architecture behavioral of memory is	  

type mem_array is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

signal data_mem: mem_array := (
    X"00000001", -- For part A, assign any value different from value at mem location 0 && 4
    X"00000002", -- For part B, assign values that match for values at mem location 0 && 4
    X"00000003",
    X"00000004",
    X"00000005",
    X"00000006",
    X"00000007",
    X"00000000",
    X"00000000",
    X"00000000", 
    X"00000000", -- mem 10 
    X"00000000", 
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",  
    X"00000000", -- mem 20
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000", 
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000", 
    X"00000000", -- mem 30
    X"00000000");

begin

read_data <= data_mem(conv_integer(address(6 downto 2))) when MemRead = '1';

mem_process: process(address, write_data, data_mem, ck)
begin
	if ck = '0' and ck'event then
		if (MemWrite = '1') then
			data_mem(conv_integer(address(6 downto 2))) <= write_data;
			memCHK <= write_data;
		end if;
	end if;
end process mem_process;

end behavioral;