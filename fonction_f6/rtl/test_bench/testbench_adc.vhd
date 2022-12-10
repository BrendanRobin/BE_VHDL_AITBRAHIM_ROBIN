library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

entity testbench_adc is 
end entity testbench_adc; 

architecture rtl of testbench_adc is

	signal arst : std_logic := '1'; 
	signal clk : std_logic := '0'; 
	signal data : std_logic := '0'; 

begin

	uAdc : entity work.Gestion_ADC_MCP3201
		port map (
			clk => clk, 
			raz_n => arst, 
			data_in => data, 
			CS_n => open,
			clk_adc => open,
			angle_barre => open
		); 
		
	process
	begin
		wait for 1000ns;
		arst <= not(arst);
		wait;
	end process;
	
	process
	begin		
		wait for 10ns; 
		clk <= not(clk);
	end process;

	
	
	process
	variable i4 : integer := 0;
	begin	
		while i4 < 30 loop
			wait for 1000ns; 
			data <= not(data);
			i4 := i4 + 1; 
		end loop;

	end process;

	
	
	
	
	
	
	
	
	
	
	
	
	
end architecture; 