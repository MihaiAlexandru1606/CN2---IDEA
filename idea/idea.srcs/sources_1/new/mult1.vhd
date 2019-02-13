----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.01.2019 15:45:30
-- Design Name: 
-- Module Name: mult1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mult1 is
    Port (
            a   : in std_logic_vector(19 downto 0);
            b   : in std_logic_vector(19 downto 0);
            multMod : out std_logic_vector(19 downto 0)
          );
end mult1;

architecture Behavioral of mult1 is

    component  multiplication1 is
        Port (
              a : in std_logic_vector(19 downto 0);    -- al doilea numar
              b : in std_logic_vector(19 downto 0);    -- primul numar
              mult : out std_logic_vector(39 downto 0) -- rezulatatul inmultirii 
             );
    end component multiplication1;

    signal lo : std_logic_vector(15 downto 0);
    signal hi : std_logic_vector(23 downto 0);
    signal aux : integer;
    
begin
    
    multip : multiplication1 PORT MAP (
                                      a => a,
                                      b => b,
                                      mult(39 downto 16) => hi,
                                      mult(15 downto 0) => lo  
                                     );
                 
    aux <= 65537 + to_integer(unsigned(lo)) - to_integer(unsigned(hi)) when (to_integer(unsigned(lo)) < to_integer(unsigned(hi))) else
           to_integer(unsigned(lo)) - to_integer(unsigned(hi))                            ;
    
    multMod <= std_logic_vector(to_unsigned(aux, multMod'length));
    
end Behavioral;
