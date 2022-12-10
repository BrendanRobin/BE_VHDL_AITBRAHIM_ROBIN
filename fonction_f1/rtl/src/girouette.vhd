library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity girouette is 
port (
	clk, in_girouette, raz, continue, mono : in std_logic;
	direction : out std_logic_vector(9 downto 0)
); 
end entity girouette; 


architecture rtl of girouette is 

signal Comp : std_logic_vector(1 downto 0); 
signal Compms : std_logic_vector(12 downto 0); 
signal q, ResetCompt : std_logic;
signal qetat_haut : std_logic_vector(9 downto 0); 
signal n_raz: std_logic; 

TYPE ModeEtat_1 is (ST_IDLE, ST_CONTINUE, ST_MONO, ST_IDLEMONO); 
signal EtatPresent, EtatSuivant  : ModeEtat_1; 

begin 



process(clk, raz)
begin 	
	if raz = '1' then 
		EtatPresent <= ST_IDLE; 
	elsif rising_edge(clk) then 
		EtatPresent <= EtatSuivant;
	end if; 
end process; 

process(EtatPresent,raz,mono,continue, Comp)
	begin 
		case EtatPresent is 
			when ST_IDLE => 
				if raz = '1' then 
					EtatSuivant <= ST_IDLE; 
				elsif continue = '1' then 
					EtatSuivant <= ST_CONTINUE;
				elsif mono = '1' then 
					EtatSuivant <= ST_MONO;
				else 
					EtatSuivant <= ST_IDLE;
				end if; 

			when ST_CONTINUE => 
				if raz = '1' then 
					EtatSuivant <= ST_IDLE; 
				elsif continue = '0' then 
					EtatSuivant <= ST_IDLE; 
				else 
					EtatSuivant <= ST_CONTINUE; 
				end if; 

			when  ST_MONO => 
				if raz = '1' then 
					EtatSuivant <= ST_IDLE; 
				elsif Comp = "10"  then 
					EtatSuivant <= ST_IDLEMONO;
				elsif continue = '1' then 
					EtatSuivant <= ST_CONTINUE;
				else 
					EtatSuivant <= ST_MONO;
				end if; 
				
			when ST_IDLEMONO => 
				if mono = '0' then 
					EtatSuivant <= ST_IDLE; 
				elsif raz = '1' then 
					EtatSuivant <= ST_IDLE;
				elsif continue = '1' then 
					EtatSuivant <= ST_CONTINUE;
				else
					EtatSuivant <= ST_IDLEMONO; 
				end if; 
		end case; 
end process; 

process(clk, raz)
	begin 
		if raz = '1' then 
				Comp <= (others => '0'); 
		elsif rising_edge(clk) then 
			if EtatPresent = ST_IDLE then 
				Comp <= (others => '0'); 
			elsif EtatPresent = ST_MONO then 
				if q = '1' then 
					Comp <= Comp + '1'; 
				end if; 
			elsif EtatPresent = ST_CONTINUE then 
					Comp <= (others => '0'); 
			elsif EtatPresent = ST_IDLEMONO then 
					Comp <= (others => '0'); 
			end if; 
		end if; 
end process; 

	ufront1 : entity work.detecteur_f 
		port map (
		arst_n => '0',
		clk => clk,
		s1 => in_girouette,
		trig => q,
		sig => open
		);

	uCompteur1 : entity work.compteur 
		generic map (
			N => 12
			)
		port map (
		arst_n => raz,
		clk => clk,
		srst => ResetCompt,
		en => in_girouette,
		qn => Compms
		);
		
ResetCompt <= '1' when 	unsigned(Compms) = X"1388"else '0'; 			
		
	uCompteur2 : entity work.compteur 
		generic map (
			N => 9
			)
		port map (
		arst_n => raz,
		clk => clk,
		srst => q,
		en => ResetCompt,
		qn => qetat_haut
		);		
 		
	process(clk, raz) 
	begin 
	if raz = '1' then 
		direction <= (others => '0'); 
	elsif rising_edge(clk) then 
		if q = '1' and EtatPresent /= ST_IDLE and EtatPresent /= ST_IDLEMONO then 
			if unsigned(qetat_haut) > 370 then 
				direction <= "0101101000"; 
			elsif unsigned(qetat_haut) < 11 then 
				direction <= "0000000000"; 
			else 
				direction <= std_logic_vector(unsigned(qetat_haut) - 11); 
			end if; 
		end if; 
	end if; 
	end process; 
		
end architecture;