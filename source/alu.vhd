----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jan Jendrusak
-- 
-- Create Date: 12/10/2017 07:20:38 PM
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
-- Revision 0.1 - maybe change of logical shift? also conditional bit for CMOV is the MSB in alu_c now and 5 bits for alu_c are still free 
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ieee.std_logic_signed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( reg_1 : in STD_LOGIC_VECTOR (31 downto 0);
           reg_2 : in STD_LOGIC_VECTOR (31 downto 0);
           alu_c : in STD_LOGIC_VECTOR (4 downto 0);
           result_alu : out STD_LOGIC_VECTOR (31 downto 0));
end alu;

architecture Behavioral of alu is  
        
begin
    
    process(alu_c, reg_1, reg_2)
        --variable shift : std_logic_vector(2 downto 0);
    begin
        -- plus - good
        if (alu_c(3 downto 0) = x"1") then
            result_alu <= std_logic_vector(signed(reg_1) + signed(reg_2));
        
        -- minus - what about negative result? should probably be good   
        elsif (alu_c(3 downto 0) = x"2") then
            result_alu <= std_logic_vector(signed(reg_1) - signed(reg_2));
        
        -- AND - good
        elsif (alu_c(3 downto 0) = x"3") then
            result_alu <= reg_1 and reg_2;
        -- OR - good    
        elsif (alu_c(3 downto 0) = x"4") then
            result_alu <= reg_1 or reg_2;
        
        -- conditional choice - good
        elsif (alu_c(3 downto 0) = x"5") then
            if alu_c(4) = '1' then
                result_alu <= reg_1;
            elsif alu_c(4) = '0' then
                result_alu <= reg_2;
            else
                result_alu <= x"0000_0000";
            end if;
        
        -- compare equal - good
        elsif (alu_c(3 downto 0) = x"6") then
            if (reg_1 = reg_2) then
                result_alu <= x"0000_0001";
            else
                result_alu <= x"0000_0000";
            end if;
        
        -- compare not equal - good    
        elsif (alu_c(3 downto 0) = x"7") then
            if (reg_1 /= reg_2) then
                result_alu <= x"0000_0001";
            else
                result_alu <= x"0000_0000";
            end if;
        
        -- compare bigger - good    
        elsif (alu_c(3 downto 0) = x"8") then
            if (reg_1 >= reg_2) then
                result_alu <= x"0000_0001";
            else
                result_alu <= x"0000_0000";
            end if;
        
        -- left shift - interpretation? now can shift 31bits to the left, or make shift of each byte separately?     
        elsif (alu_c(3 downto 0) = x"A") then
            result_alu <= std_logic_vector(unsigned(reg_1) sll to_integer(unsigned(reg_2(4 downto 0))));

        else
            result_alu <= x"0000_0000";
        end if;
    end process;            
         
end Behavioral;
