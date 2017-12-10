----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jan Jendrusak
-- 
-- Create Date: 12/10/2017 07:20:38 PM
-- Design Name: 
-- Module Name: program_counter_tb
-- Project Name: processor
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.1 - testcase covering basic requirements for program_counter module
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.Std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity program_counter_tb is
end;

architecture bench of program_counter_tb is

  component program_counter
      Port ( clk : in STD_LOGIC;
             rst : in STD_LOGIC;
             jump_en : in STD_LOGIC;
             pc_en : in STD_LOGIC;
             jump_addr : in STD_LOGIC_VECTOR (15 downto 0);
             pc : out STD_LOGIC_VECTOR (15 downto 0));
  end component;

  signal clk: STD_LOGIC;
  signal rst: STD_LOGIC;
  signal jump_en: STD_LOGIC;
  signal pc_en: STD_LOGIC;
  signal jump_addr: STD_LOGIC_VECTOR (15 downto 0);
  signal pc: STD_LOGIC_VECTOR (15 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: program_counter port map ( clk       => clk,
                                  rst       => rst,
                                  jump_en   => jump_en,
                                  pc_en     => pc_en,
                                  jump_addr => jump_addr,
                                  pc        => pc );

  stimulus: process
  begin
  
    -- Put initialisation code here
    rst <= '0';
    pc_en <='0';
    jump_en <= '0';
    
    
    wait for clock_period;
    --enabling counter
    pc_en <='1';
    wait for 90 ns;
    jump_addr<=x"FF_FA";
    wait for 10 ns;
    jump_en<='1';
    --after jump_en counter should jump into jump_addr
    wait for 10 ns;
    jump_en<='0';
    wait for 100 ns;
    --starting from the bottom
    rst<='1';
    wait for 50 ns;
    rst<='0';
    wait for 20 ns;
    

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

end;