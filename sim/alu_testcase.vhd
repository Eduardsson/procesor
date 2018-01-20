library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
--.std_logic_signed.all;

entity alu_tb is
end;

architecture bench of alu_tb is

  component alu
      Port ( reg_1 : in STD_LOGIC_VECTOR (31 downto 0);
             reg_2 : in STD_LOGIC_VECTOR (31 downto 0);
             alu_c : in STD_LOGIC_VECTOR (4 downto 0);
             result_alu : out STD_LOGIC_VECTOR (31 downto 0));
  end component;

  signal reg_1: STD_LOGIC_VECTOR (31 downto 0);
  signal reg_2: STD_LOGIC_VECTOR (31 downto 0);
  signal alu_c: STD_LOGIC_VECTOR (4 downto 0);
  signal result_alu: STD_LOGIC_VECTOR (31 downto 0);

begin

  uut: alu port map ( reg_1      => reg_1,
                      reg_2      => reg_2,
                      alu_c      => alu_c,
                      result_alu => result_alu );

  stimulus: process
  begin
  
    -- Put initialisation code here
    alu_c <= "00000";
    reg_1 <= x"0000_0003";
    reg_2 <= x"0000_0002";
    
    for I in 1 to 31 loop
        wait for 10 ns;
        alu_c <= std_logic_vector(to_signed(I,5));
    end loop;
    
    alu_c <= "00000";
    reg_1 <= x"0000_0009";
    reg_2 <= x"0000_0009";
    
    for I in 1 to 31 loop
            wait for 10 ns;
            alu_c <= std_logic_vector(to_signed(I,5));
    end loop;
    
    alu_c <= "00000";
    reg_1 <= x"0000_0009";
    reg_2 <= x"0000_000E";
    
    for I in 1 to 31 loop
            wait for 10 ns;
            alu_c <= std_logic_vector(to_signed(I,5));
        end loop;
    
    -- Put test bench stimulus code here

    alu_c <= "00000";
    reg_1 <= x"FFFF_FFF9";
    reg_2 <= x"0000_000E";
    
    wait for 2 ns;
    
    alu_c <= "00001";
    wait;
  end process;


end;
  