library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity buttonf7 is 
port (
		Bp_Poussoir, raz : in std_logic; 
		clk : in std_logic; 
		TrigAC, TrigAL : out std_logic
		
); 
end entity buttonf7; 



architecture rtl of buttonf7 is 

TYPE ModeEtat_1 is (ST_IDLE, ST_ETATACTIF); 
signal EtatPresent, EtatSuivant  : ModeEtat_1;

signal compteur, scompteur : std_logic_vector(31 downto 0); 
signal sTrigAC, sTrigAL : std_logic; 

begin 


process(clk, raz)
begin 	
	if raz = '0' then 
		EtatPresent <= ST_IDLE; 
	elsif rising_edge(clk) then 
		EtatPresent <= EtatSuivant;
	end if; 
end process; 


process(EtatPresent,raz,Bp_Poussoir)
	begin 
		case EtatPresent is 
			when ST_IDLE =>  
				if Bp_Poussoir = '0' then 
					EtatSuivant <= ST_ETATACTIF; 
				else 
					EtatSuivant <= ST_IDLE;
				end if; 
				
			when ST_ETATACTIF => 
				if Bp_Poussoir = '1' then 
					EtatSuivant <= ST_IDLE; 
				elsif raz = '0' then 
					EtatSuivant <= ST_IDLE;
				else 
					EtatSuivant <= ST_ETATACTIF;
				end if; 
		end case; 
end process;

process(clk) 
	begin 
		if raz = '0' then 
			compteur <= (others => '0'); 
		elsif rising_edge(clk) then 
			if EtatPresent = ST_IDLE then 
				compteur <= (others => '0'); 
			else 
				compteur <= compteur + '1'; 
			end if; 
		end if; 
end process; 


sTrigAC <= '1' when EtatPresent = ST_IDLE and unsigned(scompteur) > X"C350" and unsigned(scompteur) < X"8F0D180" else '0'; 

sTrigAL <= '1' when EtatPresent = ST_IDLE and unsigned(scompteur) > X"8F0D180" else '0';  

process(clk) 
	begin 
		if rising_edge(clk) then
			scompteur <= compteur; 
			TrigAL <= sTrigAL;
			TrigAC <= sTrigAC;
		end if; 
end process; 

end architecture;  