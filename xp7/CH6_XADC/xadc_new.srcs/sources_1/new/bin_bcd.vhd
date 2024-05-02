----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/01/2020 10:55:04 AM
-- Design Name: 
-- Module Name: Binary_to_bcd - Behavioral
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

entity Binary_to_bcd is
  Port (
       clk : in std_logic;
       binary_in : in  std_logic_vector(7 downto 0);
       bcd0,bcd1,bcd2: out std_logic_vector(7 downto 0)
   );
end Binary_to_bcd;

architecture Behavioral of Binary_to_bcd is
signal state : std_logic_vector(2 downto 0):="000";
signal bin :  std_logic_vector(7 downto 0);
signal hudreds,tens,ones :  std_logic_vector(7 downto 0);
begin
process (clk)

begin

if rising_edge(clk) then
state <= state + 1;
----Binary to BCD convertion
case state is
   ---set 100's, 10's and 1's to 0
    when "000" =>         
            bin <= binary_in;
            hudreds <= "00000000";
            tens <= "00000000";
            ones <= "00000000";
            
    when "001" =>
        if (bin >= "1100100") then   ---compare the given binary value is greater than 100
            bin <= bin - "1100100";
            hudreds <= hudreds + 1;
            state <= "001";
        elsif (bin >= "1010") then   ---compare the given binary value is greater than 10
            bin <= bin - "1010";
            tens <= tens + 1;
            state <= "001";
        else
            ones <= bin;   --- the binary value is ones
        end if;
 ----Add x"30" to convert bcd to ASCII       
    when "010" =>            
         bcd0 <=  hudreds+ X"30";
         bcd1 <=  tens+X"30";
         bcd2 <=  ones+X"30";
    when others =>
        state <= "000";
end case;
end if;
end process;
        

end Behavioral;
