----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.11.2018 17:31:51
-- Design Name: 
-- Module Name: ADC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADC is
    Port (
        clk             : in  STD_LOGIC;
        vauxp6          : in  STD_LOGIC;                         -- Auxiliary Channel 6
        vauxn6          : in  STD_LOGIC;
        vauxp7          : in  STD_LOGIC;                         -- Auxiliary Channel 7
        vauxn7          : in  STD_LOGIC;
        vauxp14         : in  STD_LOGIC;                         -- Auxiliary Channel 14
        vauxn14         : in  STD_LOGIC;
        vauxp15         : in  STD_LOGIC;                         -- Auxiliary Channel 15
        vauxn15         : in  STD_LOGIC;
        txd             : out  STD_LOGIC;
        lcd_e           : out std_logic;   ----enable control
        lcd_rs          : out std_logic;   ----data or command control
        data            : out std_logic_vector(7 downto 0)   ---data line
);
end ADC;

architecture Behavioral of ADC is
component xadc_wiz_0 
   port
   (
    daddr_in        : in  STD_LOGIC_VECTOR (6 downto 0);     -- Address bus for the dynamic reconfiguration port
    den_in          : in  STD_LOGIC;                         -- Enable Signal for the dynamic reconfiguration port
    di_in           : in  STD_LOGIC_VECTOR (15 downto 0);    -- Input data bus for the dynamic reconfiguration port
    dwe_in          : in  STD_LOGIC;                         -- Write Enable for the dynamic reconfiguration port
    do_out          : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
    drdy_out        : out  STD_LOGIC;                        -- Data ready signal for the dynamic reconfiguration port
    dclk_in         : in  STD_LOGIC;                         -- Clock input for the dynamic reconfiguration port
    vauxp6          : in  STD_LOGIC;                         -- Auxiliary Channel 6
    vauxn6          : in  STD_LOGIC;
    vauxp7          : in  STD_LOGIC;                         -- Auxiliary Channel 7
    vauxn7          : in  STD_LOGIC;
    vauxp14         : in  STD_LOGIC;                         -- Auxiliary Channel 14
    vauxn14         : in  STD_LOGIC;
    vauxp15         : in  STD_LOGIC;                         -- Auxiliary Channel 15
    vauxn15         : in  STD_LOGIC;
    busy_out        : out  STD_LOGIC;                        -- ADC Busy signal
    channel_out     : out  STD_LOGIC_VECTOR (4 downto 0);    -- Channel Selection Outputs
    eoc_out         : out  STD_LOGIC;                        -- End of Conversion Signal
    eos_out         : out  STD_LOGIC;                        -- End of Sequence Signal
    alarm_out       : out STD_LOGIC;                         -- OR'ed output of all the Alarms
    vp_in           : in  STD_LOGIC;                         -- Dedicated Analog Input Pair
    vn_in           : in  STD_LOGIC
);
end component;
signal data_adc : std_logic_vector(15 downto 0);
signal addr_in : std_logic_vector(6 downto 0);
signal enable, ready : std_logic;
 signal chsel : std_logic := '0';
 
-------Signal for Temperature Sensor------------
signal temp:integer range  0 to 200 :=0;

-------Signal for LDR Sensor------------
signal ldr:integer range  0 to 200 :=0; 
--------Signals for Heart Beat Sensor-----------
signal sigy: std_logic_vector(2 downto 0):=(others => '0'); 
type main1 is (s1, s2); 
signal tst,tst1 : main1; 
signal ap: integer := 0;
signal beat : integer range 0 to 120 := 0;

-------Signals for Binary to BCD and BCD to ASCII---------
type reg2 is array(1 to 3) of std_logic_vector(7 downto 0);    
signal arr_rp1,arr_rp :reg2; 
signal siga,sigb: std_logic_vector(2 downto 0):=(others => '0');

-------Signals for UART Transmitter----------
type stat1 is (ready2,start2,stop2);
signal ps2 :stat1 := ready2; 
signal start,stop :std_logic;
signal store :std_logic_vector(7 downto 0);
signal baud_clk : std_logic; 

