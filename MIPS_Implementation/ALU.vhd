------------------------------------------------------
-- ECEC 355 Computer Architecture (Summer 2015)
-- MIPS Single Cycle Datapath
-- Arithmetic Logic Unit (ALU) Component
-- Authors: Avik Bag/Kunal Malik 
-- Modified:  08/26/2015
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;
entity ALU is
    port (	a, b: in STD_LOGIC_VECTOR (31 downto 0);
    		aluOp: in STD_LOGIC_VECTOR (3 downto 0);
        	result: out STD_LOGIC_VECTOR (31 downto 0);
        	zero: out STD_LOGIC
    );
end ALU;

architecture beh of ALU is 
signal temp: std_logic_vector(31 downto 0);
signal chk: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
begin

	process(a, b, aluOp, temp)
	begin
		if aluOp = "0010" then -- addition
			temp <= a + b;
		elsif aluOp = "0110" then -- subtraction
			temp <= a - b;
		elsif aluOp = "0000" then -- AND
			temp <= a and b;
		elsif aluOp = "0001" then -- OR
			temp <= a or b;
		elsif aluOp = "0111" then -- slt
			if a > b then
				temp <= (0 => '1', others => '0');
			else
				temp <= "00000000000000000000000000000000";
			end if;
		end if ;
	end process;
	zero <= '1' when temp = chk else '0';
	result <= temp;
end beh; 