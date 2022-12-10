library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity fonction7 is 
port (
		BP_Babord,BP_Tribord, BP_STBY, clk, raz : in std_logic; 
		codeFonction: out std_logic_vector(3 downto 0); 
		ledBabord, ledTribord,ledSTBY, out_bip : out std_logic
		
); 
end entity fonction7; 


architecture rtl of fonction7 is 


component buttonf7 is 
port (
		Bp_Poussoir, raz : in std_logic; 
		clk : in std_logic; 
		TrigAC, TrigAL : out std_logic
		
); 
end component buttonf7; 


TYPE ModeEtat_1 is (ST_IDLE, ST_AUTO, ST_INCR_B, ST_INCR_T, ST_INCR_10B, ST_INCR_10T, ST_MANUAL_T, ST_MANUAL_B); 
signal EtatPresent, EtatSuivant  : ModeEtat_1;

signal sBP_BabordAC, sBP_BabordAL, sBP_TribordAC, sBP_TribordAL, sBP_STBYAC, sBP_STBYAL : std_logic; 
signal Blink_led : std_logic_vector(24 downto 0); 
signal Eclat_led : std_logic_vector(15 downto 0); 
signal nb_blink : std_logic_vector(1 downto 0); 

signal etatled : std_logic; 
begin 


uButtonSTBY : component buttonf7 
	port map(
		Bp_Poussoir => BP_STBY, 
		raz => not(raz), 
		clk => clk, 
		TrigAC => sBP_STBYAC, 
		TrigAL => sBP_STBYAL
	); 

uButtonBabord : component buttonf7 
	port map(
		Bp_Poussoir => BP_Babord, 
		raz => not(raz), 
		clk => clk, 
		TrigAC => sBP_BabordAC, 
		TrigAL => sBP_BabordAL
	); 


uButtonTribord : component buttonf7 
	port map(
		Bp_Poussoir => BP_Tribord, 
		raz => not(raz), 
		clk => clk, 
		TrigAC => sBP_TribordAC, 
		TrigAL => sBP_TribordAL
	); 


process(clk, raz)
begin 	
	if raz = '1' then 
		EtatPresent <= ST_IDLE; 
	elsif rising_edge(clk) then 
		EtatPresent <= EtatSuivant;
	end if; 
end process; 


process(EtatPresent,raz,sBP_BabordAC, sBP_BabordAL, sBP_TribordAC, sBP_TribordAL, sBP_STBYAC, sBP_STBYAL, nb_blink, Eclat_led, BP_Babord, BP_Tribord)
	begin 
		case EtatPresent is 	
			when ST_IDLE => 
				if sBP_STBYAC = '1' or sBP_STBYAL = '1' then 
					EtatSuivant <= ST_AUTO; 
				elsif BP_Babord = '0'  then 
					EtatSuivant <= ST_MANUAL_B; 
				elsif BP_Tribord = '0'  then 
					EtatSuivant <= ST_MANUAL_T; 
				else 
					EtatSuivant <= ST_IDLE;
				end if; 
				
			when ST_AUTO => 
				if sBP_TribordAC = '1' then 
					EtatSuivant <= ST_INCR_T; 
				elsif sBP_BabordAC = '1' then 
					EtatSuivant <= ST_INCR_B;
				elsif sBP_BabordAL = '1' then 
					EtatSuivant <= ST_INCR_10B;
				elsif sBP_TribordAL = '1' then 
					EtatSuivant <= ST_INCR_10T;
				else 
					EtatSuivant <= ST_AUTO;
				end if; 
				
			when ST_INCR_T => 
				if Eclat_led > X"61A8" then 
					EtatSuivant <= ST_AUTO;
				else 
					EtatSuivant <= ST_INCR_T;
				end if; 
				
			when ST_INCR_B => 
				if Eclat_led > X"61A8" then 
					EtatSuivant <= ST_AUTO;
				else 
					EtatSuivant <= ST_INCR_B;
				end if; 
					
			when ST_INCR_10B => 
				if nb_blink = "10" then 
					EtatSuivant <= ST_AUTO;
				else 
					EtatSuivant <= ST_INCR_10B;
				end if; 
			
			when ST_INCR_10T => 
				if nb_blink = "10" then 
					EtatSuivant <= ST_AUTO;
				else 
					EtatSuivant <= ST_INCR_10T;
				end if; 
			
			when ST_MANUAL_B => 
				if BP_Babord = '1' then 
					EtatSuivant <= ST_IDLE;
				else 
					EtatSuivant <= ST_MANUAL_B;
				end if; 
			
			when ST_MANUAL_T => 
				if BP_Tribord = '1' then 
					EtatSuivant <= ST_IDLE;
				else 
					EtatSuivant <= ST_MANUAL_T;
				end if; 
			
		end case; 
end process;

process(clk, raz)
	begin 
		if raz = '1' then 
				ledSTBY <= '0'; 
				Blink_led <= (others => '0');
				ledBabord <= '0';
				ledTribord <= '0'; 
				Eclat_led <= (others => '0');
				nb_blink <= (others => '0');
				etatled <= '0'; 
		elsif rising_edge(clk) then 

		
			if EtatPresent = ST_IDLE then 
				Blink_led <= Blink_led + '1'; 
				if Blink_led > X"E4E1C0" then 
					ledSTBY <= etatled; 
					etatled <= not (etatled); 
					Blink_led <= (others => '0');
				end if; 
				codeFonction <= "0000"; 
			
				
			elsif EtatPresent = ST_AUTO then 
				ledSTBY <= '1';
				ledTribord <= '0'; 
				ledBabord <= '0'; 
				codeFonction <= "0011"; 
				Eclat_led <= (others => '0');
				nb_blink <= (others => '0');
				
				
			
			elsif EtatPresent = ST_INCR_T then
				Eclat_led <= Eclat_led + '1'; 
				ledTribord <= '1'; 
				codeFonction <= "0100"; 
					if Eclat_led > X"E4E1C0" then 
						ledTribord <= '0'; 
					end if; 
					
			elsif EtatPresent = ST_INCR_B then
				Eclat_led <= Eclat_led + '1'; 
				ledBabord <= '1'; 
				codeFonction <= "0111"; 
					if Eclat_led > X"E4E1C0" then 
						ledBabord <= '0'; 
					end if; 

			
			elsif EtatPresent = ST_INCR_10B then
				Eclat_led <= Eclat_led + '1'; 
				ledBabord <= '1'; 
				codeFonction <= "0110";
					if Eclat_led > X"E4E1C0" then 
						ledBabord <= '0'; 
						Eclat_led <= (others => '0');
						nb_blink <= nb_blink + '1'; 
					end if; 
				

			elsif EtatPresent = ST_INCR_10T then
				Eclat_led <= Eclat_led + '1'; 
				ledTribord <= '1'; 
				codeFonction <= "0101";
					if Eclat_led > X"E4E1C0" then 
						ledTribord <= '0'; 
						Eclat_led <= (others => '0');
						nb_blink <= nb_blink + '1'; 
					end if; 
				
			elsif EtatPresent = ST_MANUAL_T then
				codeFonction <= "0010";
			
			elsif EtatPresent = ST_MANUAL_B then
				codeFonction <= "0001";
				
			end if; 
		end if; 
end process; 




end architecture; 