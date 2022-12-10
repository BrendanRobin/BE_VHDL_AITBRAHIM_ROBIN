library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

entity detecteur_f is 
port (
	arst_n, clk, s1 : in std_logic;
	trig, sig : out std_logic
); 
end entity detecteur_f; 


architecture rtl of detecteur_f is 

	signal ss1, sss1 : std_logic;

begin 

	process(clk, arst_n)
		begin 
			if arst_n = '1' then 
				ss1 <= '0';
				sss1 <= '0'; 
			elsif rising_edge(clk) then
				ss1 <= s1;
				sss1 <= ss1; 
			end if;
	end process; 

	trig <= '1' when sss1 = '0' and ss1 = '1' else '0'; 

	sig <= ss1; 

end architecture; 