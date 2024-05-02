----------------------------------------------------------------------------------
---Transmitting Temperature and LDR output data through WiFi involves communication with cloud server using IP Address
-- We used an open source data logger website thingspeak.com to reduce the implementation cost. 
--Once we created our channel for entering the data into web site, the channel will be allocated with one API key
---We have created one thingspeak channel and used field 1 for Temperature data and field 2 LDR ouput data
--thingspeak server will automatically plots the data retrieving from the field which we have entered an integer data of temperature and LDR output. 
---Parallaly we can check the output from LCD display.
---The used AT commands are
---AT+RST
--AT+CWMODE=1
---AT+CWJAP="WIFINAME","PASSWORD"
--AT+CIPSTART="TCP","184.106.153.149",80
---GET /update?api_key=FB6J33O4FKR6V8OC&field1=000&field2=000
-------------------------------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 
entity sensor_out is
    Port (
        clk             : in  STD_LOGIC;
        vauxp2          : in  STD_LOGIC;                         -- Auxiliary Channel 7
        vauxn2          : in  STD_LOGIC;
        vauxp10         : in  STD_LOGIC;                         -- Auxiliary Channel 15
        vauxn10         : in  STD_LOGIC;   
        txd             : out  STD_LOGIC ;                       ---data line
        lcd_e           : out std_logic;                         ----enable control
        lcd_rs          : out std_logic;                         ----data or command control
        data            : out std_logic_vector(7 downto 0)        ---data line
);
end sensor_out;
architecture Behavioral of sensor_out is
---signal for ASCII conversion of temperature and LDR data
signal temp_out:  std_logic_vector(7 downto 0); 
signal ldr_out: std_logic_vector(7 downto 0);
signal temp_data1,temp_data2,temp_data3:std_logic_vector(7 downto 0); 
signal ldr_data1,ldr_data2,ldr_data3:std_logic_vector(7 downto 0);

-----ADC connection
component ADC_C is
    Port (
        clk             : in  STD_LOGIC;
        vauxp2          : in  STD_LOGIC;                         -- Auxiliary Channel 7
        vauxn2          : in  STD_LOGIC;
        vauxp10         : in  STD_LOGIC;                         -- Auxiliary Channel 15
        vauxn10         : in  STD_LOGIC;
        temp_out        : out std_logic_vector(7 downto 0); 
        ldr_out         :out std_logic_vector(7 downto 0));
        end component;
 ----WIFI connection  
component WIFI is
port( clk : in  STD_LOGIC;
      txd : out  STD_LOGIC;
      temp_data1,temp_data2,temp_data3: in std_logic_vector(7 downto 0); 
	  ldr_data1,ldr_data2,ldr_data3:in std_logic_vector(7 downto 0)
	  );
end component;
----LCD connection       
component LCD is
    Port (      clk 	: in  STD_LOGIC;
         	    lcd_e  : out std_logic;   ----enable control
				lcd_rs : out std_logic;   ----data or command control
				data   : out std_logic_vector(7 downto 0); ---data line
				temp_data2,temp_data3: in std_logic_vector(7 downto 0); 
				ldr_data1,ldr_data2,ldr_data3:in std_logic_vector(7 downto 0));   
end component;
----Binary to BCD connection
component Binary_to_bcd is
  Port (
       clk : in std_logic;
       binary_in : in  std_logic_vector(7 downto 0);
       bcd0,bcd1,bcd2: out std_logic_vector(7 downto 0)
   );
end component;

begin
A1:ADC_C port map(clk,vauxp2,vauxn2,vauxp10,vauxn10,temp_out,ldr_out);
W1:WIFI port map(clk,txd,temp_data1,temp_data2,temp_data3,ldr_data1,ldr_data2,ldr_data3);
L1:LCD port map(clk,lcd_e,lcd_rs,data,temp_data2,temp_data3,ldr_data1,ldr_data2,ldr_data3);
B1:Binary_to_bcd port map(clk,temp_out,temp_data1,temp_data2,temp_data3);
B2:Binary_to_bcd port map(clk,ldr_out,ldr_data1,ldr_data2,ldr_data3);

end Behavioral;
