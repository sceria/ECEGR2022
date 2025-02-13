--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
	with selector select
		Result <= In0 when '0',
			  In1 when others;
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
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
end Control;

architecture Boss of Control is
signal temp: std_logic_vector(4 downto 0); -- must be created to be used to compare to dtermine another signal
begin
process (opcode, funct3, funct7) is
	begin
		if opcode = "0110011" AND funct3 = "000" then
			if funct7 = "0000000" then -- ADD
				temp <= "00000";
			elsif funct7 = "0100000" then
				temp <= "00001"; --SUB
			end if;
		elsif opcode = "0110011" AND funct7 = "0000000" then
			if funct3 = "110" then
				temp <= "01010"; -- OR
			elsif funct3 = "111" then
				temp	<= "01000"; --AND
			end if;
		elsif opcode = "0110011" and funct7 = "0000000" then
			if funct3 = "001" then
				temp <= "10001"; --SLL
			elsif funct3 = "101" then
				temp <= "10101"; -- SRL
			end if;
		elsif opcode = "0010011" then
			if funct3 = "001" then
				temp <= "11001"; --SLLi
			elsif funct3 = "101" then
				temp <= "11101"; --SRLi
			elsif funct3 = "111" then
				temp <= "01001"; --ANDi
			elsif funct3 = "110" then
				temp <= "01011"; --ORi	
			elsif funct3 = "000" then
				temp <= "00010"; --ADDi		
			end if;
		elsif opcode = "0000011" or opcode = "0100011" then
			temp <= "00010"; -- LW/SW; ADDI operation for offsetting addresses
		elsif opcode = "1100011" AND (funct3 = "000" OR funct3 = "001") then
			temp <= "00001"; --BNE/BEQ ; uses subtraction to acquire the zero that's needed to branch
		elsif opcode = "0110111" then
			temp <= "00010"; --LUI; loads upper immediate
		else
			temp <= "01111"; -- pass through data otherwise
		end if;
ALUCtrl <= temp; 
end process;

Branch <= "01" when opcode = "1100011" and funct3 = "000" else --BEQ
	"10" when opcode = "1100011" and funct3 = "001" else -- BNE
	"00";

ALUSrc <= '0' when (temp /= "11001" or temp /= "11101" or temp /= "01001" or temp /= "01011" or temp /= "00010") else
	'1'; --ALUSource is needed for I-Type instructions

ImmGen <= "00" when opcode = "01011" or opcode = "0000011" else -- config. for i-types and LWs
	"01" when opcode = "0100111" else -- config. for s-types
	"10" when opcode = "1100011" else -- config. for branches (b-types)
	"11";				-- Nothing

RegWrite <= '1' when (opcode = "0110011" or opcode = "0010011" or opcode = "0110111" or opcode = "0000011") and clk = '0' else
	'0';

MemWrite <= '1' when opcode = "0100111" else
	'0';
				
MemRead <= '0' when opcode = "0000011" else  -- LW
	'1';

MemtoReg <= '1' when opcode = "0000011" else
	'0';

end Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is
begin
process(Reset, Clock)
begin
	if reset = '1' then
		PCout <= X"00400000"; -- PC register resets to this address (start address)
	elsif rising_edge(Clock) then
		PCout <= PCin;
	end if;
end process;
	
end executive;
--------------------------------------------------------------------------------
