library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 


entity testtop is
end entity testtop;


architecture rtl of testtop is
	signal clk : std_logic := '0'; 
	signal s1 : std_logic := '0';
	signal s2 : std_logic := '0';
begin


	--uut //instantiation pour connecter port a_i ? a, b_i ? b et s open
	u0_top : entity work.top
		port map (
			clk=> clk, 
			s1 => s1,
			s2 => s2
		); 
	--stimulus //pour simuler les valeurs des ports nous-m?me
	
	process
	variable i1 : integer := 0;
	begin
		while i1 < 31 loop
			wait for 3ms; 
			s1 <= not(s1);
			i1 := i1 + 1;
		end loop;
		wait;   
	end process; 
	
	
	process
	variable i5 : integer := 0;
	begin
		while i5 < 10000 loop
			wait for 25us; 
			s2 <= not(s2);
			i5 := i5 + 1;
		end loop;
		wait;   
	end process; 
		
--	process
	--variable i2 : integer := 0;
--	begin
	--	while i2 < 3 loop
		--	wait for 500ns;
		--	arst <= not(arst);
		--	i2 := i2 + 1;
	--	end loop;
	--	wait;
--	end process;
	
	process
	begin		
		wait for 10ns; 
		clk <= not(clk);
	end process;	
	
end architecture rtl;