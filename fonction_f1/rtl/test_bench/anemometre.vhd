library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use ieee.std_logic_unsigned.all;


entity anemometre is 
port (
	clk, in_anemometre, arst_i, raz, continue, mono : in std_logic;
	nb_fm : out std_logic_vector(9 downto 0)
); 
end entity anemometre; 


architecture rtl of anemometre is 

signal enable, ResetSec : std_logic; 
signal qnb_fm : std_logic_vector(9 downto 0);	
signal qnb_sec : std_logic_vector(25 downto 0); 

signal reset_sig: std_logic; 
signal raz_sig: std_logic; 
signal Comp : std_logic_vector(1 downto 0); 

TYPE ModeEtat_1 is (ST_IDLE, ST_CONTINUE, ST_RAZ, ST_MONO); 
signal EtatPresent, EtatSuivant  : ModeEtat_1; 


begin 


raz_sig <= '1' when EtatPresent = ST_RAZ or EtatPresent = ST_IDLE else '0'; 
reset_sig <= (not(raz_sig) and arst_i); 

process(clk, reset_sig)
begin 	
	if arst_i = '0' then 
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
					EtatSuivant <= ST_RAZ; 
				elsif mono = '1' then 
					EtatSuivant <= ST_MONO;
				elsif continue = '1' then 
					EtatSuivant <= ST_CONTINUE;
				else 
					EtatSuivant <= ST_IDLE;
				end if; 

			when ST_RAZ => 
				EtatSuivant <= ST_IDLE; 

			when ST_CONTINUE => 
				if raz = '1' then 
					EtatSuivant <= ST_RAZ; 
				elsif continue = '0' then 
					EtatSuivant <= ST_IDLE; 
				else 
					EtatSuivant <= ST_CONTINUE; 
				end if; 

			when  ST_MONO => 
				if raz = '1' then 
					EtatSuivant <= ST_RAZ; 
				elsif Comp = "10" and mono = '0' then 
					EtatSuivant <= ST_IDLE;
				else 
					EtatSuivant <= ST_MONO;
				end if; 
		end case; 
end process; 

process(clk, reset_sig)
	begin 
		if reset_sig = '0' then 
				Comp <= (others => '0'); 
		elsif rising_edge(clk) then 
			if EtatPresent = ST_IDLE then 
				Comp <= (others => '0'); 
			elsif EtatPresent = ST_RAZ then 
			elsif EtatPresent = ST_MONO then 
				if ResetSec = '1' then 
					Comp <= Comp + '1'; 
				end if; 
			elsif EtatPresent = ST_CONTINUE then 
			end if; 
		end if; 
end process; 



ufront2 : entity work.detecteur_f 
		port map (
		arst_n => arst_i,
		clk => clk,
		s1 => in_anemometre,
		trig => enable,
		sig => open
		);
		
	uCompteur3 : entity work.compteur 
		generic map (
			N => 9
			)
		port map (
		arst_n => arst_i,
		clk => clk,
		srst => ResetSec,
		en => enable,
		qn => qnb_fm
		);
		
	uCompteurSec : entity work.compteur 
		generic map (
			N => 25
			)
		port map (
		arst_n => arst_i,
		clk => clk,
		srst => ResetSec,
		en => '1',
		qn => qnb_sec
		);	
		
	ResetSec <= '1' when unsigned(qnb_sec) = X"20" else '0'; 
		
	process(clk) 
	begin 
	if rising_edge(clk) then 
		if ResetSec = '1' then 
			nb_fm <= std_logic_vector(unsigned(qnb_fm) - 1); 
		end if; 
	end if; 
	end process; 
	
	end architecture; 
