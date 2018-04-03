-----------------FSM---------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
-----------------------------------------------
entity fsm is
port(   fbup	: in 	bit_vector(5 downto 0);		
	fbdown	: in 	bit_vector(5 downto 0);
	eb	: in 	bit_vector(5 downto 0);
	

	
	op	: out	bit;
	clk	: in 	bit;
	reset 	: in 	bit
	);      
end fsm;
-----------------------------------------------
architecture fsm_arch of fsm is 

type state_type is (S0,S1,S2, S3, S4, S5, S6,S7,S8, S9); 
signal Current_State, Next_State : state_type; 
signal down : std_logic;
signal floor : integer := 5;
--------ready buttons ------------------------
signal	r_fbup 	: bit_vector(5 downto 0) :="111111";
signal	r_fbdown: bit_vector(5 downto 0) :="111111";
signal	r_eb 	: bit_vector(5 downto 0) :="111111";
----------------------------------------------
signal	fbup_out: 	bit_vector(5 downto 0) ;
signal	fbdown_out: 	bit_vector(5 downto 0) ;
signal	eb_out	: 	bit_vector(5 downto 0) ;
----------------------------------------------
signal const1 : bit :='1';
signal const0 : bit :='0';
---------------------------------------------
signal stt : integer ;  ------for checking on which state process is

begin 

---controlling light of buttons----------------
-----------------------------------------------------------------
fbupprocess:  process (fbup,r_fbup)
  begin 
	
		for I in 0 to 4 loop	
			if (  r_fbup(I)= '1' ) then --fbup(I) = '1' and
					if (fbup(I) = '1')	
					then			        
					fbup_out(I) <= const1 ;
					end if;
			elsif (r_fbup(I)= '0') then
					fbup_out(I) <= const0 ;
			end if;
		end loop;
	
	 
  end process fbupprocess;
------------------------------------------------------------------
-----------------------------------------------------------------
fbdownprocess:  process (fbdown,r_fbdown)
  begin 
	
		for I in 1 to 5 loop	
			if (  r_fbdown(I)= '1' ) then --fbup(I) = '1' and
					if (fbdown(I) = '1')	
					then			        
					fbdown_out(I) <= const1 ;
					end if;
			elsif (r_fbdown(I)= '0') then
					fbdown_out(I) <= const0 ;
			end if;
		end loop;
	
	 
  end process fbdownprocess;
------------------------------------------------------------------
ebprocess:  process (eb,r_eb)
  begin 
	
		for I in 0 to 5 loop	
			if (  r_eb(I)= '1' ) then --fbup(I) = '1' and
					if (eb(I) = '1')	
					then			        
					eb_out(I) <= const1 ;
					end if;
			elsif (r_eb(I)= '0') then
					eb_out(I) <= const0 ;
			end if;
		end loop;
	
	 
  end process ebprocess;
