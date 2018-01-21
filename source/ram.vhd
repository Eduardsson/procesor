----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Richard Kuckovsky
-- 
-- Create Date: 19/01/2018 17:13:37 PM
-- Design Name: 
-- Module Name: ram - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    port (clk : in std_logic;
          write_en  : in std_logic;
          addr   : in std_logic_vector(4 downto 0);
          data_in  : in std_logic_vector(31 downto 0);
          data_out  : out std_logic_vector(31 downto 0));
end ram;

architecture syn of ram is
    type ram_type is array (31 downto 0) of std_logic_vector (31 downto 0);
    signal RAM : ram_type;
begin

    process (clk)
    begin
        if (clk'event and clk = '1') then
            if (write_en = '1') then
                RAM(to_integer(unsigned(addr))) <= data_in;
            end if;
            data_out <= RAM(to_integer(unsigned(addr)));
        end if;
    end process;

    

end syn;