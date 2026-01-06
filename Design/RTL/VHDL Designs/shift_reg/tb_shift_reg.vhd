library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_reg_tb is 

end shift_reg_tb;

architecture tb of shift_reg_tb is 

 -- Component decleration
component shift_reg
port(
        clk , arst_n : in std_logic;
        d : in  std_logic;
        q : out std_logic
    );
  end component;

  signal  clk_tb: std_logic :='0';
  signal  arst_n_tb: std_logic :='0';
  signal  d_tb:   STD_LOGIC;
  signal  q_tb:   std_logic; 
  
begin 

  DUT: shift_reg
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
      d_tb<= '0';
      wait for 10 ns;
      arst_n_tb<='1';
      wait for 10 ns;
      d_tb<= '0';
      for i in 0 to 15 loop
      d_tb<= not d_tb;
       wait for 10 ns;
       end loop;  
       wait; 
     end process;
end tb;