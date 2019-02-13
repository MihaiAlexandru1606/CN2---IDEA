----------------------------------------------------------------------------------
-- Nume : Niculescu
-- Prenume : Mihai Alexandru
-- Grupa : 335CB
--
-- Project : floating point multiplication
-- File : multiplication.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplication1 is
    Port (
            a : in std_logic_vector(19 downto 0);    -- al doilea numar
            b : in std_logic_vector(19 downto 0);    -- primul numar
            mult : out std_logic_vector(39 downto 0) -- rezulatatul inmultirii 
           );
end multiplication1;

architecture Behavioral of multiplication1 is

    component cla20bit is
        Port (
                a    : in std_logic_vector(19 downto 0);
                b    : in std_logic_vector(19 downto 0);
                cin  : in std_logic;
                sum  : out std_logic_vector(19 downto 0);
                cout : out std_logic
            );
    end component cla20bit;
   
   type MAT is array (0 to 19) of std_logic_vector(19 downto 0);
   type MAT1 is array (0 to 18) of std_logic_vector(19 downto 0);
   signal A_mat : MAT;
   signal And_mat : MAT;
   signal Sum_mat : MAT1;

begin

     -- extinderea fiecarui lui a(i) la un vector
     Init_A: for ii in 0 to 19 generate
        A_mat(ii) <= (others => a(ii));        
     end generate Init_A;    

    -- calcularea and pentru fiecare numar
    Init_and: for ii in 0 to 19 generate
        And_mat(ii) <= A_mat(ii) and b;
    end generate Init_and; 
    
    -- primul bit
    mult(0) <= a(0) and b(0);
    
    -- primul sumator caz special 
    sumator0: cla20bit PORT MAP(
                                a(18 downto 0) => And_mat(0)(19 downto 1),
                                a(19) => '0',
                                b => And_mat(1),
                                cin => '0',
                                sum(0) => mult(1),
                                sum(19 downto 1) => Sum_mat(0)(18 downto 0),
                                cout => Sum_mat(0)(19)
                                );
                                
    -- celelalte sumatoare
    Sum_generator: for ii in 1 to 18 generate
        Sumator: cla20bit PORT MAP (
                            a => And_mat(ii + 1),
                            b => Sum_mat(ii - 1),
                            cin => '0',
                            sum(0) => mult(ii + 1),
                            sum(19 downto 1) => Sum_mat(ii)(18 downto 0),
                            cout => Sum_mat(ii)(19)
                            );
    end generate Sum_generator; 
    
    -- ultimi bit
    mult(39 downto 20) <= Sum_mat(18);


end Behavioral;
