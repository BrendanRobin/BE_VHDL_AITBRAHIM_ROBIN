library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

entity testbench is
end entity testbench;

architecture rtl of testbench is
	signal arst : std_logic := '0'; 
	signal clk : std_logic := '0'; 
	signal sig : std_logic := '0';
	signal raz : std_logic := '0';
	signal continue : std_logic := '0';
	signal mono : std_logic := '0';
	
begin

	uGirouette : entity work.girouette
		port map (
				clk => clk,
				in_girouette => sig, 
				arst_i => arst, 
				raz => raz,
				continue => continue,
				mono => mono,
				direction => open 
		); 
		
	process
	variable i3 : integer := 0;
	begin
			wait for 100ns; 
			raz <= not(raz);
			wait for 1000ns; 
			raz <= not(raz);
			wait;   
	end process; 

		process
	variable i4 : integer := 0;
	begin
		while i4 < 4 loop
			wait for 2000ns; 
			continue <= not(continue);
			wait for 10000ns; 
			i4 := i4 + 1; 
		end loop;
			wait;   
	end process; 

		process
	variable i5 : integer := 0;
	begin
		while i5 < 10 loop
			wait for 8000ns; 
			mono <= not(mono);
			wait for 30ns; 
			mono <= not(mono);
			i5 := i5 + 1; 
		end loop;
			wait;   
	end process; 

	process
	variable i1 : integer := 0;
	begin
		while i1 < 60 loop
			wait for 100ns; 
			sig <= not(sig);
			wait for 600ns; 
			i1 := i1 + 1; 
		end loop;
			wait;   
	end process; 
		
	process
	variable i2 : integer := 0;
	begin
		while i2 < 6 loop
			wait for 300ns;
			arst <= not(arst);
			wait for 6000ns;
			arst <= not(arst);
			i2 := i2 + 1;
		end loop;
		wait;
	end process;
	
	process
	begin		
		wait for 5ns; 
		clk <= not(clk);
	end process;	

end architecture rtl;