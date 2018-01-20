----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jan Jendrusak
-- 
-- Create Date: 12/10/2017 07:20:38 PM
-- Design Name: 
-- Module Name: program_counter - Behavioral
-- Project Name: processor
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.1 - First iteration of working module
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity program_counter is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           jump_en : in STD_LOGIC;
           pc_en : in STD_LOGIC;
           jump_addr : in STD_LOGIC_VECTOR (15 downto 0);
           pc : out STD_LOGIC_VECTOR (15 downto 0) );
end program_counter;

architecture Behavioral of program_counter is

signal pc_int: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

begin

process (clk, pc_en, jump_en)
    begin
        if (clk'event and clk='1') then
          if (rst='1') then
            pc_int <= (others => '0');
          elsif jump_en='1' then
            pc_int <= jump_addr;
          elsif pc_en='1' then
            pc_int <= pc_int + 1;
          end if;
        end if;
    end process;

    pc <= pc_int;


end Behavioral;
