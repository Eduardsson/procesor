library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity display_driver_tb is
end;

architecture bench of display_driver_tb is

  component display_driver
      Port ( clk : in STD_LOGIC;
             rst : in STD_LOGIC;
             disp_number: in STD_LOGIC_VECTOR (15 downto 0);
             an : out STD_LOGIC_VECTOR (3 downto 0);
             segm : out STD_LOGIC_VECTOR (6 downto 0));
  end component;

  signal clk: STD_LOGIC;
  signal rst: STD_LOGIC;
  signal disp_number: STD_LOGIC_VECTOR (15 downto 0);
  signal an: STD_LOGIC_VECTOR (3 downto 0);
  signal segm: STD_LOGIC_VECTOR (6 downto 0);
  
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: display_driver port map ( clk         => clk,
                                 rst         => rst,
                                 disp_number => disp_number,
                                 an          => an,
                                 segm        => segm );

  stimulus: process
  begin
  
    -- Put initialisation code here
    rst <= '1';
    disp_number <= x"0000";

    -- Put test bench stimulus code here
    wait for clock_period;

    rst <= '0';
    disp_number <= x"CAFE";
    
    
    
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    wait for clock_period;
    
    
      -- Put test bench stimulus code here
    
     --stop_the_clock <= true;
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
