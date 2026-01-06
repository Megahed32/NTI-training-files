library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm is
    generic( DUTY_WIDTH : integer:= 3)
    port(
         clk , arst_n : in std_logic;
         duty : in std_logic_vector(DUTY_WIDTH - 1 downto 0);
         pwm_out: out std_logic;
    )
    end pwm;

    architecture rtl of pwm is
        signal counter : std_logic_vector (DUTY_WIDTH - 1 downto 0);
        signal pwm : std_logic;
    begin
        proc_name: process(clk, arst_n)
        begin
            if arst_n = '0' then
                counter <= (others => '0');            
                pwm_out <= '0';
            elsif rising_edge(clk) then
                if(counter >= duty) then
                pwm_out <= '0';
                else
                pwm_out <= '1';
            end if;
        end process proc_name;
    end architecture rtl;