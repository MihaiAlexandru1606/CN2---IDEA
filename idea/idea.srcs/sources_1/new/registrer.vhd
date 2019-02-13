----------------------------------------------------------------------------------
-- Nume : Niculescu
-- Prenume : Mihai Alexandru
-- Grupa : 335CB
--
-- Project : floating point multiplication
-- File : register.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registrer is
    generic(DataWidth : integer);   -- lungimea unui registru

    Port (
            d : in std_logic_vector(DataWidth - 1 downto 0);
            clk : in  std_logic;
            load : in std_logic;
            reset : in std_logic;
            q : out std_logic_vector(DataWidth - 1 downto 0)
          );
end registrer;

architecture Behavioral of registrer is

begin

    process (d, clk, load) is
    begin       
        if (load = '1' and rising_edge(clk) and clk = '1') then
            q <= d;
        end if;
            
        if (reset = '1') then
            q <= (others => '0');
        end if;
             
    end process;

end Behavioral;