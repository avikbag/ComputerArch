------------------------------------------------------
-- ECEC 355 Computer Architecture (Summer 2015)
-- MIPS Single Cycle Datapath
-- Registers Component
-- Authors: Avik Bag/Kunal Malik 
-- Modified:  08/26/2015
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity reg is
    port (
        rs, rt, rd: in STD_LOGIC_VECTOR (4 downto 0);
        write_data: in STD_LOGIC_VECTOR (31 downto 0);
        RegWrite, ck: in STD_LOGIC;
        read_data1, read_data2, rd_dest: out STD_LOGIC_VECTOR (31 downto 0)
    );
end reg;


architecture beh of reg is   

type reg_array is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

signal data_reg: reg_array := (
    X"00000000", -- initialize data register
    X"00000000", 
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000", -- temp registers
    X"00000000", -- temp registers
    X"00000000", -- temp registers
    X"00000000", -- temp registers
    X"00000000", -- temp registers
    X"00000000", -- temp registers
    X"00000000", -- temp registers
    X"00000000", -- temp registers
    X"00000000", -- saved temporary registers
    X"00000000", -- saved temporary registers
    X"00000000", -- saved temporary registers
    X"00000000", -- saved temporary registers
    X"0000000E", -- saved temporary registers
    X"00000005", -- saved temporary registers
    X"00000000", -- saved temporary registers
    X"00000000", -- saved temporary registers
    X"00000000", -- temp reg
    X"00000000", -- temp reg
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000",
    X"00000000");

signal rs_val: std_logic_vector(31 downto 0);
signal rt_val: std_logic_vector(31 downto 0);
signal rd_val: std_logic_vector(31 downto 0);

signal rs_index: integer:= 0;
signal rt_index: integer:= 0;
signal rd_index: integer:= 0;

begin

rs_index <= to_integer(unsigned(rs));
rt_index <= to_integer(unsigned(rt));
rd_index <= to_integer(unsigned(rd));

rs_val <= data_reg(rs_index);
rt_val <= data_reg(rt_index);
rd_val <= data_reg(rd_index);

reg_read: process(rs_val, rt_val, rd_val,ck)
begin
    --if ck = '1' and ck'event then
        read_data1 <= rs_val;
        read_data2 <= rt_val;
        rd_dest <= rd_val;
    --end if;
end process reg_read;

reg_write: process(write_data,ck)
begin
    if ck = '0' and ck'event then
        if RegWrite = '1' then 
            data_reg(rd_index) <= write_data;
        end if;
    end if;
end process reg_write;

end beh;