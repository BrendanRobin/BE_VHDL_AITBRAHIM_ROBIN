library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity Gestion_ADC_MCP3201 is 
port (
		clk : in std_logic;
		raz_n : in std_logic; 
		data_in : in std_logic; 
		CS_n : out std_logic; 
		clk_adc : out std_logic;
		angle_barre : out std_logic_vector(11 downto 0)

); 
end entity Gestion_ADC_MCP3201; 

architecture rtl of Gestion_ADC_MCP3201 is 

TYPE ModeEtat_1 is (ST_IDLE, ST_ACQUISITION); 
signal EtatPresent, EtatSuivant  : ModeEtat_1;

signal clk_meg, TrigMega : std_logic;
signal qmega : std_logic_vector(9 downto 0); 
signal qms : std_logic_vector(24 downto 0); 
signal Trigms : std_logic; 
signal cp_data : std_logic_vector(7 downto 0); 
signal data : std_logic_vector(11 downto 0); 
signal Trigfm : std_logic; 
signal sdata_in, sEnable1Mg : std_logic; 
begin

CS_n <= '0' when EtatPresent = ST_ACQUISITION else '1'; 

angle_barre <= data; 


process(clk, raz_n)
begin 	
	if raz_n = '1' then 
		EtatPresent <= ST_IDLE; 
	elsif rising_edge(clk) then 
		sdata_in <= data_in;
		EtatPresent <= EtatSuivant;
	end if; 
end process; 



process(EtatPresent,raz_n, Trigms, cp_data)
	begin 
		case EtatPresent is 
			when ST_IDLE => 
				if raz_n = '1' then 
					EtatSuivant <= ST_IDLE; 
				elsif Trigms = '1' then 
					EtatSuivant <= ST_ACQUISITION;
				else 
					EtatSuivant <= ST_IDLE;
				end if; 

			when ST_ACQUISITION => 
				if raz_n = '1' then 
					EtatSuivant <= ST_IDLE; 
				elsif cp_data = X"0F" then 
					EtatSuivant <= ST_IDLE; 
				else 
					EtatSuivant <= ST_ACQUISITION; 
				end if; 
		end case; 
end process; 



process(clk, raz_n)
	begin 
		if raz_n = '1' then 
				cp_data <= (others => '0'); 
				data <= (others => '0');
		elsif rising_edge(clk) then 
			if EtatPresent = ST_IDLE then 
				cp_data <= (others => '0'); 
			elsif EtatPresent = ST_ACQUISITION then 
					if Trigfm = '1' then 
						cp_data <= cp_data + '1'; 
						data <= std_logic_vector(shift_left(unsigned(data),1));
						data(0) <= sdata_in; 
					end if; 
			end if; 
		end if; 
end process; 



ufront1Mega : entity work.detecteur_f 
		port map (
		arst_n => '0',
		clk => clk,
		s1 => clk_meg,
		trig => Trigfm,
		sig => open
		);

uCompteur100ms : entity work.compteur 
		generic map (
			N => 24
		)
		port map (
		arst_n => raz_n,
		clk => clk,
		srst => Trigms,
		en => '1',
		qn => qms
		);

Trigms <= '1' when unsigned(qms) = 5000000 else '0'; 



process(clk, raz_n)
begin
	if raz_n = '1' then 
		clk_meg <= '1'; 
	elsif rising_edge(clk) then 
		if TrigMega = '1' then 
			clk_meg <= not(clk_meg); 
		end if; 
	end if; 
end process;



sEnable1Mg <= '1' when EtatPresent = ST_ACQUISITION else '0'; 

uCompteur1mega : entity work.compteur 
		generic map (
			N => 9
		)
		port map (
		arst_n => raz_n,
		clk => clk,
		srst => TrigMega,
		en => sEnable1Mg,
		qn => qmega
		);

TrigMega <= '1' when unsigned(qmega) = X"19" else '0'; 
clk_adc <= clk_meg; 

end architecture; 