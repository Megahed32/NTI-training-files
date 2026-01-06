
library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity debouncer_pulse is
    port(
        clk , arst_n ,d: in std_logic;
        q : out std_logic
    );
    end debouncer_pulse;


    architecture rtl of debouncer_pulse is
        signal q_reg: std_logic_vector(2 downto 0);
    begin
        F_F : process(clk, arst_n)
        begin
            if arst_n = '0' then
                q_reg <= (others => '0');
            elsif rising_edge(clk) then
                q_reg <= d & q_reg(2 downto 1);
            end if;
        end process F_F;     
        q <= q_reg(0) and q_reg(1) and q_reg(2);
    end architecture rtl;