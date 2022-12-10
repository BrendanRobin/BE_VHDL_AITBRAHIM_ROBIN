library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

entity testbench_pwm is 
end entity testbench_pwm; 




architecture rtl of testbench_pwm is
	signal arst : std_logic := '1'; 
	signal clk : std_logic := '0'; 
	signal freq : std_logic_vector(15 downto 0) := X"07D0"; 
	signal duty : std_logic_vector(15 downto 0) := X"03E8"; 

	
begin

	uPWM : entity work.pwm_gestion
		port map (
				clk => clk,
				arst_i => arst, 
				Duty => duty,
				Freq => freq,
				PWM_o => open
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

	
	
	
end architecture; 