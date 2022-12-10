library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

entity controle_butees is 
port (
		clk : in std_logic;
		angle_barre : in std_logic_vector(11 downto 0); 
		sens : in std_logic; 
		pwm : in std_logic;
		butee_d : in std_logic_vector(15 downto 0);
		butee_g : in std_logic_vector(15 downto 0);
		pwm_o : out std_logic; 
		sens_o : out std_logic;
		fin_course_d, fin_course_g : out std_logic

); 
end entity controle_butees; 


architecture rtl of controle_butees is 

signal s1, s2 : std_logic; 
signal angle_barre_sig : std_logic_vector(11 downto 0); 


begin 

process(clk)
	begin
	if rising_edge(clk) then
		sens_o <= sens; 
		if s1 = '1' or  s2 ='1' then 
			pwm_o <= '0';
		else 
			pwm_o <= pwm;
		end if; 
	end if;
end process;



process(clk)
	begin 
		if rising_edge(clk) then 
			angle_barre_sig <= angle_barre; 
		end if; 
end process; 


s1 <= '1' when unsigned(angle_barre_sig) > unsigned(butee_d) else '0'; 

s2 <= '1' when unsigned(angle_barre_sig) < unsigned(butee_g) else '0';


fin_course_d <= s1; 
fin_course_g <= s2; 


end architecture; 

