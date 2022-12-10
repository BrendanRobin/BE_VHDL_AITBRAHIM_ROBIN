library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity avalon is
    port (
        arst_i : in std_logic;
        clk_i : in std_logic;
        address_i : in std_logic_vector(1 downto 0);
        write_i : in std_logic;
        write_data_i : in std_logic_vector(31 downto 0);
        byte_enable_i : in std_logic_vector(3 downto 0);
        read_i : in std_logic;
        read_data_o : out std_logic_vector(31 downto 0);
        wait_request_o : out std_logic
    );
end entity avalon;

architecture rtl of avalon is
    signal reg, reg_byte_enable : std_logic_vector(31 downto 0);
    signal read_count : unsigned(31 downto 0);
    signal d_read : std_logic;
begin
    
    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            reg <= (others => '0');
            reg_byte_enable <= (others => '0');
        elsif rising_edge(clk_i) then
            if write_i = '1' then
                case to_integer(unsigned(address_i)) is
                    when 0 =>
                        reg <= write_data_i;
                    when 1 =>
                        -- Ecriture masqué
                        if byte_enable_i(0) = '1' then
                            reg_byte_enable(7 downto 0) <= write_data_i(7 downto 0);
                        end if;
                        if byte_enable_i(1) = '1' then
                            reg_byte_enable(15 downto 8) <= write_data_i(15 downto 8);
                        end if;
                        if byte_enable_i(2) = '1' then
                            reg_byte_enable(23 downto 16) <= write_data_i(23 downto 16);
                        end if;
                        if byte_enable_i(3) = '1' then
                            reg_byte_enable(31 downto 24) <= write_data_i(31 downto 24);
                        end if;
                    when others =>
                end case;
            end if;
        end if;
    end process;

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            read_count <= (others => '0');
        elsif rising_edge(clk_i) then
            if read_i = '1' and (unsigned(address_i) = 2 or unsigned(address_i) = 3) then
                read_count <= read_count + 1;
            end if;
        end if;
    end process;
    
    -- On retarde le signal read_i pour pouvoir detecter un front montant sur read_i
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            d_read <= read_i;
        end if;
    end process;

    -- On met wait_request_o à 1 si on est sur un front montant de read_i (read_i = '1' and d_read = '0') et si on
    -- lit à l'adresse 3. Le but est de montrer que read_count s'incremente de 2 quand on lit à l'adresse 3 car on 
    -- met le processeur en attente.
    wait_request_o <= 
        '1' when read_i = '1' and d_read = '0' and unsigned(address_i) = 3 else
        '0';

    read_data_o <= 
        reg when unsigned(address_i) = 0 else
        reg_byte_enable when unsigned(address_i) = 1 else
        std_logic_vector(read_count);
end architecture rtl;