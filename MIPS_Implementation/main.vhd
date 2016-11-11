------------------------------------------------------
-- ECEC 355 Computer Architecture (Summer 2015)
-- MIPS Single Cycle Datapath
-- Main Processor
-- Authors: Avik Bag/Kunal Malik 
-- Modified:  08/26/2015
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;
entity main is
    port (
    		ck: in std_logic
    );
end main;

architecture structure of main is
-----------------------------
-- Components Instantiated --
-----------------------------
	component PC is
	port(AddressIn:in std_logic_vector(31 downto 0);
	     AddressOut:out std_logic_vector(31 downto 0);
		ck: in std_logic);
	end component;

	component instructionMemory is
	port(AddressIn:in std_logic_vector(31 downto 0);
	     machineCode:out std_logic_vector(31 downto 0));
	end component;

	component Control is
	port(
	     Opcode:in std_logic_vector(5 downto 0);
	     RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump:out std_logic;
	     ALUOp:out std_logic_vector(1 downto 0));
	end component;

	component reg is
	    port (
	        rs, rt, rd: in STD_LOGIC_VECTOR (4 downto 0);
	        write_data: in STD_LOGIC_VECTOR (31 downto 0);
	        RegWrite, ck: in STD_LOGIC;
	        read_data1, read_data2, rd_dest: out STD_LOGIC_VECTOR (31 downto 0)
	    );
	end component;

	component jump is
	    port (	instr: in STD_LOGIC_VECTOR (25 downto 0);
	    		pc: in  STD_LOGIC_VECTOR (31 downto 0);
	        	destination: out STD_LOGIC_VECTOR (31 downto 0)
	    );
	end component;

	component branch is
	    port (	immediate: in STD_LOGIC_VECTOR (31 downto 0);
	    		pc: in  STD_LOGIC_VECTOR (31 downto 0);
	        	destination: out STD_LOGIC_VECTOR (31 downto 0)
	    );
	end component;

	component SignExtend is
	port(x:in std_logic_vector(15 downto 0);
	     y:out std_logic_vector(31 downto 0));
	end component;

	component ALUcontrol is
	port(ALUOp:in std_logic_vector(1 downto 0);
	     Funct:in std_logic_vector(5 downto 0);
	     Operation:out std_logic_vector(3 downto 0));
	end component;

	component ALU is
	    port (	a, b: in STD_LOGIC_VECTOR (31 downto 0);
	    		aluOp: in STD_LOGIC_VECTOR (3 downto 0);
	        	result: out STD_LOGIC_VECTOR (31 downto 0);
	        	zero: out STD_LOGIC
	    );
	end component;

	component memory is
		port (
			address, write_data: in STD_LOGIC_VECTOR (31 downto 0);
			MemWrite, MemRead,ck: in STD_LOGIC;
			read_data, memCHK: out STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;

	component MUX32 is
	generic (N: integer:= 31);
		port(x,y:in std_logic_vector (N downto 0);
     		sel:in std_logic;
     		z:out std_logic_vector(N downto 0));
		end component;
-----------------------------------------------
-- Varaibles to hold each processing element --
-----------------------------------------------

	signal addIn: 		std_logic_vector(31 downto 0):= "11111111111111111111111111111111";
	signal addOut: 		std_logic_vector(31 downto 0);
	signal instruction: std_logic_vector(31 downto 0);
	signal immediate: 	std_logic_vector(31 downto 0);
	signal op: 			std_logic_vector(3 downto 0);
	signal rs: 			std_logic_vector(4 downto 0);
	signal rt: 			std_logic_vector(4 downto 0);
	signal rd: 			std_logic_vector(4 downto 0);
	signal jumpAdd: 	std_logic_vector(31 downto 0);
	signal branchAdd: 	std_logic_vector(31 downto 0);
	signal dest:		std_logic_vector(31 downto 0);
	signal ALUres: 		std_logic_vector(31 downto 0);
	signal memData: 	std_logic_vector(31 downto 0);
	signal a: 			std_logic_vector(31 downto 0);
	signal b: 			std_logic_vector(31 downto 0);
	signal c:			std_logic_vector(31 downto 0);
	signal d_reg:		std_logic_vector(31 downto 0);
	signal writeReg: 	std_logic_vector(31 downto 0);
	signal final:		std_logic_vector(31 downto 0);
	signal memChk:		std_logic_vector(31 downto 0);

	signal RegDst: 		std_logic;
	signal jmp: 		std_logic;
	signal brnch: 		std_logic;
	signal MemRead: 	std_logic;
	signal MemWrite: 	std_logic;
	signal MemtoReg: 	std_logic;
	signal ALUSrc: 		std_logic;
	signal RegWrite: 	std_logic;
	signal aluOp: 		std_logic_vector(1 downto 0);
	signal zero: 		std_logic;
	signal branch_line:	std_logic;

begin
	Counter: 	PC port map (addIn, addOut, ck);
	IM: 		instructionMemory port map (addOut, instruction);

	SE: 		SignExtend port map (instruction(15 downto 0), immediate);
	CT: 		Control port map (instruction(31 downto 26), RegDst, brnch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, jmp, aluOp);
		
		rs <= instruction(25 downto 21);
		rt <= instruction(20 downto 16);
	
	RD_MUX: 	MUX32 generic map(N => 4) port map (instruction(20 downto 16), instruction(15 downto 11), RegDst, rd); -- decides rd destination
	Reg_block: 	reg port map (rs, rt, rd, writeReg, RegWrite, ck, a, b, d_reg); -- d_reg provides results when anything is written to rd
	ALU_input: 	MUX32 generic map(n => 31) port map (b, immediate, ALUsrc, c); -- decides on whether readData1 or immediate should be ALU input
	ALU_control:ALUcontrol port map(aluOp, instruction(5 downto 0), op);
	ALU_calc: 	ALU port map(a, c, op, ALUres, zero); -- a, c are ALU src outputting the result based on op
	Mem_access: memory port map(ALUres, b, MemWrite,MemRead, ck, memData, memChk); -- memChk checks for whether data is written onto the memory
	MUX_write: 	MUX32 generic map (N => 31) port map(ALUres, memData, memToReg, writeReg); -- decides whether to use the ALU result or dataRead
	branch_PC: 	branch port map(immediate, addOut, branchAdd); -- determines the branch address
		
		branch_line <= brnch and zero; -- ANDing the branch control line with zero line from ALU
	
	branch_MUX: MUX32 generic map(N => 31) port map (addOut, branchAdd, branch_line, dest); -- Decides whether to use the branch address or PC
	jump_PC: 	jump port map(instruction(25 downto 0), addOut, jumpAdd); -- determines the jump address
	jump_MUX: 	MUX32 generic map(N => 31) port map (dest, jumpAdd, jmp, final); -- Decides whether to use the jump address or PC

		addIn <= final;
end structure;