----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:24:46 12/26/2018 
-- Design Name: 
-- Module Name:    UART - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity WIFI is
Port (      	clk 	: in  STD_LOGIC;                    ---clock signal
				txd 	: out  STD_LOGIC;                   ---transmitter data
				temp_data1,temp_data2,temp_data3: in std_logic_vector(7 downto 0); 
				ldr_data1,ldr_data2,ldr_data3:in std_logic_vector(7 downto 0));
end WIFI;

architecture Behavioral of WIFI is
type state_type is (ready,start,stop);   ----- Define the states
signal state :state_type := ready;    -- Create a signal that uses the different states
							      
signal store :std_logic_vector(7 downto 0);
signal baud_clk : std_logic; ---9600 baud rate


type arr is array (1 to 182) of std_logic_vector(7 downto 0); 
constant str :  arr :=  ( X"41",X"41",X"54",X"2b",X"52",X"53",X"54",X"0d",X"0a", --9 AT+RST

 x"41",x"54",x"2b",x"43",x"57",x"4d",x"4f",x"44",x"45",x"3d",x"31",X"0d",X"0a", --13  AT+CWMODE=1

 x"41",x"54",x"2b",x"43",x"57",x"4a",x"41",x"50",x"3d",x"22",x"57",x"49",x"46",x"49",x"4e",x"41",x"4d",x"45",x"22",x"2c",x"22",x"50",
 x"41",x"53",x"53",x"57",x"4f",x"52",x"44",x"22",X"0d",X"0a", --32  AT+CWJAP="WIFINAME","PASSWORD"

 X"41",X"54",X"2b",X"43",X"49",X"50",X"53",X"54",X"41",X"52",X"54",X"3D",X"22",X"54",X"43",X"50",X"22",X"2C",X"22",
 X"31",X"38",X"34",X"2E",X"31",X"30",X"36",X"2E",X"31",X"35",X"33",X"2E",X"31",X"34",X"39",X"22",X"2C",X"38",X"30",X"0d",X"0a",  --40      ---AT+CIPSTART="TCP","184.106.153.149",80


 X"41",X"54",X"2b",X"43",X"49",X"50",X"53",X"45",X"4e",X"44",X"3d",X"36",X"30",X"0d",X"0a", --15			---AT+CIPSEND=60
 
 X"47",X"45",X"54",X"20",X"2F",X"75",X"70",X"64",X"61",X"74",X"65",X"3F",X"61",X"70",X"69",X"5F",X"6B",X"65",X"79",X"3D",  
 X"46", X"42", X"36", X"4a", X"33",X"33",X"4f",X"34",X"46",X"4b",X"52",X"36",X"56",X"38",X"4f",X"43",  --FB6J33O4FKR6V8OC

 X"26",X"66",X"69",X"65",X"6C",X"64",X"31",X"3D",X"30",X"31",X"31",X"26",X"66",X"69",X"65",X"6C",X"64",X"32",X"3D",X"30",X"31",X"31",X"0d",X"0a", --60  --GET /update?api_key=FB6J33O4FKR6V8OC&field1=000&field2=000
 
 X"41",X"54",X"2b",X"43",X"49",X"50",X"43",X"4c",X"4f",X"53",X"45",X"0d",X"0a"); --13




begin
process(clk)
---------------------50 x 10^6 / 16*115200 = 27
--------------------baud clock counter
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
variable data_len,end_delay : integer := 0;
variable tx_data : integer := 1;
begin
    if rising_edge(baud_clk)then
    -- The CASE statement checks the value of the State variable,
	-- and based on the value and any other control signals, changes
	-- to a new state
        if state = ready then        
        data_len := data_len + 1;	
            if data_len = 8 then  ---Transmitting 8 bit data
                    txd <= '0';
                    data_len := 0;
                    state <= start;        -- next state is start
             end if;
       end if;
---------------------16xbaudrate sampling mathod---------------------------
---if the current state state
        if state = start then
        data_len := data_len + 1;
        
            if tx_data = 154 then
            
            store <= temp_data1;
            elsif tx_data = 155 then
            store <= temp_data2;
            elsif tx_data = 156 then
            store <=temp_data3;
            elsif tx_data = 165 then
            store <= ldr_data1;
            elsif tx_data = 166 then
            store <= ldr_data2;
            elsif tx_data = 167 then
            store <= ldr_data3;
            else
            store <= str(tx_data)(7 downto 0);
            end if;
            
                if data_len = 16 then
                txd <= store(0);
                end if;
                
                if data_len = 32 then
                txd <= store(1);
                end if;
                
                if data_len = 48 then
                txd <= store(2);
                end if;
                
                if data_len = 64 then
                txd <= store(3);
                end if;
                
                if data_len = 80 then
                txd <= store(4);
                end if;
                
                if data_len = 96 then
                txd <= store(5);
                end if;
                
                if data_len = 112 then
                txd <= store(6);
                end if;
                
                if data_len = 128 then
                txd <= store(7);
                end if;
                
                if data_len = 144 then
                txd <= '1';
                end if;
                
                if data_len = 160 then
                data_len := 0;
                state <= stop;
                end if;
                
                elsif state = stop then
                if tx_data = 9 then
                    state <= stop;
                    end_delay := end_delay + 1;
                        if end_delay = 20000000 then
                        tx_data := tx_data + 1;
                        end_delay := 0;
                        state <= ready;
                        end if;
                elsif tx_data = 22 then
                    state <= stop;
                    end_delay := end_delay + 1;
                        if end_delay = 5000000 then
                        tx_data := tx_data + 1;
                        end_delay := 0;
                        state <= ready;
                        end if;
                elsif tx_data = 54 then
                        state <= stop;
                        end_delay := end_delay + 1;
                         if end_delay = 20000000 then
                         tx_data := tx_data + 1;
                         end_delay := 0;
                         state <= ready;
                         end if;
                 elsif tx_data = 94 then
                    state <= stop;
                    end_delay := end_delay + 1;
                        if end_delay = 5000000 then
                        tx_data := tx_data + 1;
                        end_delay := 0;
                        state <= ready;
                        end if;
                elsif  tx_data = 109 then
                    state <= stop;
                    end_delay := end_delay + 1;
                        if end_delay = 5000000 then
                        tx_data := tx_data + 1;
                        end_delay := 0;
                        state <= ready;
                        end if;
                elsif  tx_data = 169 then
                    state <= stop;
                    end_delay := end_delay + 1;
                        if end_delay = 10000000 then
                        tx_data := 53;
                        end_delay := 0;
                        state <= ready;
                        end if;
                elsif tx_data = 182 then
                    state <= stop;
                    end_delay := end_delay + 1;
                        if end_delay = 5000000 then
                        end_delay := 0;
                        tx_data := 53;	
                        state <= ready;
                        end if;
                else
                    tx_data := tx_data + 1;
                    state <= ready;
           end if;
        
        
        end if;
end if;
end process;
end Behavioral;