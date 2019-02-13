----------------------------------------------------------------------------------
-- Nume : Niculescu
-- Prenume : Mihai Alexandru
-- Grupa : 335CB
--
-- Project : idea
-- File : cla4bit.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla4bit is
    Port (
            a    : in std_logic_vector(3 downto 0);
            b    : in std_logic_vector(3 downto 0);
            cin  : in std_logic; 
            sum  : out std_logic_vector(3 downto 0);
            cout : out std_logic
            );
end cla4bit;

architecture Behavioral of cla4bit is

    signal p : std_logic_vector(3 downto 0); -- propagare
    signal g : std_logic_vector(3 downto 0); -- generare
    signal c : std_logic_vector(4 downto 0); -- carry

begin
    
    p <= a xor b;
    g <= a and b;
    
        -- calcularea carry folosind formulele
    c(0) <= cin;
    c(1) <= g(0) or ( p(0) and c(0) );
    c(2) <= g(1) or ( p(1) and c(1) );
    c(3) <= g(2) or ( p(2) and c(2) );
    c(4) <= g(3) or ( p(3) and c(3) );
        
    cout <= c(4);

    -- calcularea sumei
    sum(0) <= p(0) xor c(0);
    sum(1) <= p(1) xor c(1);
    sum(2) <= p(2) xor c(2);
    sum(3) <= p(3) xor c(3);

end Behavioral;