----------------------------------------------------------------- 
-- Synchronous Process-------------------------
process(clk) 
begin
    if( reset = '1' ) then                 --Synchronous Reset
        Current_State <= S0; 
	
    elsif ( clk'event and clk = '0') then   --Rising edge of Clock -- 
        Current_State <= Next_State ;
    end if;
end process; 
-----------------------------------------------
-- Process for floor increment and decrement -------------------------
process(clk) 
begin
  	if ( clk'event and clk = '1' and down='1') then   --Rising edge of Clock -- 
        	floor <= floor - 1 ;
	elsif ( clk'event and clk = '1' and down='0') then
		floor <= floor + 1 ; 
	elsif ( clk'event and clk = '1' and down='-') then
		floor <= floor;
    end if;
end process; 
-----------------------------------------------
-- Combinational Process-----------------------
Process(Current_State)
    begin
        case Current_State is 
            when S0 => 
		stt <= 0;
		                    
                if(fbdown_out(floor)= '1') then
		                 Next_State <= S1;	-----goes to door open
------------------------------------------------------------------------------------------------------------------------------		
		elsif (floor=5) then	
			if (fbup_out(0)= '1' or fbup_out(1)= '1' or fbup_out(2)= '1'or fbup_out(3)= '1'or fbup_out(4)= '1' 
				or fbdown_out(1)= '1' or fbdown_out(2)= '1' or fbdown_out(3)= '1'or fbdown_out(4)= '1'
			        or eb_out(0)= '1' or eb_out(1)= '1' or eb_out(2)= '1' or eb_out(3)= '1'or eb_out(4)= '1' )
			then 
				down <= '1';
				Next_State <= S3;	-----checks the req of approaching floor 
			else 
				down <= '-';
				Next_State <= S8 ;	------idle state
			end if;	
------------------------------------------------------------------------------------------------------------------------------		
		elsif (floor= 4) then	
			if (fbup_out(0)= '1' or fbup_out(1)= '1' or fbup_out(2)= '1'or fbup_out(3)= '1' 
				or fbdown_out(1)= '1' or fbdown_out(2)= '1' or fbdown_out(3)= '1' or fbdown_out(4)= '1'
			        or eb_out(0)= '1' or eb_out(1)= '1' or eb_out(2)= '1' or eb_out(3)= '1' )
			then
				down <= '1';
				Next_State <= S3;
			elsif (fbup_out(4) = '1' or fbdown_out(5) = '1' or eb_out(5)= '1' )
			then
				down <= '0' ;
				Next_State <= S7;
			else 
				down <= '-';
				Next_State <= S8 ;
			end if;	
------------------------------------------------------------------------------------------------------------------------------		
		elsif (floor= 3) then	
			if (fbup_out(0)= '1' or fbup_out(1)= '1' or fbup_out(2)= '1'
				or fbdown_out(1)= '1' or fbdown_out(2)= '1' or fbdown_out(3)= '1'
			        or eb_out(0)= '1' or eb_out(1)= '1' or eb_out(2)= '1' )
			then
				down <= '1';
				Next_State <= S3;
			elsif (fbup_out(4) = '1' or fbup_out(3) = '1' 
				or fbdown_out(5) = '1' or fbdown_out(4) = '1' 
				or eb_out(5)= '1' or eb_out(4)= '1'  )
			then
				down <= '0' ;
				Next_State <= S7;
			else 
				down <= '-';
				Next_State <= S8 ;
			end if;	
------------------------------------------------------------------------------------------------------------------------------		
		elsif (floor= 2) then	
			if (fbup_out(0)= '1' or fbup_out(1)= '1' 
				or fbdown_out(1)= '1' or fbdown_out(2)= '1' 
			        or eb_out(0)= '1' or eb_out(1)= '1' )
			then
				down <= '1';
				Next_State <= S3;
			elsif (fbup_out(4) = '1' or fbup_out(3) = '1' or fbup_out(2) = '1'
				or fbdown_out(5) = '1' or fbdown_out(4) = '1' or fbdown_out(3) = '1'
				or eb_out(5)= '1' or eb_out(4)= '1' or eb_out(3)= '1'  )
			then
				down <= '0' ;
				Next_State <= S7;
			else 
				down <= '-';
				Next_State <= S8 ;
			end if;	
------------------------------------------------------------------------------------------------------------------------------		
		elsif (floor= 1) then	
			if (fbup_out(0)= '1'  
				or fbdown_out(1)= '1'
			        or eb_out(0)= '1' )
			then
				down <= '1';
				Next_State <= S3;
			elsif (fbup_out(4) = '1' or fbup_out(3) = '1' or fbup_out(2) = '1' or fbup_out(1) = '1'
				or fbdown_out(5) = '1' or fbdown_out(4) = '1' or fbdown_out(3) = '1' or fbdown_out(2) = '1'
				or eb_out(5)= '1' or eb_out(4)= '1' or eb_out(3)= '1' or eb_out(2)= '1'  )
			then
				down <= '0' ;
				Next_State <= S7;
			else 
				down <= '-';
				Next_State <= S8 ;
			end if;		
------------------------------------------------------------------------------------------------------------------------------		
		elsif (floor= 0) then	
			
			if (fbup_out(4) = '1' or fbup_out(3) = '1' or fbup_out(2) = '1' or fbup_out(1) = '1' or fbup_out(0) = '1'
			 or fbdown_out(5) = '1' or fbdown_out(4) = '1' or fbdown_out(3) = '1' or fbdown_out(2) = '1' or fbdown_out(1) = '1'
				or eb_out(5)= '1' or eb_out(4)= '1' or eb_out(3)= '1' or eb_out(2)= '1' or eb_out(1)= '1'  )
			then
				down <= '0' ;
				Next_State <= S7;
			else 
				down <= '-';
				Next_State <= S8 ;
			end if;		
		
------------------------------------------------------------------------------------------------------------------------------
		end if;

---Down checking-------------------------------		
------Door open state (S1)---------------------
	    when S1 =>  
		stt <= 1;
		op <= '1'; 
		r_eb(floor) <='0';
		r_fbdown(floor) <='0';  
		down <= '-';
		                 
                Next_State <= S2;
-----Door close state (S2)----------------------
	    when S2 =>  
		stt <= 2;
		op <= '0'; 
		r_eb(floor) <='1';
		r_fbdown(floor) <='1';  
		down <= '-';
		                 
                Next_State <= S0;
---------------------------------------------------------------------	
-------approaching floor req checker---------------------------------
	   when S3 => 
		stt <= 3; 
		down <= '-'; 
		if (fbdown_out(floor) = '1' or eb_out(floor) = '1' )
		then 
		                 Next_State <= S1; --------if approaching floor has req then opens the door 
		elsif (fbup_out(floor) = '1')	then
				Next_State <= S7;	
		else Next_State <= S2;  ----thus if no req req remains closed
		end if;
-----------------------------------------------------------------------------------------------------------

---Upward checking-------------------------------		
------Door open state (S1)---------------------
	    when S4 =>  
		stt <= 4;
		op <= '1'; 
		r_eb(floor) <='0';
		r_fbup(floor) <='0';  
		down <= '-';
		                 
                Next_State <= S5;
-----Door close state (S2)----------------------
	    when S5 => 
		stt <= 5; 
		op <= '0'; 
		r_eb(floor) <='1';
		r_fbup(floor) <='1';  
		down <= '-';
		                 
                Next_State <= S7;
---------------------------------------------------------------------
-------approaching floor req checker---------------------------------	
  	    when S6 => 
		stt <= 6; 
		down <= '-'; 
		if (fbup_out(floor) = '1' or eb_out(floor) = '1' )
		then 
		                 Next_State <= S4; --------if approaching floor has req then opens the door 
		elsif (fbdown_out(floor) = '1')	then
				Next_State <= S0;		
		else Next_State <= S5;  ----thus if no req req remains closed
		end if;
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
	   when S7 =>
		stt <= 7;  
		if(fbup_out(floor)= '1') then
		                 Next_State <= S4;	-----goes to door open
------------------------------------------------------------------------------------------------------------------------------		
		elsif (floor=0) then	
			if ( fbup_out(1)= '1' or fbup_out(2)= '1'or fbup_out(3)= '1'or fbup_out(4)= '1' 
				or fbdown_out(1)= '1' or fbdown_out(2)= '1' or fbdown_out(3)= '1'or fbdown_out(4)= '1' or fbdown_out(5)= '1'
			        or eb_out(5)= '1' or eb_out(1)= '1' or eb_out(2)= '1' or eb_out(3)= '1'or eb_out(4)= '1' )
			then 
				down <= '0';
				Next_State <= S6;	-----checks the req of approaching floor 
			else 
				down <= '-';
				Next_State <= S9 ;	------idle state
			end if;	
------------------------------------------------------------------------------------------------------------------------------		
		elsif (floor= 1) then	
			if (fbup_out(1)= '1' or fbup_out(2)= '1' or fbup_out(3)= '1'or fbup_out(4)= '1' 
				or fbdown_out(5)= '1' or fbdown_out(4)= '1' or fbdown_out(3)= '1' or fbdown_out(2)= '1'
			        or eb_out(2)= '1' or eb_out(3)= '1' or eb_out(4)= '1' or eb_out(5)= '1' )
			then
				down <= '0';
				Next_State <= S6;
			elsif (fbdown_out(1) = '1' or fbup_out(0) = '1' or eb_out(0)= '1' )
			then
				down <= '1' ;
				Next_State <= S0;
			else 
				down <= '-';
				Next_State <= S9 ;
			end if;	
------------------------------------------------------------------------------------------------------------------------------		
		elsif (floor= 2) then	
			if (fbup_out(4)= '1' or fbup_out(3)= '1' or fbup_out(2)= '1'
				or fbdown_out(5)= '1' or fbdown_out(4)= '1' or fbdown_out(3)= '1'
			        or eb_out(5)= '1' or eb_out(4)= '1' or eb_out(3)= '1' )
			then
				down <= '0';
				Next_State <= S6;
			elsif (fbup_out(0) = '1' or fbup_out(1) = '1' 
				or fbdown_out(1) = '1' or fbdown_out(2) = '1' 
				or eb_out(1)= '1' or eb_out(0)= '1'  )
			then
				down <= '1' ;
				Next_State <= S0;
			else 
				down <= '-';
				Next_State <= S9 ;
			end if;	
------------------------------------------------------------------------------------------------------------------------------		
		elsif (floor= 3) then	
			if (fbup_out(4)= '1' or fbup_out(3)= '1' 
				or fbdown_out(5)= '1' or fbdown_out(4)= '1' 
			        or eb_out(5)= '1' or eb_out(4)= '1' )
			then
				down <= '0';
				Next_State <= S6;
			elsif (fbup_out(2) = '1' or fbup_out(1) = '1' or fbup_out(0) = '1'
				or fbdown_out(3) = '1' or fbdown_out(2) = '1' or fbdown_out(1) = '1'
				or eb_out(0)= '1' or eb_out(1)= '1' or eb_out(2)= '1'  )
			then
				down <= '1' ;
				Next_State <= S0;
			else 
				down <= '-';
				Next_State <= S9 ;
			end if;	
------------------------------------------------------------------------------------------------------------------------------		
		elsif (floor= 4) then	
			if (fbup_out(4)= '1'  
				or fbdown_out(5)= '1'
			        or eb_out(5)= '1' )
			then
				down <= '0';
				Next_State <= S6;
			elsif (fbup_out(0) = '1' or fbup_out(1) = '1' or fbup_out(2) = '1' or fbup_out(3) = '1'
				or fbdown_out(3) = '1' or fbdown_out(2) = '1' or fbdown_out(1) = '1' or fbdown_out(4) = '1'
				or eb_out(0)= '1' or eb_out(1)= '1' or eb_out(2)= '1' or eb_out(3)= '1'  )
			then
				down <= '1' ;
				Next_State <= S0;
			else 
				down <= '-';
				Next_State <= S9 ;
			end if;		
------------------------------------------------------------------------------------------------------------------------------		
		elsif (floor= 5) then	
			
			if (fbup_out(0) = '1' or fbup_out(1) = '1' or fbup_out(2) = '1' or fbup_out(3) = '1' or fbup_out(4) = '1'
			 or fbdown_out(1) = '1' or fbdown_out(2) = '1' or fbdown_out(3) = '1' or fbdown_out(4) = '1' or fbdown_out(5) = '1'
				or eb_out(0)= '1' or eb_out(1)= '1' or eb_out(2)= '1' or eb_out(3)= '1' or eb_out(4)= '1'  )
			then
				down <= '1' ;
				Next_State <= S0;
			else 
				down <= '-';
				Next_State <= S9 ;
			end if;		
		
------------------------------------------------------------------------------------------------------------------------------
		end if;
				
-----------------------------------------------------------------------------------------------------------		
-----------------------------------------------------------------------------------------------------------
	when S8 =>
		stt <= 8;
		op <= '0'; 
		r_eb(floor) <='1';
		r_fbdown(floor) <='1'; 
	--	r_fbup(floor) <='1';  
		
		down <= '-';
		                 
                Next_State <= S0;
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
	when S9 =>
		stt <= 9;
		op <= '0'; 
		r_eb(floor) <='1';
	--	r_fbdown(floor) <='1'; 
		r_fbup(floor) <='1';  
		
		down <= '-';
		                 
                Next_State <= S7;
-----------------------------------------------------------------------------------------------------------				
 
            when others =>
		stt <= 10;
                NULL;
        end case;
    
end process; 
-----------------------------------------------
-- End of Combinational Process-----------------------   
end fsm_arch;
