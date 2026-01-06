library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shift_reg is
    port(
        clk , arst_n : in std_logic;
        d : in  std_logic;
        q : out std_logic
    );
    end shift_reg;


    architecture rtl of shift_reg is
        signal q_reg: std_logic_vector(3 downto 0);
    begin
        F_F : process(clk, arst_n)
        begin
            if arst_n = '0' then
                q_reg <= (others=>'0');
            elsif rising_edge(clk) then
                q_reg <= d & q_reg(3 downto 1);
            end if;
        end process F_F;     
        q<= q_reg(0);
    end architecture rtl;