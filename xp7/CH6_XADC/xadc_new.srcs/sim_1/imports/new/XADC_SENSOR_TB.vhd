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
  COMPONENT xadc_wiz_0
  PORT (
    di_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    daddr_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    den_in : IN STD_LOGIC;
    dwe_in : IN STD_LOGIC;
    drdy_out : OUT STD_LOGIC;
    do_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    dclk_in : IN STD_LOGIC;
    vp_in : IN STD_LOGIC;
    vn_in : IN STD_LOGIC;
    vauxp7 : IN STD_LOGIC;
    vauxn7 : IN STD_LOGIC;
    vauxp15 : IN STD_LOGIC;
    vauxn15 : IN STD_LOGIC;
    channel_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    eoc_out : OUT STD_LOGIC;
    alarm_out : OUT STD_LOGIC;
    eos_out : OUT STD_LOGIC;
    busy_out : OUT STD_LOGIC
  );
END COMPONENT;
   signal di_in :  STD_LOGIC_VECTOR(15 DOWNTO 0);
  signal  daddr_in :  STD_LOGIC_VECTOR(6 DOWNTO 0);
  signal  den_in :  STD_LOGIC;
  signal  dwe_in :  STD_LOGIC;
   signal drdy_out :  STD_LOGIC;
   signal do_out :  STD_LOGIC_VECTOR(15 DOWNTO 0);
   signal dclk_in :  STD_LOGIC;
   signal vp_in :  STD_LOGIC;
   signal vn_in :  STD_LOGIC;
   signal vauxp7 :  STD_LOGIC;
   signal vauxn7 :  STD_LOGIC;
   signal vauxp15 :  STD_LOGIC;
   signal vauxn15 :  STD_LOGIC;
    signal channel_out :  STD_LOGIC_VECTOR(4 DOWNTO 0);
  signal  eoc_out :  STD_LOGIC;
   signal alarm_out :  STD_LOGIC;
  signal  eos_out :  STD_LOGIC;
   signal busy_out :  STD_LOGIC;
     constant clk_period : time := 20 ns;
begin

XADC:xadc_wiz_0 
port map(
           di_in => (others => '0'),
            daddr_in =>channel_out,
            den_in =>eos_out,
            dwe_in =>'0',
            drdy_out =>drdy_out,
            do_out => do_out,
            dclk_in=>dclk_in,
            vp_in =>vp_in,
            vn_in =>vn_in,
            vauxp7=>vauxp7,
            vauxn7=>vauxn7,
            vauxp15=>vauxp15,
            vauxn15 =>vauxn15,
            channel_out =>channel_out,
            eoc_out =>eoc_out,
            alarm_out =>alarm_out,
            eos_out  =>eos_out,
            busy_out =>busy_out);
            
            clk_process :process
   begin
        dclk_in <= '0';
        wait for clk_period/2;
        dclk_in <= '1';
        wait for clk_period/2;
   end process;
    --- Stimulus process
   stim_proc: process
   begin
    

       wait for 500ns ;
    end process;

end Behavioral;
