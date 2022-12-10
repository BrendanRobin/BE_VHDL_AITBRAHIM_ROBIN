library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity avalonf7 is 
port (
		clk : in std_logic; 
		BP_Babord,BP_Tribord, BP_STBY: in std_logic; 
		ledBabord, ledTribord, ledSTBY, out_bip : out std_logic;
		arst_i : in std_logic; 
		address_i : in std_logic_vector(3 downto 0);
		write_data_i : in std_logic_vector(31 downto 0);
		write_i : in std_logic;
		read_i : in std_logic;
		read_data_o : out std_logic_vector(31 downto 0)
); 
end entity avalonf7; 



architecture rtl of avalonf7 is 



component fonction7 is 
	port (
		BP_Babord,BP_Tribord, BP_STBY, clk, raz : in std_logic; 
		codeFonction: out std_logic_vector(3 downto 0); 
		ledBabord, ledTribord,ledSTBY, out_bip : out std_logic
	); 
	end component fonction7; 


	
signal sConfig, sCode : std_logic_vector(31 downto 0); 
signal scodeFonction : std_logic_vector(3 downto 0); 

begin 



	
	
process (clk, arst_i)
    begin
        if arst_i = '0' then
        elsif rising_edge(clk) then
            if write_i = '1' then
                case to_integer(unsigned(address_i)) is
                    when 16#00# =>
                        sConfig <= write_data_i;
                    when 16#01# =>
                    when others =>
                end case;
            end if;
        end if;
    end process;
	 
	 
	 		
read_data_o 	<= sConfig when unsigned(address_i) = 16#00# else 
						sCode when to_integer(unsigned(address_i)) = 16#01# else X"00000000"; 
					 
					 

sCode (3 downto 0) <= scodeFonction; 		 
					 
uGestionButton : component fonction7
	port map (
			BP_Babord => BP_Babord, 
			BP_Tribord => BP_Tribord, 
			BP_STBY => BP_STBY, 
			clk => clk, 
			raz => '0',
			codeFonction => scodeFonction,
			ledBabord => ledBabord,
			ledTribord => ledTribord, 
			ledSTBY => ledSTBY, 
			out_bip => out_bip
	); 

		
	 





end architecture; 