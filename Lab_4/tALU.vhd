--------------------------------------------------------------------------------
--
-- Test Bench for LAB #4
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');

	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result
	);
	

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

--SHIFTS AND SUBTRACTOR ARE QUESTIONABLE

		-- Non-immediates
		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"11223344";
		control  <= "00000";		-- Control in binary (ADD test)
		wait for 40 ns; 			-- result = 0x124578AB  and zeroOut = 0

		control  <= "01000";		-- AND
		wait for 40 ns; 			-- result = 0x1220144 and zeroOut = 0	

		control  <= "01010";		-- OR
		wait for 40 ns; 			-- result = 0x11237767 and zeroOut = 0	
	
		control  <= "00001";		-- SUB 
		wait for 40 ns; 			-- result = 0xF0011223 and zeroOut = 0	
		
		control  <= "10001";		-- SHIFT LEFT 1 
		wait for 40 ns; 			-- result = 0x02468ACE and zeroOut = 0

		control  <= "10010";		-- SHIFT LEFT 2 
		wait for 40 ns; 			-- result = 0x048D159C and zeroOut = 0

		control  <= "10011";		-- SHIFT LEFT 3 
		wait for 40 ns; 			-- result = 0x091A2B38 and zeroOut = 0

		control  <= "10101";		-- SHIFT RIGHT 1 
		wait for 40 ns; 			-- result = 0x0091A2B3 and zeroOut = 0

		control  <= "10110";		-- SHIFT RIGHT 2
		wait for 40 ns; 			-- result = 0x0048D159 and zeroOut = 0

		control  <= "10111";		-- SHIFT RIGHT 3 
		wait for 40 ns; 			-- result = 0x002468AC and zeroOut = 0

		control  <= "01111";		-- DataIn2 passing through 
		wait for 40 ns; 			-- result = 0x11223344 and zeroOut = 0
		

---------------IMMEDIATES-------------------------------------------------------
		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"00000001";	-- Immediate = 1
		control  <= "00000";		-- Control in binary (ADDI test)
		wait for 40 ns; 			-- result = 0x124578AB  and zeroOut = 0

		control  <= "01000";		-- ANDi
		wait for 40 ns; 			-- result = 0x1220144 and zeroOut = 0	

		control  <= "01010";		-- ORi
		wait for 40 ns; 			-- result = 0x11237767 and zeroOut = 0	
	
		control  <= "00001";		-- SUBi 
		wait for 40 ns; 			-- result = 0xF0011223 and zeroOut = 0	
		
		control  <= "10001";		-- SHIFT LEFT 1 
		wait for 40 ns; 			-- result = 0x02468ACE and zeroOut = 0

		control  <= "10010";		-- SHIFT LEFT 2 
		wait for 40 ns; 			-- result = 0x048D159C and zeroOut = 0

		control  <= "10011";		-- SHIFT LEFT 3 
		wait for 40 ns; 			-- result = 0x091A2B38 and zeroOut = 0

		control  <= "10101";		-- SHIFT RIGHT 1 
		wait for 40 ns; 			-- result = 0x0091A2B3 and zeroOut = 0

		control  <= "10110";		-- SHIFT RIGHT 2
		wait for 40 ns; 			-- result = 0x0048D159 and zeroOut = 0

		control  <= "10111";		-- SHIFT RIGHT 3 
		wait for 40 ns; 			-- result = 0x002468AC and zeroOut = 0

		control  <= "01111";		-- DataIn2 passing through 
		wait for 40 ns; 			-- result = 0x11223344 and zeroOut = 0

	-- Testing the zero output
		datain_b <= X"00000000";		-- result = 0 and zeroOut = 1
		control <= "01111";
		wait for 40 ns; 

		wait; -- will wait forever
	END PROCESS;

END;