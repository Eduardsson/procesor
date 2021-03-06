----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/20/2018 06:09:19 PM
-- Design Name: 
-- Module Name: top_tb - Behavioral
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

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is

    component top is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               dp : out STD_LOGIC;
               an : out STD_LOGIC_VECTOR (3 downto 0);
               segm : out STD_LOGIC_VECTOR (6 downto 0);
               pins : inout STD_LOGIC_VECTOR (31 downto 0));
    end component;

    signal clk : STD_LOGIC;
    signal rst : STD_LOGIC;
    signal dp : STD_LOGIC;
    signal an :  STD_LOGIC_VECTOR (3 downto 0);
    signal segm : STD_LOGIC_VECTOR (6 downto 0);
    signal pins : STD_LOGIC_VECTOR (31 downto 0);

    constant clock_period: time := 10 ns;
    signal stop_the_clock: boolean;

begin

    TP: top port map (
        clk => clk,
        rst => rst,
        dp => dp,
        an => an,
        segm => segm,
        pins => pins
    );


    stimulus: process
    begin

        rst <= '0';

        pins(15 downto 0) <= (others => '1');

        pins(1 downto 0) <= (others => '0');
    
      -- Put initialisation code here

      wait for 100*clock_period;
        pins(15 downto 0) <= x"4510";
        wait for 100*clock_period;
      -- Put test bench stimulus code here
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
    