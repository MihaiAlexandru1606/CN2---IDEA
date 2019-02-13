----------------------------------------------------------------------------------
-- Nume : Niculescu
-- Prenume : Mihai Alexandru
-- Grupa : 335CB
--
-- Project : idea
-- File : cla16bit.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla16bit is
    Port (
            a   : in std_logic_vector(15 downto 0);
            b   : in std_logic_vector(15 downto 0);
            cin : in std_logic;
            sum : out std_logic_vector(15 downto 0);
            cout: out std_logic 
          );
end cla16bit;

architecture Behavioral of cla16bit is
    
    component cla4bit is
        Port (
              a    : in std_logic_vector(3 downto 0);
              b    : in std_logic_vector(3 downto 0);
              cin  : in std_logic; 
              sum  : out std_logic_vector(3 downto 0);
              cout : out std_logic
            );
    end component cla4bit;

    signal p : STD_LOGIC_VECTOR(15 downto 0);
    signal g : STD_LOGIC_VECTOR(15 downto 0);
    signal c : STD_LOGIC_VECTOR(4 downto 0);
    signal p_aux : STD_LOGIC_VECTOR(3 downto 0);
    signal g_aux : STD_LOGIC_VECTOR(3 downto 0);
    
begin
    
    cla4 : for i in 0 to 3 generate
        
        adder: cla4bit PORT MAP (
                                 a => a(3 + 4 * i downto 4 *i),
                                 b => b(3 + 4 * i downto 4 *i),
                                 cin => c(i),
                                 sum => sum(3 + 4 * i downto 4 *i),
                                 cout => open
                                 );   
    end generate cla4;

    p <= a or b;
    g <= a and b;

    p_aux(0) <= p(0) and p(1) and p(2) and p(3);
    p_aux(1) <= p(4) and p(5) and p(6) and p(7);
    p_aux(2) <= p(8) and p(9) and p(10) and p(11);
    p_aux(3) <= p(12) and p(13) and p(14) and p(15);
    
    g_aux(0) <= g(3) or ( p(3) and g(2) ) or ( p(3) and p(2) and g(1) ) or ( p(3) and p(2) and p(1) and g(0) );
    g_aux(1) <= g(7) or ( p(7) and g(6) ) or ( p(7) and p(6) and g(5) ) or ( p(7) and p(6) and p(5) and g(4) );
    g_aux(2) <= g(11) or ( p(11) and g(10) ) or ( p(11) and p(10) and g(9) ) or ( p(11) and p(10) and p(9) and g(8) );
    g_aux(3) <= g(15) or ( p(15) and g(14) ) or ( p(15) and p(14) and g(13) ) or ( p(15) and p(14) and p(13) and g(12) );
    
    c(0) <= cin;
    c(1) <= g_aux(0) or ( p_aux(0) and c(0) );
    c(2) <= g_aux(1) or ( p_aux(1) and c(1) );
    c(3) <= g_aux(2) or ( p_aux(2) and c(2) );
    c(4) <= g_aux(3) or ( p_aux(3) and c(3) );
    cout <= c(4);
    
end Behavioral;
