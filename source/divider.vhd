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
use IEEE.NUMERIC_STD.ALL;


entity divider_1kHz is
    PORT (
        clk : in STD_LOGIC;
        clk_1kHz : out STD_LOGIC
    );
end divider_1kHz;

architecture Behavioral of divider_1kHz is

    signal cnt_int : STD_LOGIC_VECTOR (16 downto 0) := (others => '0');
    
begin

    DIV_COUNTER : process(clk)
    begin
        if (clk = '1' and clk'event) then
            if (cnt_int = "11000011010011111") then
                cnt_int <= "00000000000000000";
                clk_1kHz <= '0';
            else
                if (cnt_int < "01100001101010000") then
                    clk_1kHz <= '0';
                else
                    clk_1kHz <= '1';
                end if;
                cnt_int <=  std_logic_vector(unsigned(cnt_int) + 1);
            end if;
        end if;
    end process;

end Behavioral;

