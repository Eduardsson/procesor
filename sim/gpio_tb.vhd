----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/21/2018 02:14:23 PM
-- Design Name: 
-- Module Name: gpio_tb - Behavioral
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

entity gpio_tb is
--  Port ( );
end gpio_tb;

architecture Behavioral of gpio_tb is

    component gpio is
        Port ( cpu_i : out STD_LOGIC_VECTOR (31 downto 0);
               cpu_o : in STD_LOGIC_VECTOR (31 downto 0);
               write_o : in STD_LOGIC;
               write_t : in STD_LOGIC;
               io : inout STD_LOGIC_VECTOR (31 downto 0);
               clk : in STD_LOGIC;
               rst : in STD_LOGIC);
    end component;

    signal cpu_i : STD_LOGIC_VECTOR (31 downto 0);
    signal cpu_o : STD_LOGIC_VECTOR (31 downto 0);
    signal write_o : STD_LOGIC;
    signal write_t : STD_LOGIC;
    signal io : STD_LOGIC_VECTOR (31 downto 0);
    signal clk : STD_LOGIC;
    signal rst : STD_LOGIC;


    constant clock_period: time := 10 ns;
    signal stop_the_clock: boolean;

begin

    gpio_module: gpio port map  (
        cpu_i => cpu_i,
        cpu_o => cpu_o,
        write_o => write_o,
        write_t => write_t,
        io => io,
        clk => clk,
        rst => rst
    );


    stimulus: process
    begin

        rst <= '0';

        cpu_o <= "00000000000000000000000000000000";
    
      -- Put initialisation code here

      wait for clock_period;

      write_o <= '1';

      wait for clock_period;

      write_o <= '0';

      wait for clock_period;

      cpu_o <= "00000000000000011111111111111111";

      write_t <= '1';

      wait for clock_period;

      write_t <= '0';

      wait for clock_period;

      cpu_o <= "11111111100000000000000001111111";

      write_o <= '1';

      wait for clock_period;

      write_o <= '0';

      wait for 20*clock_period;
    
      -- Put test bench stimulus code here
    
      stop_the_clock <= true;
      wait;
    end process;
    
    clocking: process
    begin
      while not stop_the_clock loop
        clk <= '0', '1' after clock_period / 2;
        wait for clock_period;
      end loop;
      wait;
    end process;
    
    
    end Behavioral;