----------------------------------------------------------------------------------
-- Nume : Niculescu
-- Prenume : Mihai Alexandru
-- Grupa : 335CB
--
-- Project : floating point multiplication
-- File : cla24bit.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla20bit is
    Port (
            a    : in std_logic_vector(19 downto 0);
            b    : in std_logic_vector(19 downto 0);
            cin  : in std_logic;
            sum  : out std_logic_vector(19 downto 0);
            cout : out std_logic
           );
end cla20bit;

architecture Behavioral of cla20bit is

    component cla4bit is
        Port ( 
                a    : in std_logic_vector(3 downto 0);
                b    : in std_logic_vector(3 downto 0);
                cin  : in std_logic; 
                sum  : out std_logic_vector(3 downto 0);
                cout : out std_logic
             );
    end component cla4bit;
    
    signal p : std_logic_vector(19 downto 0);
    signal g : std_logic_vector(19 downto 0);
    signal c : std_logic_vector(5 downto 0);
    signal p_aux : STD_LOGIC_VECTOR(4 downto 0);
    signal g_aux : STD_LOGIC_VECTOR(4 downto 0);

begin

    adder_4bit1 : cla4bit PORT MAP(
                                   a => a(3 downto 0),
                                   b => b(3 downto 0),
                                   cin => c(0),
                                   sum => sum(3 downto 0),
                                   cout => open
                                   );
                                                 
    adder_4bit2 : cla4bit PORT MAP(
                                   a => a(7 downto 4),
                                   b => b(7 downto 4),
                                   cin => c(1),
                                   sum => sum(7 downto 4),
                                   cout => open
                                   );                                   

    adder_4bit3 : cla4bit PORT MAP(
                                   a => a(11 downto 8),
                                   b => b(11 downto 8),
                                   cin => c(2),
                                   sum => sum(11 downto 8),
                                   cout => open
                                   );
                                                 
    adder_4bit4 : cla4bit PORT MAP(
                                   a => a(15 downto 12),
                                   b => b(15 downto 12),
                                   cin => c(3),
                                   sum => sum(15 downto 12),
                                   cout => open
                                   );

    adder_4bit5 : cla4bit PORT MAP(
                                   a => a(19 downto 16),
                                   b => b(19 downto 16),
                                   cin => c(4),
                                   sum => sum(19 downto 16),
                                   cout => open
                                   );
   
    p <= a or b;
    g <= a and b;
                                  
    p_aux(0) <= p(0) and p(1) and p(2) and p(3);
    p_aux(1) <= p(4) and p(5) and p(6) and p(7);
    p_aux(2) <= p(8) and p(9) and p(10) and p(11);
    p_aux(3) <= p(12) and p(13) and p(14) and p(15);
    p_aux(4) <= p(16) and p(17) and p(18) and p(19);                                              
                                      
    g_aux(0) <= g(3) or ( p(3) and g(2) ) or ( p(3) and p(2) and g(1) ) or ( p(3) and p(2) and p(1) and g(0) );
    g_aux(1) <= g(7) or ( p(7) and g(6) ) or ( p(7) and p(6) and g(5) ) or ( p(7) and p(6) and p(5) and g(4) );
    g_aux(2) <= g(11) or ( p(11) and g(10) ) or ( p(11) and p(10) and g(9) ) or ( p(11) and p(10) and p(9) and g(8) );
    g_aux(3) <= g(15) or ( p(15) and g(14) ) or ( p(15) and p(14) and g(13) ) or ( p(15) and p(14) and p(13) and g(12) );
    g_aux(4) <= g(19) or ( p(19) and g(18) ) or ( p(19) and p(18) and g(17) ) or ( p(19) and p(18) and p(17) and g(16) );
                                      
    c(0) <= cin;
    c(1) <= g_aux(0) or ( p_aux(0) and c(0) );
    c(2) <= g_aux(1) or ( p_aux(1) and c(1) );
    c(3) <= g_aux(2) or ( p_aux(2) and c(2) );
    c(4) <= g_aux(3) or ( p_aux(3) and c(3) );
    c(5) <= g_aux(4) or ( p_aux(4) and c(4) );
                                      
    cout <= c(5);
                                                                                                             
end Behavioral;
