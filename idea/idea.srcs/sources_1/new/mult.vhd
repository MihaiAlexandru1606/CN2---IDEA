----------------------------------------------------------------------------------
-- Nume : Niculescu
-- Prenume : Mihai Alexandru
-- Grupa : 335CB
--
-- Project : idea
-- File : mult.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mult is
    Port (
            a   : in std_logic_vector(15 downto 0);
            b   : in std_logic_vector(15 downto 0);
            multMod : out std_logic_vector(15 downto 0)
          );
end mult;

architecture Behavioral of mult is

    component  multiplication is
        Port (
              a : in std_logic_vector(15 downto 0);    -- al doilea numar
              b : in std_logic_vector(15 downto 0);    -- primul numar
              mult : out std_logic_vector(31 downto 0) -- rezulatatul inmultirii 
             );
    end component multiplication;

    signal lo : std_logic_vector(15 downto 0);
    signal hi : std_logic_vector(15 downto 0);
    signal aux : integer;
    
begin
    
    multip : multiplication PORT MAP (
                                      a => a,
                                      b => b,
                                      mult(31 downto 16) => hi,
                                      mult(15 downto 0) => lo  
                                     );
                 
    aux <= 65537 + to_integer(unsigned(lo)) - to_integer(unsigned(hi)) when (lo < hi) else
           to_integer(unsigned(lo)) - to_integer(unsigned(hi))                            ;
    
    multMod <= std_logic_vector(to_unsigned(aux, multMod'length));
    
    
end Behavioral;
