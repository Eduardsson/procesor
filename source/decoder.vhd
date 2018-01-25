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
           cmp_flag : in STD_LOGIC;
           clk : in STD_LOGIC;
           
           addr_1 : out STD_LOGIC_VECTOR (4 downto 0);
           addr_2 : out STD_LOGIC_VECTOR (4 downto 0);
           data_inst : out STD_LOGIC_VECTOR (15 downto 0);
           mux_c : out STD_LOGIC_VECTOR (2 downto 0);
           alu_c : out STD_LOGIC_VECTOR (4 downto 0);
           write_en : out STD_LOGIC_VECTOR (2 downto 0);
           jump_en : out STD_LOGIC;
           cmp_flag_reg : out STD_LOGIC;
           pc_en : out STD_LOGIC);
           
end decoder;

architecture Behavioral of decoder is

    type state_type is (init, mth_s2, cmov_s1, nop_s1, nop_s2, cust1_s2, cust3_s2, cust5_s2, cust2_s2, cust4_s2, sf_s2);
    signal state, next_state : state_type;

    signal s_addr_1, s_addr_2 : STD_LOGIC_VECTOR (4 downto 0);
    signal rst : STD_LOGIC;
    
    signal nop_cnt : STD_LOGIC_VECTOR (15 downto 0) := x"00_02";
    signal counter_en : STD_LOGIC := '0';
    signal nop_cnt_done : STD_LOGIC := '0';

    --signal cmp_flag_reg : STD_LOGIC := '0';
 
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
             cmp_flag_reg <= cmp_flag;
          end if;
       end if;
    end process;
 
    STATE_DECODE: process (state, inst, nop_cnt_done, cmp_flag)
    begin
        next_state <= state;  --default is to stay in current state

        case (state) is
            when init =>
                
                --instructions beginning with opcode 0x38
                if inst(31 downto 26) = "111000" then

                    if inst(3 downto 0) = x"0" then         -- ADD rD, rA, rB
                        
                        jump_en <= '0';                
                        counter_en <= '0';
                        pc_en <= '0';
                        data_inst <= (others => '0');
                        
                        s_addr_1 <= inst(20 downto 16);     -- rA
                        s_addr_2 <= inst(15 downto 11);     -- rB
                        mux_c <= "000";
                        alu_c <= "00001";
                        write_en <= "000";
                        
                        next_state <= mth_s2;

                    elsif inst(3 downto 0) = x"3" then      -- AND rD, rA, rB
                        
                        data_inst <= (others => '0');
                        pc_en <= '0';
                        jump_en <= '0';
                        counter_en <= '0';


                        s_addr_1 <= inst(20 downto 16);  -- rA
                        s_addr_2 <= inst(25 downto 21);  -- rB
                        mux_c <= "000";
                        alu_c <= "00011";
                        write_en <= "000";
                        
                        next_state <= mth_s2;

                    elsif inst(3 downto 0) = x"E" then      -- CMOV
                        next_state <= cmov_s1;
                    elsif inst(3 downto 0) = x"4" then      -- OR rD, rA, rB
                        
                        data_inst <= (others => '0');
                        pc_en <= '0';
                        jump_en <= '0';
                        counter_en <= '0';

                        s_addr_1 <= inst(20 downto 16);  -- rA
                        s_addr_2 <= inst(25 downto 21);  -- rB
                        mux_c <= "000";
                        alu_c <= "00100";
                        write_en <= "000";
                                
                        next_state <= mth_s2;

                    elsif inst(3 downto 0) = x"8" then
                        
                    if inst(9 downto 6) = x"1" then         -- SRL rD, rA, rB
                        
                        jump_en <= '0';
                        pc_en <= '0';
                        counter_en <= '0';
                        data_inst <= (others => '0');

                        s_addr_1 <= inst(20 downto 16);  -- rA
                        s_addr_2 <= inst(15 downto 11);  -- rB
                        mux_c <= "000";
                        alu_c <= "01011";
                        write_en <= "000";

                        next_state <= mth_s2;

                    else                                    -- SLL rD, rA, rB
                        
                        jump_en <= '0';
                        pc_en <= '0';
                        counter_en <= '0';
                        data_inst <= (others => '0');

                        s_addr_1 <= inst(20 downto 16);  -- rA
                        s_addr_2 <= inst(15 downto 11);  -- rB
                        mux_c <= "000";
                        alu_c <= "01010";
                        write_en <= "000";

                        next_state <= mth_s2;

                    end if;

                    elsif inst(3 downto 0) = x"2" then      -- SUB rD, rA, rB
                        
                        jump_en <= '0';
                        pc_en <= '0';
                        counter_en <= '0';
                        data_inst <= (others => '0');

                        s_addr_1 <= inst(20 downto 16);  -- rA
                        s_addr_2 <= inst(15 downto 11);  -- rB
                        mux_c <= "000";
                        alu_c <= "00010";
                        write_en <= "000";

                        next_state <= mth_s2;

                    end if;

                elsif inst(31 downto 26) = "101001" then    -- ANDI rD, rA, I
                    
                    pc_en <= '0';
                    jump_en <= '0';
                    s_addr_2 <= (others => '0'); 
                    counter_en <= '0';


                    s_addr_1 <= inst(20 downto 16);         -- rA
                    data_inst <= inst(15 downto 0);         -- I
                    mux_c <= "010";
                    alu_c <= "00011";
                    write_en <= "000";
                                
                    next_state <= mth_s2;

                elsif inst(31 downto 26) = "101010" then    -- ORI rD, rA, I
                    
                    pc_en <= '0';
                    jump_en <= '0';
                    s_addr_2 <= (others => '0'); 
                    counter_en <= '0';

                    s_addr_1 <= inst(20 downto 16);  -- rA
                    data_inst <= inst(15 downto 0);  -- I
                    mux_c <= "010";
                    alu_c <= "00100";
                    write_en <= "000";
                                            
                    next_state <= mth_s2;

                elsif inst(31 downto 24) = "00010101" then  -- NOP

                    next_state <= nop_s1;

                elsif inst(31 downto 26) = "000000" then    -- J N
                    
                    s_addr_2 <= (others => '0');
                    s_addr_1 <= (others => '0');
                    pc_en <= '0';
                    counter_en <= '0';
                    alu_c <= "00000";
                    write_en <= "000";    

                    data_inst <= inst(15 downto 0);         -- N
                    mux_c <= "001";

                    jump_en <= '1';
                    next_state <= init;

                elsif inst(31 downto 26) = "100111" then    -- ADDI rD, rA, I
                    
                    s_addr_2 <= (others => '0');  
                    pc_en <= '0';
                    jump_en <= '0';
                    counter_en <= '0';

                    s_addr_1 <= inst(20 downto 16);  -- rA
                    data_inst <= inst(15 downto 0);  -- I
                    mux_c <= "010";
                    alu_c <= "00001";
                    write_en <= "000";

                    next_state <= mth_s2;

                elsif inst(31 downto 26) = "010110" then    -- CUST1 rA, rB
                    
                    data_inst <= (others => '0');
                    jump_en <= '0'; 
                    pc_en <= '0';
                    counter_en <= '0';

                    s_addr_1 <= inst(25 downto 21);  -- rA
                    s_addr_2 <= inst(20 downto 16);  -- rB
                    mux_c <= "000";
                    alu_c <= "00001";
                    write_en <= "000";

                    next_state <= cust1_s2;
                
                elsif inst(31 downto 26) = "011101" then    -- CUST2 rD, rA
                    
                    s_addr_2 <= (others => '0');
                    data_inst <= (others => '0');
                    jump_en <= '0';
                    pc_en <= '0';
                    counter_en <= '0';
                        
                    s_addr_1 <= inst(20 downto 16);  -- rA
                    mux_c <= "100";
                    alu_c <= "00001";
                    write_en <= "000";

                    next_state <= cust2_s2;

                elsif inst(31 downto 26) = "011110" then    -- CUST3 rA, I
                    
                    s_addr_2 <= (others => '0');
                    jump_en <= '0';
                    pc_en <= '0';
                    counter_en <= '0';

                    s_addr_1 <= inst(25 downto 21);  -- rA
                    data_inst <= inst(20 downto 5);  -- I
                    mux_c <= "010";
                    alu_c <= "00001";
                    write_en <= "000";

                    next_state <= cust3_s2;

                elsif inst(31 downto 26) = "111100" then    -- CUST4 rA, rB
                    
                    data_inst <= (others => '0');
                    jump_en <= '0';
                    pc_en <= '0';
                    counter_en <= '0';

                    s_addr_1 <= inst(25 downto 21);  -- rA
                    s_addr_2 <= inst(20 downto 16);  -- rB
                    mux_c <= "000";
                    alu_c <= "00001";
                    write_en <= "000";

                    next_state <= cust4_s2;

                elsif inst(31 downto 26) = "111101" then    -- CUST5 rA, I
                    
                    s_addr_2 <= (others => '0');
                    jump_en <= '0';
                    pc_en <= '0';
                    counter_en <= '0';

                    s_addr_1 <= inst(25 downto 21);  -- rA
                    data_inst <= inst(20 downto 5);  -- I
                    mux_c <= "010";
                    alu_c <= "00001";
                    write_en <= "000";

                    next_state <= cust5_s2; 

                elsif inst(31 downto 21) = "11100100000" then    -- SFEQ rA, rB (sets cmp_flag)
                    
                    data_inst <= (others => '0');
                    jump_en <= '0';
                    pc_en <= '0';
                    counter_en <= '0';

                    s_addr_1 <= inst(20 downto 16);  -- rA
                    s_addr_2 <= inst(15 downto 11);  -- rB
                    mux_c <= "000";
                    alu_c <= "00110";
                    write_en <= "000";

                    next_state <= sf_s2;
                
                elsif inst(31 downto 21) = "10111100000" then    -- SFEQI rA, I (sets cmp_flag)
                    
                    s_addr_2 <= (others => '0');
                    jump_en <= '0';
                    pc_en <= '0';
                    counter_en <= '0';

                    s_addr_1 <= inst(20 downto 16);  -- rA
                    data_inst <= inst(15 downto 0);  -- I
                    mux_c <= "010";
                    alu_c <= "00110";
                    write_en <= "000";

                    next_state <= sf_s2;  
                
                elsif inst(31 downto 21) = "11100100001" then    -- SFNE rA, rB (sets cmp_flag)
                    
                    jump_en <= '0';
                    pc_en <= '0';
                    counter_en <= '0';
                    data_inst <= (others => '0');

                    s_addr_1 <= inst(20 downto 16);  -- rA
                    s_addr_2 <= inst(15 downto 11);  -- rB
                    mux_c <= "000";
                    alu_c <= "00111";
                    write_en <= "000";

                    next_state <= sf_s2; 

                elsif inst(31 downto 21) = "10111100001" then    -- SFNEI rA, I (sets cmp_flag)
                    
                    s_addr_2 <= (others => '0');
                    jump_en <= '0';
                    pc_en <= '0';
                    counter_en <= '0';

                    s_addr_1 <= inst(20 downto 16);  -- rA
                    data_inst <= inst(15 downto 0);  -- I
                    mux_c <= "010";
                    alu_c <= "00111";
                    write_en <= "000";

                    next_state <= sf_s2; 

                elsif inst(31 downto 21) = "11100101011" then    -- SFGES rA, rB (sets cmp_flag)
                    
                    jump_en <= '0';
                    pc_en <= '0';
                    counter_en <= '0';
                    data_inst <= (others => '0');

                    s_addr_1 <= inst(20 downto 16);  -- rA
                    s_addr_2 <= inst(15 downto 11);  -- rB
                    mux_c <= "000";
                    alu_c <= "01000";
                    write_en <= "000";

                    next_state <= sf_s2;

                elsif inst(31 downto 21) = "10111101011" then    -- SFGESI rA, I (sets cmp_flag)
                    
                    s_addr_2 <= (others => '0');
                    jump_en <= '0';
                    pc_en <= '0';
                    counter_en <= '0';

                    s_addr_1 <= inst(20 downto 16);  -- rA
                    data_inst <= inst(15 downto 0);  -- I
                    mux_c <= "010";
                    alu_c <= "01000";
                    write_en <= "000";

                    next_state <= sf_s2;  

                else
                
                    s_addr_1 <= (others => '0');
                    s_addr_2 <= (others => '0');
                    data_inst <= (others => '0');
                    mux_c <= (others => '0');
                    alu_c <= "00000";
                    
                    write_en <= "000";
                    pc_en <= '0';
                    jump_en <= '0';                
                    counter_en <= '0';

                end if;

            when mth_s2 =>
                    jump_en <= '0';                
                    counter_en <= '0';
                    mux_c <= "000";
                    alu_c <= "00000";
                    data_inst <= (others => '0');
            
                    s_addr_1 <= inst(25 downto 21);  -- rD
                    s_addr_2 <= inst(25 downto 21);  -- rD
                    write_en <= "001";

                    pc_en <= '1';
                    next_state <= init;

            -- NOP
                                    
            when nop_s1 =>
                    s_addr_2 <= (others => '0');
                    s_addr_1 <= (others => '0');
                    data_inst <= (others => '0');
                    mux_c <= "000";
                    jump_en <= '0';        

                    if nop_cnt_done = '1' then
                        counter_en <= '0';
                        pc_en <= '1';
                        next_state <= init;
                    else
                       pc_en <= '0';
                       counter_en <= '1';
                       next_state <= nop_s1; 
                    end if;
                    
                    alu_c <= "00000";
                    write_en <= "000";

            -- CUST1 rA, rB -----------------------------
            
            when cust1_s2 =>
                    s_addr_1 <= inst(25 downto 21);  -- rA
                    s_addr_2 <= inst(20 downto 16);  -- rB
                    data_inst <= (others => '0');
                    mux_c <= "000";
                    alu_c <= "00001";
                    counter_en <= '0';
                    jump_en <= '0';

                    write_en <= "010";

                    pc_en <= '1';
                    next_state <= init;


            -- CUST2 rD, rA     -----------------------------

            when cust2_s2 =>
                    jump_en <= '0';                
                    counter_en <= '0';
                    mux_c <= "100";
                    alu_c <= "00001";
                    data_inst <= (others => '0');
            
                    s_addr_1 <= inst(25 downto 21);  -- rD
                    s_addr_2 <= inst(25 downto 21);  -- rD
                    write_en <= "001";

                    pc_en <= '1';
                    next_state <= init;

            -- CUST3 rA, I -----------------------------

            when cust3_s2 =>
                    s_addr_1 <= inst(25 downto 21);  -- rA
                    data_inst <= inst(20 downto 5);  -- I
                    s_addr_2 <= (others => '0');
                    mux_c <= "010";
                    alu_c <= "00001";
                    counter_en <= '0';
                    jump_en <= '0';

                    write_en <= "010";

                    pc_en <= '1';
                    next_state <= init;

            -- CUST4 rA, rB -----------------------------

            when cust4_s2 =>
                    s_addr_1 <= inst(25 downto 21);  -- rA
                    s_addr_2 <= inst(20 downto 16);  -- rB
                    data_inst <= (others => '0');
                    jump_en <= '0';
                    counter_en <= '0';
                    mux_c <= "000";
                    alu_c <= "00001";


                    write_en <= "100";

                    pc_en <= '1';
                    next_state <= init;

            -- CUST5 rA, I -----------------------------
                    
            when cust5_s2 =>
                    s_addr_1 <= inst(25 downto 21);  -- rA
                    s_addr_2 <= (others => '0');
                    data_inst <= inst(20 downto 5);  -- I
                    jump_en <= '0';
                    counter_en <= '0';
                    mux_c <= "010";
                    alu_c <= "00001";


                    write_en <= "100";

                    pc_en <= '1';
                    next_state <= init;

            
            -- SFEQ rA, rB (sets cmp_flag) -------------

            when sf_s2 =>
                    s_addr_2 <= (others => '0');
                    s_addr_1 <= (others => '0');
                    data_inst <= (others => '0');
                    mux_c <= "000";
                    alu_c <= "00000";
                    jump_en <= '0';
                    write_en <= "000";
                    counter_en <= '0';

                    --cmp_flag_reg <= cmp_flag;
                    pc_en <= '1';
                    next_state <= init;                    

            -- SFEQI rA, I (sets cmp_flag) -------------
                          

            -- SFNE rA, rB (sets cmp_flag) -------------  
                

            -- SFNEI rA, I (sets cmp_flag) -------------
                        
            
            -- SFGES rA, rB (sets cmp_flag) ------------
            

            -- SFGESI rA, I (sets cmp_flag) ------------

            when others =>
                jump_en <= '0';
                pc_en <= '0';
                counter_en <= '0';
                data_inst <= (others => '0');
                
                s_addr_1 <= (others => '0');  -- rA
                s_addr_2 <= (others => '0');  -- rB
                mux_c <= "000";
                alu_c <= "00000";
                write_en <= "000";

                next_state <= init;
        end case;

    end process;
    
    COUNTER: process (clk, counter_en)
    begin
        
        if (clk'event and clk='1') then

            if (counter_en = '0') then
                nop_cnt_done <= '0';
                
            elsif (nop_cnt = inst(15 downto 0) and counter_en = '1') then
                nop_cnt_done <= '1';
                nop_cnt <= x"0001";
            
            elsif nop_cnt <= x"FF_FF" and counter_en = '1' then
                nop_cnt <= std_logic_vector(unsigned(nop_cnt) + 1);    
            end if;
            
            
        end if;
        
        
    end process; 


end Behavioral;
