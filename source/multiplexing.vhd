----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:  01/26/2018 07:28:04 PM  
-- Design Name: 
-- Module Name:    multiplexing - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplexing is
	Port (clk_1kHz, rst: in STD_LOGIC;
			an: out STD_LOGIC_VECTOR (3 downto 0));
end multiplexing;
	
architecture Behavioral of multiplexing is
	type state_type is (s0,s1,s2,s3);
	signal next_state, state : state_type; 
begin

SYNC_PROC: process(clk_1kHz, rst) begin
	if (clk_1kHz'event and clk_1kHz = '1') then
		if rst='1' then
			state <= s0;
		else 
			state <= next_state;
		end if;
	end if;
end process;

STATE_DECODE: process(state) begin
	case state is
		when s0 => next_state <=s1; an<="0111";
		when s1 => next_state <=s2; an<="1011";
		when s2 => next_state <=s3; an<="1101";
		when s3 => next_state <=s0; an<="1110";	
	end case;
end process;

end Behavioral;

