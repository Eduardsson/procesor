----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2017 10:09:20 PM
-- Design Name: 
-- Module Name: rom_tb - Behavioral
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

entity rom_tb is

end rom_tb;

architecture Behavioral of rom_tb is

component rom is
    Port (  clk : in STD_LOGIC; 
            pc : in STD_LOGIC_VECTOR (15 downto 0);
            inst : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal clk : STD_LOGIC; 
signal pc : STD_LOGIC_VECTOR (15 downto 0);
signal inst : STD_LOGIC_VECTOR (31 downto 0);

constant clock_period: time := 10 ns;
signal stop_the_clock: boolean;

begin


UUT: rom port map (
    clk => clk,
    pc => pc,
    inst => inst
);

stimulus: process
begin

  -- Put initialisation code here

  pc <= x"0000";
  wait for clock_period;
  pc <= x"0001";
  wait for clock_period;
  pc <= x"0002";
  wait for clock_period;
  pc <= x"0003";
  wait for clock_period;
  pc <= x"0004";
  wait for clock_period;
  pc <= x"0005";
  wait for clock_period;
  pc <= x"0006";
  wait for clock_period;
  pc <= x"0007";
  wait for clock_period;
  pc <= x"0008";
  wait for clock_period;


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
