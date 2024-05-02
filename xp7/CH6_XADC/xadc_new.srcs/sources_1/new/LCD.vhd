----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:27:22 12/26/2018 
-- Design Name: 
-- Module Name:    LCD - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LCD is
    Port ( 	clk 	: in  STD_LOGIC;
         	lcd_e  : out std_logic;   ----enable control
            lcd_rs : out std_logic;   ----data or command control
            data   : out std_logic_vector(7 downto 0);  ---data line
            temp_data2,temp_data3: in std_logic_vector(7 downto 0); 
            ldr_data1,ldr_data2,ldr_data3:in std_logic_vector(7 downto 0));   
end LCD;

architecture Behavioral of LCD is
constant N: integer :=35; 
type arr1 is array (1 to N) of std_logic_vector(7 downto 0); 
--command and data to display 
constant str : arr1 :=    (X"38",X"0c",X"06",X"01",X"81",X"54",X"45",X"4d",X"50",X"45",X"52",x"41",x"54",x"55",x"52",x"45",x"3a",x"31",x"32",  ----Temperature:12
										x"c1",                                                                                                   ---Go to Next line
										x"4c",x"49",x"47",x"48",x"54",x"20",x"4c",x"45",x"56",x"45",x"4c",x"3a",x"31",x"32",x"33");       ---LIGHT LEVEL:123                                     


begin
process(clk)
variable lcd_clk : integer := 0;
variable data_count : integer := 1;
begin

if clk'event and clk = '1' then
	if lcd_clk <= 1000000 then
		lcd_clk := lcd_clk + 1;
		lcd_e <= '1';           --Send HIGH pulse on RS pin for selecting data register
		if data_count < 18 then
			data <= str(data_count)(7 downto 0);
		elsif data_count = 18 then
			data <= temp_data2;
		elsif data_count = 19 then
			data <=temp_data3;
		elsif data_count > 19 and data_count < 33 then
			data <= str(data_count)(7 downto 0);
		elsif data_count = 33 then
			data <= ldr_data1;
		elsif data_count = 34 then
			data <= ldr_data2;
		elsif data_count = 35 then
			data <= ldr_data3;
		end if;
	elsif lcd_clk > 1000000 and lcd_clk < 2000000 then
		lcd_clk := lcd_clk + 1;
		lcd_e <= '0';         --Send LOW pulse on RS pin for selecting data register
	elsif lcd_clk = 2000000 then
		data_count := data_count + 1;
		lcd_clk := 0;
	end if;
	if data_count <= 5  then
		lcd_rs <= '0';    ---Send LOW pulse for command signal   
	elsif data_count > 5 and data_count < 20 then
		lcd_rs <= '1';   ----Send HIGH pulse for data signal
    elsif data_count = 20 then
		lcd_rs <= '0';   ----Send LOW pulse for command signal
	elsif data_count > 20 and data_count <= 35 then
		lcd_rs <= '1';   ----data signal
	end if;
	if data_count = 36 then  ---repeated display of data
		data_count := 5;
	end if;
end if;

end process;
end Behavioral;
