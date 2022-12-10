library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use ieee.std_logic_unsigned.all;


entity anemometre is 
port (
	clk, in_anemometre, raz, continue, mono : in std_logic;
	nb_fm : out std_logic_vector(9 downto 0)
); 
end entity anemometre; 


architecture rtl of anemometre is 

signal enable, ResetSec : std_logic; 
signal qnb_fm : std_logic_vector(9 downto 0);	
signal qnb_sec : std_logic_vector(25 downto 0); 
signal Comp : std_logic_vector(1 downto 0); 

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
				elsif Comp = "10" then 
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
				if ResetSec = '1' then 
					Comp <= Comp + '1'; 
				end if; 
			elsif EtatPresent = ST_CONTINUE then 
				Comp <= (others => '0'); 
			elsif EtatPresent = ST_IDLEMONO then 
				Comp <= (others => '0'); 
			end if; 
		end if; 
end process; 



ufront2 : entity work.detecteur_f 
		port map (
		arst_n => raz,
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
		arst_n => raz,
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
		arst_n => '0',
		clk => clk,
		srst => ResetSec,
		en => '1',
		qn => qnb_sec
		);	
		
	ResetSec <= '1' when unsigned(qnb_sec) = X"2faf080" else '0'; 
		
	process(clk, raz) 
	begin 
	if raz = '1' then 
		nb_fm <= (others => '0'); 
	elsif rising_edge(clk) then 
		if ResetSec = '1' and EtatPresent /= ST_IDLE and EtatPresent /= ST_IDLEMONO then 
			nb_fm <= std_logic_vector(unsigned(qnb_fm) - 1); 
		end if; 
	end if; 
	end process; 
	
	end architecture; 
