------------------------------------------------------
-- ECEC 355 Computer Architecture (Summer 2015)
-- MIPS Single Cycle Datapath
-- N-bit Multiplexor Component
-- Authors: Avik Bag/Kunal Malik 
-- Modified:  08/26/2015
------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity MUX32 is
generic (N: integer:= 4);
port(x,y:in std_logic_vector (N downto 0);
     sel:in std_logic;
     z:out std_logic_vector(N downto 0));
end MUX32;

architecture struct of MUX32 is
begin
z <= y when sel = '1' else x;
end struct;
