----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jan Jendrusak
-- 
-- Create Date: 01/26/2018 07:32:41 PM  
-- Design Name: 
-- Module Name: alu - Behavioral
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

entity display_driver is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           write_dr  : in STD_LOGIC;
           disp_number: in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           segm : out STD_LOGIC_VECTOR (6 downto 0));
end display_driver;

architecture Behavioral of display_driver is
    
    signal clk_1kHz : STD_LOGIC;
    signal curr_an : STD_LOGIC_VECTOR (3 downto 0) := "1111";
    signal curr_dig : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal segm_curr: STD_LOGIC_VECTOR (6 downto 0) ;
    signal en_number: STD_LOGIC_VECTOR (15 downto 0) ;
    signal en_disp: STD_LOGIC := '0';

    component multiplexing is
        Port (clk_1kHz, rst: in STD_LOGIC;
                an: out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    component divider_1kHz is
        Port ( clk : in STD_LOGIC;
               clk_1kHz : out STD_LOGIC);
    
    end component;

    component digit is
        Port( nibble : in STD_LOGIC_VECTOR(3 downto 0);
                segm : out STD_LOGIC_VECTOR(6 downto 0));
    end component;

begin

    multiplexing_module: multiplexing port map (
            rst => rst,
            clk_1kHz => clk_1kHz,
            an => curr_an
        );

    divider_1kHz_module: divider_1kHz port map (
        clk => clk,
        clk_1kHz => clk_1kHz
    );

    digit_module: digit port map (
        nibble => curr_dig,
        segm => segm_curr
    );

    with curr_an select
        curr_dig <= en_number(15 downto 12) when "0111",
                    en_number(11 downto 8)  when "1011",
                    en_number(7 downto 4)   when "1101",
                    en_number(3 downto 0)   when "1110",
                    x"0"                    when others;
    an <= curr_an;

    EN_PROC: process(clk, write_dr)
    begin
        if(clk = '1' and clk'event and write_dr = '1') then
            en_disp <= '1';
            en_number <= disp_number;
        else
            en_disp <= en_disp;
        end if;
    end process;

    segm <= segm_curr when en_disp = '1' else
            "1111111";
        
end Behavioral;