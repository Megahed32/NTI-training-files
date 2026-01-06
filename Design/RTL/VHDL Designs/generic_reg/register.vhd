library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_generic is
    generic(N :integer := 4);
    port(
        clk , arst_n : in std_logic;
        d : in  std_logic_vector(N-1 downto 0);
        q : out std_logic_vector(N-1 downto 0)
    );
    end register_generic;


    architecture rtl of register_generic is
    begin
        F_F : process(clk, arst_n)
        begin
            if arst_n = '0' then
                q <= (N-1 downto 0 => '0');
            elsif rising_edge(clk) then
                q <= d;
            end if;
        end process F_F;       
    end architecture rtl;