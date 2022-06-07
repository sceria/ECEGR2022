--------------------------------------------------------------------------------
---------------LAB3 : BITSTORAGE------------------------------

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
--REGISTER8
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
-- REGISTER32
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

--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;

signal addie : integer;

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) then
	if WE = '1' then
		addie <= to_integer(unsigned(Address));
		if (addie <= 127) AND (addie >= 0) then -- writes into RAM with certain conditions
			i_ram(addie) <= DataIn;
		-- else
			-- i_ram(addie) <= (others => 'Z');
		end if;

	-- Add code to write data to RAM
	-- Use to_integer(unsigned(Address)) to index the i_ram array
	end if;
    end if;

	-- Rest of the RAM
    if OE = '0' then
	addie <= to_integer(unsigned(Address));
	if (addie <= 127) AND (addie >= 0) then
		DataOut <= i_ram(addie);
	else
		DataOut <= (others => 'Z');
	end if;
    end if;
	    

  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); -- Which register you desire to read from
         ReadReg2: in std_logic_vector(4 downto 0); -- another one^
         WriteReg: in std_logic_vector(4 downto 0); -- Register you wanna write to
	 WriteData: in std_logic_vector(31 downto 0); 
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;

signal writea0: std_logic;
signal writea1: std_logic;
signal writea2: std_logic;
signal writea3: std_logic;
signal writea4: std_logic;
signal writea5: std_logic;
signal writea6: std_logic;
signal writea7: std_logic;
-- signal writex0: std_logic;

signal reada0: std_logic_vector(31 downto 0);
signal reada1: std_logic_vector(31 downto 0);
signal reada2: std_logic_vector(31 downto 0);
signal reada3: std_logic_vector(31 downto 0);
signal reada4: std_logic_vector(31 downto 0);
signal reada5: std_logic_vector(31 downto 0);
signal reada6: std_logic_vector(31 downto 0);
signal reada7: std_logic_vector(31 downto 0);
-- signal readx0: std_logic_vector(31 downto 0);

begin
 process(WriteCmd, WriteReg) is
   begin 
	if WriteReg = "01010" AND WriteCmd = '1' then
		writea0 <= '1';
	elsif WriteReg = "01011" AND WriteCmd = '1' then 
		writea1 <= '1';
	elsif WriteReg = "01100" AND WriteCmd = '1' then 
		writea2 <= '1';
	elsif WriteReg = "01101" AND WriteCmd = '1' then 
		writea3 <= '1';
	elsif WriteReg = "01110" AND WriteCmd = '1' then 
		writea4 <= '1';
	elsif WriteReg = "01111" AND WriteCmd = '1' then 
		writea5 <= '1';
	elsif WriteReg = "10000" AND WriteCmd = '1' then 
		writea6 <= '1';
	elsif WriteReg = "10001" AND WriteCmd = '1' then 
		writea7 <= '1';
	else 
		writea0 <= '0';
		writea1 <= '0';
		writea2 <= '0';
		writea3 <= '0';
		writea4 <= '0';
		writea5 <= '0';
		writea6 <= '0';
		writea7 <= '0';
	end if;
   end process;

WRa0: register32 port map(WriteData, '0', '1', '1', writea0, '0', '0', reada0);
WRa1: register32 port map(WriteData, '0', '1', '1', writea1, '0', '0', reada1);
WRa2: register32 port map(WriteData, '0', '1', '1', writea2, '0', '0', reada2);
WRa3: register32 port map(WriteData, '0', '1', '1', writea3, '0', '0', reada3);
WRa4: register32 port map(WriteData, '0', '1', '1', writea4, '0', '0', reada4);
WRa5: register32 port map(WriteData, '0', '1', '1', writea5, '0', '0', reada5);
WRa6: register32 port map(WriteData, '0', '1', '1', writea6, '0', '0', reada6);
WRa7: register32 port map(WriteData, '0', '1', '1', writea7, '0', '0', reada7);



process (ReadReg1) is -- Register 1
begin
	if ReadReg1 = "01010" then
		ReadData1 <= reada0;
	elsif ReadReg1 = "01011" then
		ReadData1 <= reada1;
	elsif ReadReg1 = "01100" then
		ReadData1 <= reada2;
	elsif ReadReg1 = "01101" then
		ReadData1 <= reada3;
	elsif ReadReg1 = "01110" then
		ReadData1 <= reada4;
	elsif ReadReg1 = "01111" then
		ReadData1 <= reada5;
	elsif ReadReg1 = "10000" then
		ReadData1 <= reada6;
	elsif ReadReg1 = "10001" then
		ReadData1 <= reada7;
	elsif ReadReg1 = "00000" then
		ReadData1 <= x"00000000";	
	else 
		ReadData1 <= (others => 'Z');
	end if;

    -- Add your code here for the Register Bank implementation
end process;

process(ReadReg2) is -- register2
begin
	if ReadReg2 = "01010" then
		ReadData2 <= reada0;
	elsif ReadReg2 = "01011" then
		ReadData2 <= reada1;
	elsif ReadReg2 = "01100" then
		ReadData2 <= reada2;
	elsif ReadReg2 = "01101" then
		ReadData2 <= reada3;
	elsif ReadReg2 = "01110" then
		ReadData2 <= reada4;
	elsif ReadReg2 = "01111" then
		ReadData2 <= reada5;
	elsif ReadReg2 = "10000" then
		ReadData2 <= reada6;
	elsif ReadReg2 = "10001" then
		ReadData2 <= reada7;
	elsif ReadReg2 = "00000" then
		ReadData2 <= x"00000000";	
	else 
		ReadData2 <= (others => 'Z');
	end if;

    -- Add your code here for the Register Bank implementation
end process;
end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
