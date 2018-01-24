----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2017 07:20:38 PM
-- Design Name: 
-- Module Name: gpio - Behavioral
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

entity gpio is
    Port ( cpu_i : out STD_LOGIC_VECTOR (31 downto 0);
           cpu_o : in STD_LOGIC_VECTOR (31 downto 0);
           write_o : in STD_LOGIC;
           write_t : in STD_LOGIC;
           io : inout STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC);
end gpio;

architecture Behavioral of gpio is

    signal s_cpu_o, s_cpu_o_enable : STD_LOGIC_VECTOR(31 downto 0) := (others => '1');

begin

    io(0) <= s_cpu_o(0) when s_cpu_o_enable(0) = '0' else 'Z';
    io(1) <= s_cpu_o(1) when s_cpu_o_enable(1) = '0' else 'Z';
    io(2) <= s_cpu_o(2) when s_cpu_o_enable(2) = '0' else 'Z';
    io(3) <= s_cpu_o(3) when s_cpu_o_enable(3) = '0' else 'Z';
    io(4) <= s_cpu_o(4) when s_cpu_o_enable(4) = '0' else 'Z';
    io(5) <= s_cpu_o(5) when s_cpu_o_enable(5) = '0' else 'Z';
    io(6) <= s_cpu_o(6) when s_cpu_o_enable(6) = '0' else 'Z';
    io(7) <= s_cpu_o(7) when s_cpu_o_enable(7) = '0' else 'Z';
    io(8) <= s_cpu_o(8) when s_cpu_o_enable(8) = '0' else 'Z';
    io(9) <= s_cpu_o(9) when s_cpu_o_enable(9) = '0' else 'Z';
    io(10) <= s_cpu_o(10) when s_cpu_o_enable(10) = '0' else 'Z';
    io(11) <= s_cpu_o(11) when s_cpu_o_enable(11) = '0' else 'Z';
    io(12) <= s_cpu_o(12) when s_cpu_o_enable(12) = '0' else 'Z';
    io(13) <= s_cpu_o(13) when s_cpu_o_enable(13) = '0' else 'Z';
    io(14) <= s_cpu_o(14) when s_cpu_o_enable(14) = '0' else 'Z';
    io(15) <= s_cpu_o(15) when s_cpu_o_enable(15) = '0' else 'Z';
    io(16) <= s_cpu_o(16) when s_cpu_o_enable(16) = '0' else 'Z';
    io(17) <= s_cpu_o(17) when s_cpu_o_enable(17) = '0' else 'Z';
    io(18) <= s_cpu_o(18) when s_cpu_o_enable(18) = '0' else 'Z';
    io(19) <= s_cpu_o(19) when s_cpu_o_enable(19) = '0' else 'Z';
    io(20) <= s_cpu_o(20) when s_cpu_o_enable(20) = '0' else 'Z';
    io(21) <= s_cpu_o(21) when s_cpu_o_enable(21) = '0' else 'Z';
    io(22) <= s_cpu_o(22) when s_cpu_o_enable(22) = '0' else 'Z';
    io(23) <= s_cpu_o(23) when s_cpu_o_enable(23) = '0' else 'Z';
    io(24) <= s_cpu_o(24) when s_cpu_o_enable(24) = '0' else 'Z';
    io(25) <= s_cpu_o(25) when s_cpu_o_enable(25) = '0' else 'Z';
    io(26) <= s_cpu_o(26) when s_cpu_o_enable(26) = '0' else 'Z';
    io(27) <= s_cpu_o(27) when s_cpu_o_enable(27) = '0' else 'Z';
    io(28) <= s_cpu_o(28) when s_cpu_o_enable(28) = '0' else 'Z';
    io(29) <= s_cpu_o(29) when s_cpu_o_enable(29) = '0' else 'Z';
    io(30) <= s_cpu_o(30) when s_cpu_o_enable(30) = '0' else 'Z';
    io(31) <= s_cpu_o(31) when s_cpu_o_enable(31) = '0' else 'Z';

    process(clk)
    begin
    if rising_edge(clk) then
        if rst='1' then
            s_cpu_o <= (others => '1');
            s_cpu_o_enable <= (others => '1');
        elsif write_o='1' then
            s_cpu_o <= cpu_o;
        elsif write_t='1' then
            s_cpu_o_enable <= cpu_o;
        end if;
        cpu_i <= io;
    end if;
    end process;



end Behavioral;
