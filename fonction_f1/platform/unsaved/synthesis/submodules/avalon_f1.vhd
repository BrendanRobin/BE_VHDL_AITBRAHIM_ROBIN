library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

entity avalon_f1 is 
port (
		clk : in std_logic; 
		arst_i : in std_logic; 
		in_girouette : in std_logic; 
		in_anemometre : in std_logic; 
		address_i : in std_logic_vector(0 downto 0);
		write_data_i : in std_logic_vector(31 downto 0);
		write_i : in std_logic;
		read_i : in std_logic;
		read_data_o : out std_logic_vector(31 downto 0)
); 
end entity avalon_f1; 




architecture rtl of avalon_f1 is 


 	component anemometre is
		port (
			clk, in_anemometre, raz, continue, mono : in std_logic;
			nb_fm : out std_logic_vector(9 downto 0)
		);
	end component anemometre;


 	component girouette is
		port (
			clk, in_girouette, raz, continue, mono : in std_logic;
			direction : out std_logic_vector(9 downto 0)
		);
	end component girouette;
 

 signal direction_s : std_logic_vector(9 downto 0); 
 signal frequence_s : std_logic_vector(9 downto 0);
 signal direction_config, frequence_config : std_logic_vector(2 downto 0); 
 
 
 
 signal dir, freq : std_logic_vector(31 downto 0); 

begin



process (clk, arst_i)
    begin
        if arst_i = '0' then
            direction_config <= (others => '0');
				frequence_config <= (others => '0');
        elsif rising_edge(clk) then
            if write_i = '1' then
                case to_integer(unsigned(address_i)) is
                    when 16#00# =>
                        direction_config <= write_data_i(2 downto 0);
                    when 16#01# =>
                        frequence_config <= write_data_i(2 downto 0);
                    when others =>
                end case;
            end if;
        end if;
    end process;
	 
	 
	 
read_data_o 	<= dir when unsigned(address_i) = 16#00# else 
					 freq when to_integer(unsigned(address_i)) = 16#01# else X"00000000"; 


		  	
dir(31 downto 26) <= std_logic_vector(to_unsigned(0, 32-26)); 
dir(25 downto 16) <= direction_s; 
dir(15 downto 3) <= 	std_logic_vector(to_unsigned(0, 16-3)); 
dir(2 downto 0) <= direction_config;   


freq(31 downto 26) <= std_logic_vector(to_unsigned(0, 32-26));  
freq(25 downto 16) <= frequence_s; 
freq(15 downto 3) <=	std_logic_vector(to_unsigned(0, 16-3)); 
freq(2 downto 0) <= frequence_config;   

		  
	uGirouette : component girouette
		port map (
			clk => clk,
			in_girouette => in_girouette, 
			direction => direction_s,
			raz => direction_config(0),
			continue => direction_config(1),
			mono => direction_config(2)
		); 
				
				
	uAnemometre : component anemometre
		port map (
			clk => clk,
			in_anemometre => in_anemometre, 
			nb_fm => frequence_s,
			raz => frequence_config(0),
			continue => frequence_config(1),
			mono => frequence_config(2)
		); 
		
		
end architecture; 