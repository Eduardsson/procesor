----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/20/2018 02:51:47 PM
-- Design Name: 
-- Module Name: reg_tb - Behavioral
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

entity reg_tb is
--  Port ( );
end reg_tb;

architecture Behavioral of reg_tb is

    component reg_field is
        Port ( addr_1 : in STD_LOGIC_VECTOR (4 downto 0);
               addr_2 : in STD_LOGIC_VECTOR (4 downto 0);
               data_inst : in STD_LOGIC_VECTOR (15 downto 0);
               data_g : in STD_LOGIC_VECTOR (31 downto 0);
               data_alu : in STD_LOGIC_VECTOR (31 downto 0);
               mux_c : in STD_LOGIC_VECTOR (2 downto 0);
               write_r : in STD_LOGIC;
               clk : in STD_LOGIC;
               reg_1 : out STD_LOGIC_VECTOR (31 downto 0);
               reg_2 : out STD_LOGIC_VECTOR (31 downto 0);
               reg_g : out STD_LOGIC_VECTOR (31 downto 0));
    end component;

    signal clk : STD_LOGIC; 
    constant clock_period: time := 10 ns;
    signal stop_the_clock: boolean;

    signal addr_1 : STD_LOGIC_VECTOR (4 downto 0);
    signal addr_2 : STD_LOGIC_VECTOR (4 downto 0);
    signal data_inst : STD_LOGIC_VECTOR (15 downto 0);
    signal data_g : STD_LOGIC_VECTOR (31 downto 0);
    signal data_alu : STD_LOGIC_VECTOR (31 downto 0);
    signal mux_c : STD_LOGIC_VECTOR (2 downto 0);
    signal write_r : STD_LOGIC;
    signal reg_1 : STD_LOGIC_VECTOR (31 downto 0);
    signal reg_2 : STD_LOGIC_VECTOR (31 downto 0);
    signal reg_g : STD_LOGIC_VECTOR (31 downto 0);

begin

    reg_field_module: reg_field port map (
        addr_1 => addr_1,
        addr_2 => addr_2,
        data_inst => data_inst,
        data_g => data_g,
        data_alu => data_alu,
        mux_c => mux_c,
        write_r => write_r,
        clk => clk,
        reg_1 => reg_1,
        reg_2 => reg_2,
        reg_g => reg_g
    );

    stimulus: process
    begin

        addr_1 <= "00000";
        addr_2 <= "00000";
        data_inst <= x"0000";
        data_g <= x"0000_0000";
        data_alu <= x"0000_0000";
        mux_c <= "000";
        write_r <= '0';

        wait for clock_period;

        data_alu <= x"0000_0009";
        write_r <= '1';

        wait for clock_period;

        write_r <= '0';
        addr_1 <= "00001";
        addr_2 <= "00001";

        wait for clock_period;

        data_alu <= x"0000_0099";
        write_r <= '1';

        wait for clock_period;

        addr_1 <= "00000";
        write_r <= '0';

        wait for clock_period;

        mux_c <= "010";

        wait for clock_period;

        mux_c <= "100";

        wait for clock_period;

        data_g <= x"0000_9000";


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