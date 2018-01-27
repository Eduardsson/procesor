----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2017 07:20:38 PM
-- Design Name: 
-- Module Name: rom - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity rom is
    Port (
        pc : in STD_LOGIC_VECTOR (15 downto 0);
        inst : out STD_LOGIC_VECTOR (31 downto 0)
    );
end rom;

architecture behavioral of rom is

    -- Rom data type
    type rom_type is array (1024 downto 0) of std_logic_vector (31 downto 0);
    
    -- load memory from file
    impure function InitRomFromFile (RomFileName : in string) return rom_type is
        FILE romfile : text is in RomFileName;
        variable RomFileLine : line;
        variable rom : rom_type;
        begin
            for i in rom_type'range loop
                readline(romfile, RomFileLine);
                hread(RomFileLine, rom(1024 - i));
            end loop;
        return rom;
    end function;
    
    constant rom : rom_type := InitRomFromFile("programs/rom.delay.data");
    
begin

    inst <= rom (conv_integer(pc));
    
end behavioral;