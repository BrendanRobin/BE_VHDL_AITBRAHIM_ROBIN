library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

entity avalon_f6 is 
port (
		clk : in std_logic; 
		Data_i : in std_logic; 
		Cs_o : out std_logic; 
		Clk_adc_o : out std_logic;
		Pwm_o : out std_logic;
		Sens_o : out std_logic; 
		arst_i : in std_logic; 
		address_i : in std_logic_vector(3 downto 0);
		write_data_i : in std_logic_vector(31 downto 0);
		write_i : in std_logic;
		read_i : in std_logic;
		read_data_o : out std_logic_vector(31 downto 0)
); 
end entity avalon_f6; 

architecture rtl of avalon_f6 is 

 	component pwm_gestion is
		port (
			clk : in std_logic; 
			arst_i : in std_logic; 
			Duty : in std_logic_vector(15 downto 0); 
			Freq : in std_logic_vector(15 downto 0); 
			Enable_pwm : in std_logic; 
			PWM_o : out std_logic
		);
	end component pwm_gestion;
	
	component controle_butees is 
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
end component controle_butees; 
	
	component Gestion_ADC_MCP3201 is 
	port (
		clk : in std_logic;
		raz_n : in std_logic; 
		data_in : in std_logic; 
		CS_n : out std_logic; 
		clk_adc : out std_logic;
		angle_barre : out std_logic_vector(11 downto 0)
		); 
end component Gestion_ADC_MCP3201; 
	
	signal sFreq, sDuty, sButee_g, sButee_d, sConfig, sAngle_barre : std_logic_vector(31 downto 0); 
	
	signal ssAngle_barre : std_logic_vector(31 downto 0); 
	signal pwm : std_logic; 

begin 



process (clk, arst_i)
    begin
        if arst_i = '0' then
        elsif rising_edge(clk) then
            if write_i = '1' then
                case to_integer(unsigned(address_i)) is
                    when 16#00# =>
                        sFreq <= write_data_i;
                    when 16#01# =>
                        sDuty <= write_data_i;
                    when 16#02# =>
                        sButee_g <= write_data_i;
                    when 16#03# =>
                        sButee_d <= write_data_i;
                    when 16#04# =>
                        sConfig(2 downto 0) <= write_data_i(2 downto 0);
                    when 16#05# =>
                    when others =>
                end case;
            end if;
        end if;
    end process;
	 
	 
	 

				
read_data_o 	<= sFreq when unsigned(address_i) = 16#00# else 
					 sDuty when to_integer(unsigned(address_i)) = 16#01# else
					 sButee_g when to_integer(unsigned(address_i)) = 16#02# else
					 sButee_d when to_integer(unsigned(address_i)) = 16#03# else
					 sConfig when to_integer(unsigned(address_i)) = 16#04# else
					 sAngle_barre when to_integer(unsigned(address_i)) = 16#05# else X"00000000"; 
			 
		
		

 
	uControlButee : component controle_butees 
		port map (
				clk => clk, 
				angle_barre => sAngle_barre(11 downto 0),
				sens => sConfig(2),
				pwm => pwm, 
				butee_d => sButee_d(15 downto 0),
				butee_g => sButee_g(15 downto 0), 
				pwm_o => Pwm_o, 
				sens_o => Sens_o, 
				fin_course_d => sConfig(3),
				fin_course_g => sConfig(4)
		);
	 
	uGestion_pwm : component pwm_gestion
		port map (
				clk => clk, 
				arst_i => not(sConfig(0)), 
				Duty => sDuty(15 downto 0),
				Freq => sFreq(15 downto 0),
				PWM_o => pwm,
				Enable_pwm => sConfig(1)
		); 


	uADC : component Gestion_ADC_MCP3201
		port map(
				clk => clk, 
				raz_n => not(sConfig(0)),
				data_in => Data_i,
				CS_n => Cs_o, 
				clk_adc => Clk_adc_o,
				angle_barre => sAngle_barre(11 downto 0)
		);
		
		
		

end architecture; 