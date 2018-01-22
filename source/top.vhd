----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2017 11:15:38 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pins : inout STD_LOGIC_VECTOR (31 downto 0));
end top;

architecture Behavioral of top is

signal reg_1, reg_2, result_alu, inst, data_g, reg_g : STD_LOGIC_VECTOR (31 downto 0);
signal jump_addr, pc, data_inst : STD_LOGIC_VECTOR (15 downto 0);
signal addr_1, addr_2 : STD_LOGIC_VECTOR (4 downto 0);
signal alu_c: STD_LOGIC_VECTOR (4 downto 0);
signal mux_c, write_en : STD_LOGIC_VECTOR (2 downto 0);
signal jump_en, pc_en :STD_LOGIC;
signal cmp_flag: STD_LOGIC;

component alu
    Port ( reg_1 : in STD_LOGIC_VECTOR (31 downto 0);
           reg_2 : in STD_LOGIC_VECTOR (31 downto 0);
           alu_c : in STD_LOGIC_VECTOR (4 downto 0);
           cmp_flag : out STD_LOGIC;
           result_alu : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component decoder is
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
           pc_en : out STD_LOGIC);
end component;

component gpio is
    Port ( cpu_i : out STD_LOGIC_VECTOR (31 downto 0);
           cpu_o : in STD_LOGIC_VECTOR (31 downto 0);
           write_o : in STD_LOGIC;
           write_t : in STD_LOGIC;
           io : inout STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC);
end component;

component program_counter is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           jump_en : in STD_LOGIC;
           pc_en : in STD_LOGIC;
           jump_addr : in STD_LOGIC_VECTOR (15 downto 0);
           pc : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component reg_field is
    Port ( addr_1 : in STD_LOGIC_VECTOR (4 downto 0);
           addr_2 : in STD_LOGIC_VECTOR (4 downto 0);
           data_inst : in STD_LOGIC_VECTOR (15 downto 0);
           data_g : in STD_LOGIC_VECTOR (31 downto 0);
           data_alu : in STD_LOGIC_VECTOR (31 downto 0);
           mux_c : in STD_LOGIC_VECTOR (2 downto 0);
           write_r : in STD_LOGIC;
           clk : in STD_LOGIC;
           reg_1 : out STD_LOGIC_VECTOR (31 downto 0);
           reg_2 : out STD_LOGIC_VECTOR (31 downto 0);
           reg_g : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component rom is
    Port (  pc : in STD_LOGIC_VECTOR (15 downto 0);
            inst : out STD_LOGIC_VECTOR (31 downto 0));
end component;


begin

alu_module: alu port map (
    reg_1 => reg_1,
    reg_2 => reg_2,
    alu_c => alu_c,
    cmp_flag => cmp_flag,
    result_alu => result_alu
);

decoder_module: decoder port map (
    inst => inst,
    cmp_flag => cmp_flag,
    clk => clk,
    addr_1 => addr_1,
    addr_2 => addr_2,
    data_inst => data_inst,
    mux_c => mux_c,
    alu_c => alu_c,
    write_en => write_en,
    jump_en => jump_en,
    pc_en => pc_en
);

gpio_module: gpio port map  (
    cpu_i => data_g,
    cpu_o => reg_g,
    write_o => write_en(1),
    write_t => write_en(2),
    io => pins,
    clk => clk,
    rst => rst
);

program_counter_module: program_counter port map (
    clk => clk,
    rst => rst,
    jump_en => jump_en,
    pc_en => pc_en,
    jump_addr => reg_g(15 downto 0),
    pc => pc
);

reg_field_module: reg_field port map (
    addr_1 => addr_1,
    addr_2 => addr_2,
    data_inst => data_inst,
    data_g => data_g,
    data_alu => result_alu,
    mux_c => mux_c,
    write_r => write_en(0),
    clk => clk,
    reg_1 => reg_1,
    reg_2 => reg_2,
    reg_g => reg_g
);

rom_module: rom port map (
    pc => pc,
    inst => inst
);



end Behavioral;
