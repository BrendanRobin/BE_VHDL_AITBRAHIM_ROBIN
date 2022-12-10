library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

entity pwm_gestion is 
port (
		clk : in std_logic; 
		arst_i : in std_logic; 
		Duty : in std_logic_vector(15 downto 0); 
		Freq : in std_logic_vector(15 downto 0); 
		Enable_pwm : in std_logic; 
		PWM_o : out std_logic
); 
end entity pwm_gestion; 




architecture rtl of pwm_gestion is 


signal TrigReset : std_logic; 
signal sqn : std_logic_vector(32 downto 0); 
signal sPwm : std_logic; 

begin 


uCompteur_fm : entity work.compteur 
		generic map (
			N => 32
			)
		port map (
		arst_n => arst_i,
		clk => clk,
		srst => TrigReset,
		en => Enable_pwm,
		qn => sqn
		);




TrigReset <= '1' when unsigned(sqn) > unsigned(Freq) else '0'; 
		
sPwm <= '1' when unsigned(sqn) < unsigned(Duty) else '0'; 
				
PWM_o <= sPwm; 
		
end architecture; 