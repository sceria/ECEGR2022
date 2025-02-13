--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
               opcode : in  STD_LOGIC_VECTOR (6 downto 0);
               funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
               funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
               Branch : out  STD_LOGIC_VECTOR(1 downto 0);
               MemRead : out  STD_LOGIC;
               MemtoReg : out  STD_LOGIC;
               ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
               MemWrite : out  STD_LOGIC;
               ALUSrc : out  STD_LOGIC;
               RegWrite : out  STD_LOGIC;
               ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

--ULTIMATE SIGNAL LIST:
signal add_subResult: std_logic_vector (31 downto 0);
signal PC_addCO: std_logic;
signal ImmGenOut: std_logic_vector (31 downto 0);

signal branchSum_to_mux: std_logic_vector(31 downto 0);
signal branchSum_co: std_logic := '0';

signal branchSel: std_logic;

signal instructionMEMout: std_logic_vector (31 downto 0);
signal MemRead, MemtoReg, MemWrite, ALUSrc: std_logic;
signal Branch, ImmGen: std_logic_vector (1 downto 0);

signal ALUCtrl: std_logic_vector(4 downto 0);

signal zero: std_logic;

signal ReadReg1, ReadReg2, WriteRegdest: std_logic_vector(4 downto 0);

signal WriteData: std_logic_vector(31 downto 0);

signal Regwrite: std_logic; --RegWrite enable; AKA WriteCmd

signal ALUinA: std_logic_vector(31 downto 0);
signal RegtoMUXDATAb: std_logic_vector(31 downto 0);

signal MUXdatabOUT: std_logic_vector(31 downto 0);

signal ALUResult: std_logic_vector(31 downto 0);

signal offsettedAddress: std_logic_vector (31 downto 0);

signal dataoffsetCO: std_logic;

signal PCin, PCout: std_logic_vector (31 downto 0);

signal dataMemOUT: std_logic_vector(31 downto 0);


begin
-- Mapping
PC: ProgramCounter port map (Reset, Clock, PCin, PCout);
PC_AS: adder_subtracter port map (PCout, x"00000004", '0', add_subResult, PC_addCO);
BranchAdder: adder_subtracter port map (PCout, ImmGenOut, '0', branchSum_to_mux, branchSum_co);
PCmux: BusMux2to1 port map (branchSel, add_subResult, branchSum_to_mux, PCin);

instructionmemmie: InstructionRAM port map (Reset, Clock, PCout(31 downto 2), instructionMEMout);
controlblk: Control port map (clock, instructionMEMout(6 downto 0), instructionMEMout(14 downto 12), instructionMEMout(31 downto 25), Branch, MemRead, MemtoReg, ALUCtrl, MemWrite,
ALUSrc, RegWrite, ImmGen);
regFile: Registers port map (ReadReg1, ReadReg2, WriteRegdest, WriteData, RegWrite, ALUinA, RegtoMUXDATAb);
registerMUX: BusMux2to1 port map (ALUSrc, ImmGenOut, RegtoMUXDATAb, MUXdatabOUT);

THEmainALU: ALU port map (ALUinA, MUXdatabOUT, ALUCtrl, zero, ALUResult);

dataMemmie: RAM port map(Reset, Clock, MemRead, MemWrite, offsettedAddress(31 downto 2), RegtoMUXDATAb, dataMemOUT); 

finalMUX: BusMux2to1 port map(MemtoReg, ALUResult, dataMemOUT, WriteData); -------------

dataoffset: adder_subtracter port map(ALUResult, X"10000000", '1', offsettedAddress, dataoffsetCO);

ImmGenOut (31 downto 12) <= instructionMEMout(31 downto 12) when ImmGen = "00" else
			    instructionMEMout(31 downto 12) when ImmGen = "01" else
			    instructionMEMout(31 downto 12) when ImmGen = "10" else
			    instructionMEMout(31 downto 12);
ImmGenOut(11 downto 0) <= instructionMEMout(30 downto 20) when Immgen = "00" else
			  instructionMEMout(30 downto 25) & instructionMEMout(11 downto 8) & instructionMEMout(7) when Immgen = "01" else
			  instructionMEMout(7) & instructionMEMout(30 downto 25) & instructionMEMout(11 downto 8) & '0' when Immgen = "10" else
			  instructionMEMout(11 downto 0);

branchSel <= '1' when (Branch = "10" and zero = '0') or (Branch = "01" and zero = '1') else
	     '0';

end holistic;

