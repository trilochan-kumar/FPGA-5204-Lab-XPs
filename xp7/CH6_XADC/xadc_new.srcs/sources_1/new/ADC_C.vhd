

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 
use IEEE.numeric_std.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADC_C is
    Port (
        clk             : in  STD_LOGIC;
        vauxp2          : in  STD_LOGIC;                         -- Auxiliary Channel 7
        vauxn2          : in  STD_LOGIC;
        vauxp10         : in  STD_LOGIC;                         -- Auxiliary Channel 15
        vauxn10         : in  STD_LOGIC;  
        temp_out: out std_logic_vector(7 downto 0); 
        ldr_out:out std_logic_vector(7 downto 0));
        end ADC_C;
        
 architecture Behavioral of ADC_C is
        component xadc_wiz_0 
           port
           (
              di_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            daddr_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            den_in : IN STD_LOGIC;
            dwe_in : IN STD_LOGIC;
            drdy_out : OUT STD_LOGIC;
            do_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            dclk_in : IN STD_LOGIC;
            vp_in : IN STD_LOGIC;
            vn_in : IN STD_LOGIC;
            vauxp2 : IN STD_LOGIC;
            vauxn2 : IN STD_LOGIC;
            vauxp10 : IN STD_LOGIC;
            vauxn10 : IN STD_LOGIC;
            channel_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            eoc_out : OUT STD_LOGIC;
            alarm_out : OUT STD_LOGIC;
            eos_out : OUT STD_LOGIC;
            busy_out : OUT STD_LOGIC
        );
        end component;
        signal data_adc : std_logic_vector(15 downto 0);
        signal addr_in : std_logic_vector(6 downto 0);
        signal enable, ready : std_logic;
        
        signal temp_out_int:integer range  0 to 200 :=0;
      
        
        signal chsel:integer range  0 to 1 :=0;
      
    
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
            vauxp2 => vauxp2,
            vauxn2 => vauxn2,
            vauxp10 => vauxp10,
            vauxn10 => vauxn10,
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
                if chsel = 0 then
                    addr_in <= "0010010";
                   chsel <= chsel + 1;
                     temp_out_int <= (conv_integer(data_adc(15 downto 4)))*330/4096;
                     temp_out<=conv_std_logic_vector(temp_out_int,8);
                     
                elsif chsel = 1 then
                    addr_in <= "0011010";
                    ldr_out <= ((data_adc(15 downto 8)));
                    chsel <= 0;
                end if;
            end if;
        end if;
        end process;
        
     
end Behavioral;
