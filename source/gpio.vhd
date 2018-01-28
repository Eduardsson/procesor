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
    GENERIC (
        data_B : INTEGER
    );
    PORT (
        cpu_i : out STD_LOGIC_VECTOR (data_B downto 0);
        cpu_o : in STD_LOGIC_VECTOR (data_B downto 0);
        write_o : in STD_LOGIC;
        write_t : in STD_LOGIC;
        io : inout STD_LOGIC_VECTOR (data_B downto 0);
        clk : in STD_LOGIC;
        rst : in STD_LOGIC
    );
end gpio;

architecture Behavioral of gpio is

    signal s_cpu_o, s_cpu_o_enable : STD_LOGIC_VECTOR(data_B downto 0) := (others => '1');

begin

    generate_for: for i in 0 to data_B generate
        io(i) <= s_cpu_o(i) when s_cpu_o_enable(i) = '0' else 'Z';
    end generate generate_for;

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
