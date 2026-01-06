library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_tb is 

end reg_tb;

architecture tb of reg_tb is 

 -- Component decleration
component register_generic
generic(N :integer := 4);
  port(
            clk:in std_logic;
            arst_n:in std_logic;
            d: in std_logic_vector (N-1 downto 0);
            q: out std_logic_vector (N-1 downto 0)
  );
  end component;
  constant N : integer := 4;
  signal  clk_tb: std_logic :='0';
  signal  arst_n_tb: std_logic :='0';
  signal  d_tb:   STD_LOGIC_vector (3 downto 0) := "0000";
  signal  q_tb:   std_logic_vector (3 downto 0); 
  
begin 

  DUT: register_generic
  generic map (N => N)
   port map (
     clk=>clk_tb,
     arst_n=>arst_n_tb,
     d => d_tb,
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
       d_tb<= std_logic_vector (to_unsigned(i,4)); 
       wait for 10 ns;
       end loop;  
       wait; 
     end process;
end tb;