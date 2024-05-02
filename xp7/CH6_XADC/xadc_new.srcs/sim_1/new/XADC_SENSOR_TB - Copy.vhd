----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/03/2020 05:27:50 PM
-- Design Name: 
-- Module Name: XADC_SENSOR - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity XADC_SENSOR is
--  Port ( );
end XADC_SENSOR;

architecture Behavioral of XADC_SENSOR is
component sensor_out is
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
        lcd_e           : out std_logic;                         ----enable control
        lcd_rs          : out std_logic;                         ----data or command control
        data            : out std_logic_vector(7 downto 0)       ---data line
);
end component;
    signal clk             :   STD_LOGIC;
     signal   vauxp6          :   STD_LOGIC;                         -- Auxiliary Channel 6
    signal    vauxn6          :   STD_LOGIC;
    signal    vauxp7          :   STD_LOGIC;                         -- Auxiliary Channel 7
    signal    vauxn7          :   STD_LOGIC;
     signal   vauxp14         :   STD_LOGIC;                         -- Auxiliary Channel 14
    signal    vauxn14         :   STD_LOGIC;
    signal    vauxp15         :   STD_LOGIC;                         -- Auxiliary Channel 15
     signal   vauxn15         :   STD_LOGIC;   
      signal  lcd_e           :  std_logic;                         ----enable control
     signal   lcd_rs          :  std_logic;                         ----data or command control
     signal   data            :  std_logic_vector(7 downto 0) ;     ---data line
     constant clk_period : time := 20 ns;
begin

UUT:sensor_out port map(
    clk => clk,  
          vauxp6 => vauxp6,
          vauxn6 => vauxn6, 
          vauxp7 => vauxp7,
          vauxn7 => vauxn7,  
          vauxp14 => vauxp14,
          vauxn14 => vauxn14, 
          vauxp15 => vauxp15,
          vauxn15 => vauxn15,   
          lcd_e => lcd_e,
          lcd_rs => lcd_rs,
          data => data );
            clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;
    --- Stimulus process
   stim_proc: process
   begin
    

       wait for 500ns ;
    end process;

end Behavioral;
