library library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity priority_encoder is
    port(
        x: in std_logic_vector(3 downto 0);
        pcode : out std_logic_vector(2 downto 0)
    );

    end priority_encoder;


    architecture behavioural of priority_encoder is
        begin
        pcode <= "100" when x(3) = '1' else
                 "011" when x(2) = '1' else
                 "010" when x(1) = '1' else
                 "001" when x(0) = '1' else
                 "000"
        end architecture behavioural;
