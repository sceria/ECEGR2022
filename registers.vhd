--------------------------------------------------------------------------------
--
-- LAB #3
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then -- If writein is high
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;


--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		     enout: in std_logic;
		     writein: in std_logic;
		     bitout: out std_logic);
	end component;
begin
	store0: bitstorage port map(datain(0),
		 enout,
		 writein,
		 dataout(0));
	store1: bitstorage port map(datain(1),
		 enout,
		 writein,
		 dataout(1));
	store2: bitstorage port map(datain(2),
		 enout,
		 writein,
		 dataout(2));
	store3: bitstorage port map(datain(3),
		 enout,
		 writein,
		 dataout(3));
	store4: bitstorage port map(datain(4),
		 enout,
		 writein,
		 dataout(4));
	store5: bitstorage port map(datain(5),
		 enout,
		 writein,
		 dataout(5));
	store6: bitstorage port map(datain(6),
		 enout,
		 writein,
		 dataout(6));
	store7: bitstorage port map(datain(7),
		 enout,
		 writein,
		 dataout(7));

end architecture memmy;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	component register8
		port(datain: in std_logic_vector(7 downto 0);
	     	     enout:  in std_logic;
	     	     writein: in std_logic;
	     	     dataout: out std_logic_vector(7 downto 0));
	end component;
SIGNAL enable: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL enoutSignal: std_logic_vector(2 DOWNTO 0);
SIGNAL writing: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL enableWrite: std_logic_vector(2 DOWNTO 0);
begin
	enoutSignal <= (enout32 & enout16 & enout8); -- Concatenate the enables for the enable input
	enableWrite <= (writein32 & writein16 & writein8); -- Concatenate the enables for the write input

enable <= "1110" when enoutSignal = "110" else -- default for enable is active high
	  "1100" when enoutSignal = "101" else
	  "0000" when enoutSignal = "011" else
	  "1111" when enoutSignal = "111";

writing <= "0001" when enableWrite = "001" else
	  "0011" when enableWrite = "010" else
	  "1111" when enableWrite = "100" else
	  "0000" when enableWrite = "000";

	bits8: register8 port map(datain(7 DOWNTO 0),
				  enable(0),
				  writing(0),
				  dataout(7 DOWNTO 0));
	bits16: register8 port map(datain(15 DOWNTO 8),
				  enable(1),
				  writing(1),
				  dataout(15 DOWNTO 8));
	bits24: register8 port map(datain(23 DOWNTO 16),
				  enable(2),
				  writing(2),
				  dataout(23 DOWNTO 16));
	bits32: register8 port map(datain(31 DOWNTO 24),
				  enable(3),
				  writing(3),
				  dataout(31 DOWNTO 24));
end architecture biggermem;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;


architecture calc of adder_subtracter is
	component fulladder 
   	 port (a : in std_logic;
               b : in std_logic;
               cin : in std_logic;
               sum : out std_logic;
               carry : out std_logic
         );
	end component;
SIGNAL bTemp: std_logic_vector(31 DOWNTO 0);
SIGNAL carryOvers: std_logic_vector (32 DOWNTO 0);

begin
carryOvers(0) <= add_sub; -- Initial carry in; will be zero if adding and 1 if subtracting
co <= carryOvers(32); -- final carry out value after specified operation is completed

process(add_sub, datain_b)
begin
	if (add_sub = '0') then 
		bTemp <= datain_b;
	else
		bTemp <= NOT datain_b;
	end if;
end process;

operationItterations: for i in 0 to 31 generate
begin
	mapper: fulladder port map (datain_a(i), bTemp(i), carryOvers(i), dataout(i), carryOvers(i+1));
end generate;

end architecture calc;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic; -- 0 is shit left 1 is shift right
		shamt:	in std_logic_vector(4 downto 0); -- shift amount. 5 bits since 2^5 is 32
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
SIGNAL info: std_logic_vector (2 downto 0);

begin
info <= (dir & shamt(1 downto 0));

process(info, dir, shamt, datain)
begin
	if (info = "001") then -- shamt = "00001"
		dataout <= (datain(30 downto 0) & '0'); -- Shifts to the left by one bit
	elsif (info = "010") then -- shamt = "00010"
		dataout <= (datain(29 downto 0) & "00"); -- Shifts to the left by two bits
	elsif (info = "011") then -- shamt = "00011"
		dataout <= (datain(28 downto 0) & "000"); -- Shifts to the left by three bits
	elsif (info = "101") then -- shamt = "00001"
		dataout <= ('0' & datain(31 downto 1)); -- Shifts to the right by one bit
	elsif (info = "110") then -- shamt = "00010"
		dataout <= ("00" & datain(31 downto 2)); -- Shifts to the right by two bits
	elsif (info = "111") then -- shamt = "00011"
		dataout <= ("000" & datain(31 downto 3)); -- Shifts to the left by three bits
	else
		dataout <= datain;
	end if;
end process;
end architecture shifter;



