
library ieee;
use ieee.std_logic_1164.ALL;


entity t_fsm is
end t_fsm;

architecture t_fsm_arch of t_fsm is
           
component fsm
port(
		fbup	: in 	bit_vector(5 downto 0);		
		fbdown	: in 	bit_vector(5 downto 0);
		eb	: in 	bit_vector(5 downto 0);
	
		
	
		op	: out	bit;
		clk	: in 	bit;
		reset 	: in 	bit
	);
end component;

--Initialise input signals --------------------------------------
signal fbup,r_fbup,fbup_out: bit_vector(5 downto 0) ;
signal fbdown,r_fbdown,fbdown_out: bit_vector(5 downto 0) ;
signal eb,r_eb,eb_out: bit_vector(5 downto 0) ;
signal op,clk,reset : bit;
constant clk_period : time := 8 ns;
----------------------------------------------------------------
begin
     
	fsm_1st_instance: fsm port map (fbup,fbdown,eb, op, clk, reset);
---reset process just triggerring to start the lift-------------
rprocess :process
 begin

		reset <= '1' ;
		wait for 1 ns ;
		reset <= '0';
		wait ;        
   end process;
---------------------------------------------------------------

clk1_process :process
 begin
        clk <= '0';
        wait for clk_period/2;  --for 0.5 ns signal is '0'.
        clk <= '1';
        wait for clk_period/2;  --for next 0.5 ns signal is '1'.
   end process;
----------------------------------------------------------------

one : process
 begin
        
        wait for 0.5 ns;  --for 0.5 ns signal is '0'.
	fbdown <= "111110";
	fbup <= "011111";
	
	wait for 1 ns ;
	fbdown <= "000000";
	fbup <= "000000";

	wait for 600 ns;
	fbdown(5) <= '1';
	wait for 1 ns;
	fbdown(5) <= '0';

	wait ; 
	
	

   end process one ;
---------------------------------------------------------------


---------------------------------------------------------------

--fourth: process
-- begin
        
--        wait for 3000 ns;  --for 0.5 ns signal is '0'.
--	eb(1) <= '1';
	
--	wait for 1 ns ;
--	eb(1) <= '0';
	
	
	
--	wait ;
	
	

--   end process;
---------------------------------------------------------------


end t_fsm_arch;

