----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2017 07:20:38 PM
-- Design Name: 
-- Module Name: decoder - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


-- 25 downto 21 rD
-- 20 downto 16 rA
-- 15 downto 11 rB
-- 15 downto 0 I

entity decoder is
    Port ( inst : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           addr_1 : out STD_LOGIC_VECTOR (4 downto 0);
           addr_2 : out STD_LOGIC_VECTOR (4 downto 0);
           data_inst : out STD_LOGIC_VECTOR (15 downto 0);
           mux_c : out STD_LOGIC_VECTOR (2 downto 0);
           alu_c : out STD_LOGIC_VECTOR (4 downto 0);
           write_en : out STD_LOGIC_VECTOR (2 downto 0);
           jump_en : out STD_LOGIC;
           pc_en : out STD_LOGIC);
end decoder;

architecture Behavioral of decoder is

    type state_type is (init, add_s1, add_s2, and_s1, and_s2, andi_s1, andi_s2, cmov_s1, nop_s1, nop_s2, or_s1, or_s2, ori_s1, ori_s2, srl_s1, sll_s1, sub_s1);
    signal state, next_state : state_type;

    signal s_addr_1, s_addr_2 : STD_LOGIC_VECTOR (4 downto 0);
    signal rst : STD_LOGIC;
    
    signal nop_cnt : STD_LOGIC_VECTOR (15 downto 0) := x"00_01";
    signal nop_cnt_en : STD_LOGIC := '0';

 
begin

    rst <= '0';
    addr_1 <= s_addr_1;
    addr_2 <= s_addr_2;

    SYNC_PROC: process (clk)
    begin
       if (clk'event and clk = '1') then
          if (rst = '1') then
             state <= init;
          else
             state <= next_state;
          end if;
       end if;
    end process;
 
    STATE_DECODE: process (state, inst)
    begin
        next_state <= state;  --default is to stay in current state

        case (state) is
            when init =>
                --instructions beginning with opcode 0x38
                if inst(31 downto 26) = "111000" then

                    if inst(3 downto 0) = x"0" then     -- ADD
                        next_state <= add_s1;
                    elsif inst(3 downto 0) = x"3" then  -- AND
                        next_state <= and_s1;
                    elsif inst(3 downto 0) = x"E" then  -- CMOV
                        next_state <= cmov_s1;
                    elsif inst(3 downto 0) = x"4" then  -- OR
                        next_state <= or_s1;
                    elsif inst(3 downto 0) = x"8" then  -- ADD
                        
                        if inst(9 downto 6) = x"1" then -- SRL
                            next_state <= srl_s1;
                        else                            -- SLL
                            next_state <= sll_s1;
                        end if;

                    elsif inst(3 downto 0) = x"2" then  -- SUB
                        next_state <= sub_s1;
                    end if;
                
                elsif inst(31 downto 26) = "101001" then -- ANDI
                    next_state <= andi_s1; 
                
                elsif inst(31 downto 26) = "101010" then -- ORI
                    next_state <= ori_s1;
                    
                elsif inst(31 downto 24) = "00010101" then -- NOP
                    next_state <= nop_s1;
                                                      
                end if;

                write_en <= "000";
                pc_en <= '0';

            when add_s1 =>
                    s_addr_1 <= inst(20 downto 16);  -- rA
                    s_addr_2 <= inst(15 downto 11);  -- rB
                    mux_c <= "000";
                    alu_c <= "00001";
                    write_en <= "000";

                    next_state <= add_s2;

            when add_s2 =>
                    s_addr_1 <= inst(25 downto 21);  -- rD
                    s_addr_2 <= inst(25 downto 21);  -- rD
                    write_en <= "001";

                    pc_en <= '1';
                    next_state <= init;
                    
            -- AND
            
            when and_s1 =>
                    s_addr_1 <= inst(20 downto 16);  -- rA
                    s_addr_2 <= inst(25 downto 21);  -- rB
                    mux_c <= "000";
                    alu_c <= "00011";
                    write_en <= "000";
                    
                    next_state <= and_s2;
            
            when and_s2 =>
                    s_addr_1 <= inst(25 downto 21);  -- rD
                    s_addr_2 <= inst(25 downto 21);  -- rD
                    write_en <= "001";
                    
                    pc_en <= '1';
                    next_state <= init;
                    
            -- ANDI
            
            when andi_s1 =>
                    s_addr_1 <= inst(20 downto 16);  -- rA
                    data_inst <= inst(15 downto 0);  -- I
                    mux_c <= "010";
                    alu_c <= "00011";
                    write_en <= "000";
                                
                    next_state <= andi_s2;
                    
            when andi_s2 =>
                    s_addr_1 <= inst(25 downto 21);  -- rD
                    s_addr_2 <= inst(25 downto 21);  -- rD
                    write_en <= "001";
                                        
                    pc_en <= '1';
                    next_state <= init;
            
            -- OR
            when or_s1 =>
                    s_addr_1 <= inst(20 downto 16);  -- rA
                    s_addr_2 <= inst(25 downto 21);  -- rB
                    mux_c <= "000";
                    alu_c <= "00100";
                    write_en <= "000";
                               
                    next_state <= or_s2;
                        
            when or_s2 =>
                    s_addr_1 <= inst(25 downto 21);  -- rD
                    s_addr_2 <= inst(25 downto 21);  -- rD
                    write_en <= "001";
                                
                    pc_en <= '1';
                    next_state <= init;
            
            -- ORI
            
            when ori_s1 =>
                    s_addr_1 <= inst(20 downto 16);  -- rA
                    data_inst <= inst(15 downto 0);  -- I
                    mux_c <= "010";
                    alu_c <= "00100";
                    write_en <= "000";
                                            
                    next_state <= ori_s2;
                                
            when ori_s2 =>
                    s_addr_1 <= inst(25 downto 21);  -- rD
                    s_addr_2 <= inst(25 downto 21);  -- rD
                    write_en <= "001";
                                                    
                    pc_en <= '1';
                    next_state <= init;
            
            -- NOP
                                    
            when nop_s1 =>
                    alu_c <= "00000";
                    write_en <= "000";
                    
                    pc_en <= '0';
                    nop_cnt_en <= '1';
                    next_state <= nop_s1;
            when others =>
                next_state <= init;
        end case;

    end process;
    
    NOP_COUNTER: process (clk, nop_cnt_en)
    begin
        if clk='1' and clk'event and nop_cnt_en = '1' then
            if (nop_cnt = inst(15 downto 0)) then
                nop_cnt_en <= '0';
                pc_en <= '1';
                next_state <= init;
            elsif nop_cnt <= x"FF_FF" then
                nop_cnt <= std_logic_vector(unsigned(nop_cnt) + 1);
                
            end if;
        end if;
    end process; 


end Behavioral;