type arr is array (1 to 182) of std_logic_vector(7 downto 0); 
constant str :  arr :=  ( X"41",X"41",X"54",X"2b",X"52",X"53",X"54",X"0d",X"0a", --9 AT+RST

 X"41",X"54",X"2b",X"43",X"57",X"4a",X"41",X"50",X"3d",X"22",X"41",X"41",X"41",X"41",X"41",X"41",X"41",X"41",X"41",X"41",X"22",X"2c",
 X"22",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"42",X"22",X"0d",X"0a", --45  ---AT+CWJAP="WIFINAME","Password"

 X"41",X"54",X"2b",X"43",X"49",X"50",X"53",X"54",X"41",X"52",X"54",X"3D",X"22",X"54",X"43",X"50",X"22",X"2C",X"22",
 X"31",X"38",X"34",X"2E",X"31",X"30",X"36",X"2E",X"31",X"35",X"33",X"2E",X"31",X"34",X"39",X"22",X"2C",X"38",X"30",X"0d",X"0a",  --40      ---AT+CIPSTART="TCP","184.106.153.149",80


 X"41",X"54",X"2b",X"43",X"49",X"50",X"53",X"45",X"4e",X"44",X"3d",X"36",X"30",X"0d",X"0a", --15			---AT+CIPSEND=60
 
 X"47",X"45",X"54",X"20",X"2F",X"75",X"70",X"64",X"61",X"74",X"65",X"3F",X"61",X"70",X"69",X"5F",X"6B",X"65",X"79",X"3D",  
 X"46", X"42", X"36", X"4a", X"33",X"33",X"4f",X"34",X"46",X"4b",X"52",X"36",X"56",X"38",X"4f",X"43",  --FB6J33O4FKR6V8OC

 X"26",X"66",X"69",X"65",X"6C",X"64",X"31",X"3D",X"30",X"31",X"31",X"26",X"66",X"69",X"65",X"6C",X"64",X"32",X"3D",X"30",X"31",X"31",X"0d",X"0a", --60  --GET /update?api_key=ZMERJO9Q36JZ3I63&field1=000&field2=000
 
 X"41",X"54",X"2b",X"43",X"49",X"50",X"43",X"4c",X"4f",X"53",X"45",X"0d",X"0a"); --13

constant N: integer :=35; 
type arr1 is array (1 to N) of std_logic_vector(7 downto 0); 
constant datas : arr1 :=    (X"38",X"0c",X"06",X"01",X"81",X"54",X"45",X"4d",X"50",X"45",X"52",x"41",x"54",x"55",x"52",x"45",x"3a",x"3a",x"3a",
										x"c1",x"4c",x"49",x"47",x"48",x"54",x"20",x"4c",x"45",x"56",x"45",x"4c",x"3a",x"3a",x"3a",x"3a"); --command and data to display                                              


begin

xadc1 : xadc_wiz_0 
port map(
    daddr_in => addr_in,
    den_in => '1',
    di_in => (others => '0'),
    dwe_in => '0',
    do_out => data_adc,
    drdy_out => ready,
    dclk_in => clk,
    vauxp6 => vauxp6,
    vauxn6 => vauxn6,
    vauxp7 => vauxp7,
    vauxn7 => vauxn7,
    vauxp14 => vauxp14,
    vauxn14 => vauxn14,
    vauxp15 => vauxp15,
    vauxn15 => vauxn15,
    vp_in => '0',
    vn_in => '0',
    busy_out => open,
    channel_out => open,
    eoc_out => enable,
    eos_out => open,
    alarm_out => open
       );

process(clk,ready)
begin
if rising_edge(clk) then
    if ready = '1' then
        if chsel = '1' then
            addr_in <= "0010111";
            temp <= (conv_integer(data_adc(15 downto 4)))*330/4096;
        elsif chsel = '0' then
            addr_in <= "0011111";
            ldr <= (conv_integer(data_adc(15 downto 8)));
        end if;
    end if;
end if;
end process;

----------Temperature Value binary to ASCII Convertion------------
process (clk)
	variable q1 : integer range 0 to 100 := 0;
	variable p1,p2,p3,p4 : integer range 0 to 10 := 0;
begin
if rising_edge(clk) then
	sigb <= sigb + 1;
	case sigb is
		when "000" =>         

	         q1 := temp;
				p1 := 0;
				p2 := 0;
				p3 := 0;
				
		when "001" =>
			if (q1 >= 100) then
					q1 := q1 - 100;
					p1 := p1 + 1;
					sigb <= "001";
			elsif (q1 >= 10) then
					q1 := q1 - 10;
					p2 := p2 + 1;
					sigb <= "001";
			else
					p3 := q1;
			end if;
			
		when "010" =>			
		arr_rp1(1) <= conv_std_logic_vector (p1, 8) + x"30";
		when "011" =>			
		arr_rp1(2) <= conv_std_logic_vector (p2, 8) + x"30";
		when "100" =>			
		arr_rp1(3) <= conv_std_logic_vector (p3, 8) + x"30";
		when others =>
				sigb <= "000";
	end case;
end if;
end process;

----------LDR Value binary to ASCII Convertion------------
process (clk)
	variable q1 : integer range 0 to 200 := 0;
	variable p1,p2,p3,p4 : integer range 0 to 10 := 0;
