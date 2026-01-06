library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity ring_counter_tb is 

end ring_counter_tb;

architecture tb of ring_counter_tb is 

 -- Component decleration
component ring_counter
generic(N: integer);
    port(
        clk , arst_n : in std_logic;
        q : out std_logic_vector(N-1 downto 0)
    );
    end component;
  constant N : integer := 5;
  signal  clk_tb: std_logic :='0';
  signal  arst_n_tb: std_logic :='0';
  signal  q_tb:   std_logic_vector(N-1 downto 0) := (others => '0'); 
  
begin 

  DUT: ring_counter
  generic map( N => N)
   port map (
     clk=>clk_tb,
     arst_n=>arst_n_tb,
     q => q_tb
    
   );

clk_proc: process
     begin
      clk_tb<= not clk_tb;
      wait for 5 ns;   
     end process;

clk_stop: process
     begin      
     wait for 300 ns;
       std.env.stop;
       wait;
     end process;
        

   stim_proc: process
     begin
      arst_n_tb<='0';
      wait for 10 ns;
      arst_n_tb<='1';
      wait for 10 ns;
      for i in 0 to 15 loop
       wait for 10 ns;
       end loop;  
       wait; 
     end process;
end tb;