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

begin


end Behavioral;
