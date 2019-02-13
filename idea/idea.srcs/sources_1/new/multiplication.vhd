----------------------------------------------------------------------------------
-- Nume : Niculescu
-- Prenume : Mihai Alexandru
-- Grupa : 335CB
--
-- Project : idea
-- File : multiplication.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplication is
    Port (
            a : in std_logic_vector(15 downto 0);    -- al doilea numar
            b : in std_logic_vector(15 downto 0);    -- primul numar
            mult : out std_logic_vector(31 downto 0) -- rezulatatul inmultirii 
           );
end multiplication;

architecture Behavioral of multiplication is

    component cla16bit is
        Port (
                a    : in std_logic_vector(15 downto 0);
                b    : in std_logic_vector(15 downto 0);
                cin  : in std_logic;
                sum  : out std_logic_vector(15 downto 0);
                cout : out std_logic
              );
    end component cla16bit;
   
   type MAT is array (0 to 15) of std_logic_vector(15 downto 0);
   type MAT1 is array (0 to 14) of std_logic_vector(15 downto 0);
   signal A_mat : MAT;
   signal And_mat : MAT;
   signal Sum_mat : MAT1;

begin

     -- extinderea fiecarui lui a(i) la un vector
     Init_A: for ii in 0 to 15 generate
        A_mat(ii) <= (others => a(ii));        
     end generate Init_A;    

    -- calcularea and pentru fiecare numar
    Init_and: for ii in 0 to 15 generate
        And_mat(ii) <= A_mat(ii) and b;
    end generate Init_and; 
    
    -- primul bit
    mult(0) <= a(0) and b(0);
    
    -- primul sumator caz special 
    sumator0: cla16bit PORT MAP(
                                a(14 downto 0) => And_mat(0)(15 downto 1),
                                a(15) => '0',
                                b => And_mat(1),
                                cin => '0',
                                sum(0) => mult(1),
                                sum(15 downto 1) => Sum_mat(0)(14 downto 0),
                                cout => Sum_mat(0)(15)
                                );
                                
    -- celelalte sumatoare
    Sum_generator: for ii in 1 to 14 generate
        Sumator: cla16bit PORT MAP (
                            a => And_mat(ii + 1),
                            b => Sum_mat(ii - 1),
                            cin => '0',
                            sum(0) => mult(ii + 1),
                            sum(15 downto 1) => Sum_mat(ii)(14 downto 0),
                            cout => Sum_mat(ii)(15)
                            );
    end generate Sum_generator; 
    
    -- ultimi bit
    mult(31 downto 16) <= Sum_mat(14);


end Behavioral;
