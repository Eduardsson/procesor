----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/20/2018 05:05:54 PM
-- Design Name: 
-- Module Name: decoder_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder_tb is
--  Port ( );
end decoder_tb;

architecture Behavioral of decoder_tb is

    component decoder is
        Port ( inst : in STD_LOGIC_VECTOR (31 downto 0);
               clk : in STD_LOGIC;
               addr_1 : out STD_LOGIC_VECTOR (4 downto 0);
               addr_2 : out STD_LOGIC_VECTOR (4 downto 0);
               data_inst : out STD_LOGIC_VECTOR (15 downto 0);
               mux_c : out STD_LOGIC_VECTOR (2 downto 0);
               alu_c : out STD_LOGIC_VECTOR (4 downto 0);
               write_en : out STD_LOGIC_VECTOR (2 downto 0);
               jump_en : out STD_LOGIC;
               pc_en : out STD_LOGIC);
    end component;


    signal inst : STD_LOGIC_VECTOR (31 downto 0);
    signal clk : STD_LOGIC;
    signal addr_1 : STD_LOGIC_VECTOR (4 downto 0);
    signal addr_2 : STD_LOGIC_VECTOR (4 downto 0);
    signal data_inst : STD_LOGIC_VECTOR (15 downto 0);
    signal mux_c : STD_LOGIC_VECTOR (2 downto 0);
    signal alu_c : STD_LOGIC_VECTOR (4 downto 0);
    signal write_en : STD_LOGIC_VECTOR (2 downto 0);
    signal jump_en : STD_LOGIC;
    signal pc_en : STD_LOGIC;

    constant clock_period: time := 10 ns;
    signal stop_the_clock: boolean;

begin

    decoder_module: decoder port map (
        inst => inst,
        clk => clk,
        addr_1 => addr_1,
        addr_2 => addr_2,
        data_inst => data_inst,
        mux_c => mux_c,
        alu_c => alu_c,
        write_en => write_en,
        jump_en => jump_en,
        pc_en => pc_en
    );


stimulus: process
begin

  -- Put initialisation code here

  inst <= "11100000001001011011000000000000";

  wait for clock_period;

  wait for clock_period;

  inst <= "11100001001010011011000000000000";

  wait for clock_period;
  wait for clock_period;
  wait for clock_period;
  
  --AND
  inst <= "11100000001010000100100000000011";
  
  wait for clock_period;
  wait for clock_period;
  wait for clock_period;
  --ANDI
  inst <= "10100101111100001010101011111100";
    
  wait for clock_period;
  wait for clock_period;
  wait for clock_period;
    
  --OR  
  inst <= "11100000001010000100100000000100";
      
  wait for clock_period;
  wait for clock_period;
  wait for clock_period;
  --ORI    
  inst <= "10101001001010011011000000000000";
      
  wait for clock_period;
  wait for clock_period;
  wait for clock_period;
        
  --NOP      
  inst <= "00010101000000000000000000000100";
          
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