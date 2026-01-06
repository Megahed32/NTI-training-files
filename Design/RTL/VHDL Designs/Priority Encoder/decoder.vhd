library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder is
    port(
        en : in  std_logic;                      -- Enable signal
        a  : in  std_logic_vector(1 downto 0);    -- 2-bit input
        y  : out std_logic_vector(3 downto 0)     -- 4-bit output
    );
end decoder;

architecture rtl of decoder is
begin
    dec: process(en, a)
    begin
        if (en = '0') then
            y <= "0000";  -- Output all zeros when enable is low
        else
            case a is
                when "00" => y <= "0001";  -- Output line 0 is high for input "00"
                when "01" => y <= "0010";  -- Output line 1 is high for input "01"
                when "10" => y <= "0100";  -- Output line 2 is high for input "10"
                when "11" => y <= "1000";  -- Output line 3 is high for input "11"
                when others => y <= "0000"; -- Default case (just in case)
            end case;
        end if;
    end process dec;
end architecture rtl;
