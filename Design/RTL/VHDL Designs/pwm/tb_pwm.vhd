library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity pwm_tb is 

end pwm_tb;

architecture tb of pwm_tb is 

 -- Component decleration
component y pwm is
    generic( DUTY_WIDTH : integer:= 3)
    port(
         clk , arst_n : in std_logic;
         duty : in std_logic_vector(DUTY_WIDTH - 1 downto 0);
         pwm_out: out std_logic;
    )
    end pwm;

  constant WIDTH: integer:=3;
  signal  clk_tb: std_logic :='0';
  signal  arst_n_tb: std_logic :='0';
  signal  duty_tb:   std_logic_vector (WIDTH - 1 downto 0);
  signal  pwm_tb:   std_logic; 
  
begin 

  DUT: pwm
   port map (
     clk=>clk_tb,
     arst_n=>arst_n_tb,
     duty => duty_tb,
     pwm_out => pwm_tb
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
        if((i mod 4) = 0) then
      d_tb <= not d_tb;
      end if;
       wait for 10 ns;
       end loop;  
       wait; 
     end process;
end tb;