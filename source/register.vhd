----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2017 07:20:38 PM
-- Design Name: 
-- Module Name: reg_field - Behavioral
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

entity reg_field is
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
end reg_field;

architecture Behavioral of reg_field is

    signal data_ram : STD_LOGIC_VECTOR (31 downto 0);

    component ram is
        port (clk : in std_logic;
              write_en  : in std_logic;
              addr   : in std_logic_vector(4 downto 0);
              data_in  : in std_logic_vector(31 downto 0);
              data_out  : out std_logic_vector(31 downto 0));
    end component;

begin

    ram_module_1: ram port map (
        clk => clk,
        write_en => write_r,
        addr => addr_1,
        data_in => data_alu,
        data_out => reg_1
    );

    ram_module_2: ram port map (
        clk => clk,
        write_en => write_r,
        addr => addr_2,
        data_in => data_alu,
        data_out => data_ram
    );

    reg_2 <= data_ram WHEN mux_c ="000" ELSE
             data_ram WHEN mux_c ="001" ELSE
             "0000000000000000" & data_inst WHEN mux_c ="010" ELSE
             data_g WHEN mux_c ="100" ELSE
             (others => '0');

    reg_g <= data_alu WHEN mux_c ="000" ELSE
             "0000000000000000" & data_inst WHEN mux_c ="001" ELSE
             data_alu WHEN mux_c ="010" ELSE
             data_alu WHEN mux_c ="100" ELSE
             (others => '0');


end Behavioral;
