library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

entity compteur is 
generic(
	N : integer := 7
);
port (
	arst_n, clk, srst, en : in std_logic;
	qn : out std_logic_vector(N downto 0)
); 
end entity compteur; 


architecture rtl of compteur is 

	signal q : unsigned (N downto 0); 

begin 

	process(clk, arst_n)
		begin 
			if arst_n = '1' then 
				q(N downto 1) <= (others=>'0'); 
				q(0) <= '1'; 
			elsif rising_edge(clk) then 
				if srst = '1' then 
					q(N downto 1) <= (others=>'0'); 
					q(0) <= '1'; 
				elsif en = '0' then 
					q <= q; 
				else 
					q <= q + 1; 
				end if; 
			end if; 
	end process; 


	qn <= std_logic_vector(q); 

end architecture; 