begin
if rising_edge(clk) then
	siga <= siga + 1;
	case siga is
		when "000" =>         

	         q1 := ldr;
				p1 := 0;
				p2 := 0;
				p3 := 0;
				
		when "001" =>
			if (q1 >= 100) then
					q1 := q1 - 100;
					p1 := p1 + 1;
					siga <= "001";
			elsif (q1 >= 10) then
					q1 := q1 - 10;
					p2 := p2 + 1;
					siga <= "001";
			else
					p3 := q1;
			end if;
			
		when "010" =>			
		arr_rp(1) <= conv_std_logic_vector (p1, 8) + x"30";
		when "011" =>			
		arr_rp(2) <= conv_std_logic_vector (p2, 8) + x"30";
		when "100" =>			
		arr_rp(3) <= conv_std_logic_vector (p3, 8) + x"30";
		when others =>
				siga <= "000";
	end case;
end if;
end process;

-----------UART Transmitter at 115200 Baud Rate-----------------
process(clk)
---------------------50 x 10^6 / 16*115200 = 27
variable baud_count : integer range 0 to 27 := 0; 
begin
if rising_edge(clk) then
if baud_count = 27 then
baud_clk <= '1';
baud_count := 0;
else
baud_count := baud_count + 1;
baud_clk <= '0';
end if;
end if;
end process; 

process(baud_clk)
variable i,k : integer := 0;
variable j : integer := 53;
begin
if rising_edge(baud_clk)then
if ps2 = ready2 then
i := i + 1;	
if i = 8 then
		txd <= '0';
		i := 0;
		ps2 <= start2;
 end if;
end if;
---------------------16xbaudrate sampling mathod---------------------------
if ps2 = start2 then
i := i + 1;

if j = 154 then

store <= arr_rp1(1);
elsif j = 155 then
store <= arr_rp1(2);
elsif j = 156 then
store <= arr_rp1(3);
elsif j = 165 then
store <= arr_rp(1);
elsif j = 166 then
store <= arr_rp(2);
elsif j = 167 then
store <= arr_rp(3);
else
store <= str(j)(7 downto 0);
end if;

if i = 16 then
txd <= store(0);
end if;

if i = 32 then
txd <= store(1);
end if;

if i = 48 then
txd <= store(2);
end if;

if i = 64 then
txd <= store(3);
end if;

if i = 80 then
txd <= store(4);
end if;

if i = 96 then
txd <= store(5);
end if;

if i = 112 then
txd <= store(6);
end if;

if i = 128 then
txd <= store(7);
end if;

if i = 144 then
txd <= '1';
end if;

if i = 160 then
i := 0;
ps2 <= stop2;
end if;

elsif ps2 = stop2 then
if j = 9 then
	ps2 <= stop2;
	k := k + 1;
	if k = 10000000 then
	j := j + 1;
	k := 0;
	ps2 <= ready2;
	end if;
elsif j = 54 then
	ps2 <= stop2;
	k := k + 1;
	if k = 50000000 then
	j := j + 1;
	k := 0;
	ps2 <= ready2;
	end if;
elsif j = 94 then
	ps2 <= stop2;
	k := k + 1;
	if k = 5000000 then
	j := j + 1;
	k := 0;
	ps2 <= ready2;
	end if;
elsif  j = 109 then
	ps2 <= stop2;
	k := k + 1;
	if k = 5000000 then
	j := j + 1;
	k := 0;
	ps2 <= ready2;
	end if;
elsif  j = 169 then
	ps2 <= stop2;
	k := k + 1;
	if k = 5000000 then
	j := j + 1;
	k := 0;
	ps2 <= ready2;
	end if;
elsif j = 182 then
	ps2 <= stop2;
	k := k + 1;
	if k = 5000000 then
	k := 0;
	j := 54;	
	ps2 <= ready2;
	end if;
else
	j := j + 1;
	ps2 <= ready2;
end if;


end if;
end if;
end process;

process(clk)
variable i : integer := 0;
variable j : integer := 1;
begin

if clk'event and clk = '1' then
	if i <= 1000000 then
		i := i + 1;
		lcd_e <= '1';
		if j < 18 then
			data <= datas(j)(7 downto 0);
		elsif j = 18 then
			data <= arr_rp1(2);
		elsif j = 19 then
			data <= arr_rp1(3);
			chsel <= '0';
		elsif j > 19 and j < 33 then
			data <= datas(j)(7 downto 0);
		elsif j = 33 then
			data <= arr_rp(1);
		elsif j = 34 then
			data <= arr_rp(2);
		elsif j = 35 then
			data <= arr_rp(3);
			chsel <= '1';
		end if;
	elsif i > 1000000 and i < 2000000 then
		i := i + 1;
		lcd_e <= '0';
	elsif i = 2000000 then
		j := j + 1;
		i := 0;
	end if;
	if j <= 5  then
		lcd_rs <= '0';    ---command signal
	elsif j > 5 and j < 20 then
		lcd_rs <= '1';   ----data signal
    elsif j = 20 then
		lcd_rs <= '0';   ----command signal
	elsif j > 20 and j <= 35 then
		lcd_rs <= '1';   ----data signal
	end if;
	if j = 36 then  ---repeated display of data
		j := 5;
	end if;
end if;

end process;
end Behavioral;
