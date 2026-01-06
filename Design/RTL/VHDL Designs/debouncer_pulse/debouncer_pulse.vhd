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
        signal q_reg: std_logic_vector(2 downto 0); -- register for shift

        signal edge_detected : std_logic;
        signal edge , edge_reg : std_logic;
    begin
        REGISTERS: process(clk, arst_n)
        begin
            if arst_n = '0' then
                q_reg <= (others => '0');
            elsif rising_edge(clk) then
                q_reg <= d & q_reg(2 downto 1);
            end if;
        end process;  
    
        edge <= q_reg(0) and q_reg(1) and q_reg(2) ;
        

        EDGE_DETECTOR: process(clk, arst_n)
        begin
            if arst_n = '0' then
                edge_detected <= '0';
                edge_reg <= '0';
            elsif rising_edge(clk) then
                edge_reg <= edge;
                if ((edge ='1') and (edge_reg='0')) then 
                edge_detected <= '1';
                else
                    edge_detected <= '0';
                end if;
            end if;
        end process; 
        q <= edge_detected;
    end architecture rtl;