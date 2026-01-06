library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ring_counter is
    generic(N: integer:=4);
    port(
        clk , arst_n : in std_logic;
        q : out std_logic_vector(N-1 downto 0)
    );
    end ring_counter;


    architecture rtl of ring_counter is
        signal q_reg: std_logic_vector(N-1 downto 0);
    begin
        F_F : process(clk, arst_n)
        begin
            if arst_n = '0' then
                q_reg <= '1' & (N-2 downto 0 => '0');
            elsif rising_edge(clk) then
                q_reg <= q_reg(0) & q_reg(N-1 downto 1);
            end if;
        end process F_F;     
        q <= q_reg;
    end architecture rtl;