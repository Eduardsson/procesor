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
    PORT (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        dp : out STD_LOGIC;
        an : out STD_LOGIC_VECTOR (3 downto 0);
        segm : out STD_LOGIC_VECTOR (6 downto 0);
        pins : inout STD_LOGIC_VECTOR (31 downto 0)
    );
end top;

architecture Behavioral of top is

    constant counter_B : INTEGER := 10;
    constant inst_B : INTEGER := 31;
    constant data_B : INTEGER := 31;
    constant addr_B : INTEGER := 4;

    -- Program counter signals
    signal jump_addr, pc : STD_LOGIC_VECTOR (counter_B downto 0);
    signal jump_en, pc_en : STD_LOGIC;

    -- Instruction signal
    signal inst : STD_LOGIC_VECTOR (inst_B downto 0);

    -- Data signals
    signal addr_1, addr_2 : STD_LOGIC_VECTOR (addr_B downto 0);
    signal reg_1, reg_2, result_alu, data_g, reg_g : STD_LOGIC_VECTOR (data_B downto 0);
    signal data_inst : STD_LOGIC_VECTOR (15 downto 0);
    signal disp_number : STD_LOGIC_VECTOR (15 downto 0) := x"0000";

    -- Control signal
    signal alu_c: STD_LOGIC_VECTOR (4 downto 0);
    signal mux_c : STD_LOGIC_VECTOR (2 downto 0);
    signal write_en : STD_LOGIC_VECTOR (3 downto 0);
    signal cmp_flag: STD_LOGIC;

component alu
    GENERIC (
        data_B : INTEGER
    );
    PORT (
        reg_1 : in STD_LOGIC_VECTOR (data_B downto 0);
        reg_2 : in STD_LOGIC_VECTOR (data_B downto 0);
        alu_c : in STD_LOGIC_VECTOR (4 downto 0);
        result_alu : out STD_LOGIC_VECTOR (data_B downto 0)
    );
end component;

component decoder is
    GENERIC (
        inst_B : INTEGER;
        addr_B : INTEGER
    );
    PORT (
        inst : in STD_LOGIC_VECTOR (inst_B downto 0);
        cmp_flag : in STD_LOGIC;
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        addr_1 : out STD_LOGIC_VECTOR (addr_B downto 0);
        addr_2 : out STD_LOGIC_VECTOR (addr_B downto 0);
        data_inst : out STD_LOGIC_VECTOR (15 downto 0);
        mux_c : out STD_LOGIC_VECTOR (2 downto 0);
        alu_c : out STD_LOGIC_VECTOR (4 downto 0);
        write_en : out STD_LOGIC_VECTOR (3 downto 0);
        jump_en : out STD_LOGIC;
        pc_en : out STD_LOGIC
    );
end component;

component gpio is
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
end component;

component program_counter is
    GENERIC (
        counter_B : INTEGER
    );
    PORT ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        jump_en : in STD_LOGIC;
        pc_en : in STD_LOGIC;
        jump_addr : in STD_LOGIC_VECTOR (counter_B downto 0);
        pc : out STD_LOGIC_VECTOR (counter_B downto 0)
    );
end component;

component reg_field is
    GENERIC (
        data_B : INTEGER;
        addr_B : INTEGER
    );
    PORT (
        addr_1 : in STD_LOGIC_VECTOR (addr_B downto 0);
        addr_2 : in STD_LOGIC_VECTOR (addr_B downto 0);
        data_inst : in STD_LOGIC_VECTOR (15 downto 0);
        data_g : in STD_LOGIC_VECTOR (data_B downto 0);
        data_alu : in STD_LOGIC_VECTOR (data_B downto 0);
        mux_c : in STD_LOGIC_VECTOR (2 downto 0);
        write_r : in STD_LOGIC;
        clk : in STD_LOGIC;
        reg_1 : out STD_LOGIC_VECTOR (data_B downto 0);
        reg_2 : out STD_LOGIC_VECTOR (data_B downto 0);
        reg_g : out STD_LOGIC_VECTOR (data_B downto 0)
    );
end component;

component rom is
    GENERIC (
        counter_B : INTEGER;
        inst_B : INTEGER
    );
    PORT (
        pc : in STD_LOGIC_VECTOR (counter_B downto 0);
        inst : out STD_LOGIC_VECTOR (inst_B downto 0)
    );
end component;

component display_driver is
    PORT (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        write_dr : in STD_LOGIC;
        disp_number: in STD_LOGIC_VECTOR (15 downto 0);
        an : out STD_LOGIC_VECTOR (3 downto 0);
        segm : out STD_LOGIC_VECTOR (6 downto 0)
    );
end component;

begin

    alu_module: alu
        generic map (
            data_B   => data_B
        )
        port map (
            reg_1 => reg_1,
            reg_2 => reg_2,
            alu_c => alu_c,
            result_alu => result_alu
        );

    decoder_module: decoder
        generic map (
            inst_B   => inst_B,
            addr_B   => addr_B
        )
        port map (
            inst => inst,
            cmp_flag => result_alu(0),
            clk => clk,
            rst => rst,
            addr_1 => addr_1,
            addr_2 => addr_2,
            data_inst => data_inst,
            mux_c => mux_c,
            alu_c => alu_c,
            write_en => write_en,
            jump_en => jump_en,
            pc_en => pc_en
        );

    gpio_module: gpio
        generic map (
            data_B   => data_B
        )
        port map  (
            cpu_i => data_g,
            cpu_o => reg_g,
            write_o => write_en(1),
            write_t => write_en(2),
            io => pins,
            clk => clk,
            rst => rst
        );

    program_counter_module: program_counter
        generic map (
            counter_B   => counter_B
        )
        port map (
            clk => clk,
            rst => rst,
            jump_en => jump_en,
            pc_en => pc_en,
            jump_addr => reg_g(counter_B downto 0),
            pc => pc
        );

    reg_field_module: reg_field
        generic map (
            data_B   => data_B,
            addr_B   => addr_B
        )
        port map (
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

    rom_module: rom 
        generic map (
            counter_B   => counter_B,
            inst_B   => inst_B
        )
        port map (
            pc => pc,
            inst => inst
        );

    display_driver_module : display_driver
        port map (
            clk => clk,
            rst => rst,
            write_dr => write_en(3),
            disp_number => reg_g(15 downto 0),
            an => an,
            segm => segm
        );

    dp <= '1';



end Behavioral;
