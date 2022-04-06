LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY intro is
PORT (
	A, B, C, D: IN STD_LOGIC;
	E: OUT STD_LOGIC);
END intro;

ARCHITECTURE behavior OF intro IS
BEGIN
	E <= (A OR B) AND (C OR D);
END ARCHITECTURE behavior; 
