------------------------------------------------------
-- ECEC 355 Computer Architecture (Summer 2015)
-- MIPS Single Cycle Datapath
-- Arithmetic Logic Unit (ALU) Control Component
-- Authors: Avik Bag/Kunal Malik 
-- Modified:  08/26/2015
------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ALUcontrol is
port(ALUOp:in std_logic_vector(1 downto 0);
     Funct:in std_logic_vector(5 downto 0);
     Operation:out std_logic_vector(3 downto 0));
end ALUcontrol;

architecture beh of ALUcontrol is

begin
  
  process(ALUOp, Funct)
    begin  
      if ( ALUOp = "00" ) then
        Operation <= "0010"; -- Addition
        
      elsif ( ALUOp = "01") then
        Operation <= "0110"; -- Subtraction
        
      elsif (ALUOp = "10") then
        case Funct is
        when "100000" => -- Addition
          Operation <= "0010" ;
        when "100010" => -- Subtraction
          Operation <= "0110" ;
        when "100100" => -- AND gate
          Operation <= "0000" ;
        when "100101" => -- OR gate
          Operation <= "0001" ;
        when "101010" => -- Set less than
          Operation <= "0111" ;
        when others =>
          null;
        end case;
      end if;
    end process;
  end beh;
