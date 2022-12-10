library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 


entity testbench is
end entity testbench;


architecture rtl of testbench is
	signal arst : std_logic := '0'; 
	signal clk : std_logic := '0'; 
	signal sig : std_logic := '0';
begin




	--uut //instantiation pour connecter port a_i � a, b_i � b et s open
	u0_front_montant : entity work.detecteur_fm
		port map (
			arst_n=> arst, 
			clk=> clk, 
			s1=> sig, 
			trig => open
		); 
		
		
	--stimulus //pour simuler les valeurs des ports nous-m�me
	process
	variable i1 : integer := 0;
	begin
		while i1 < 31 loop
			wait for 100ns; 
			sig <= not(sig);
			i1 := i1 + 1;
		end loop;
		wait;   
	end process; 
		
	process
	variable i2 : integer := 0;
	begin
		while i2 < 3 loop
			wait for 500ns;
			arst <= not(arst);
			i2 := i2 + 1;
		end loop;
		wait;
	end process;
	
	process
	begin		
		wait for 10ns; 
		clk <= not(clk);
	end process;	
	
end architecture rtl;