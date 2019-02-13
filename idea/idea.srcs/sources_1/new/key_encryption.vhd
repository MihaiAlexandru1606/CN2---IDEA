----------------------------------------------------------------------------------
-- Nume : Niculescu
-- Prenume : Mihai Alexandru
-- Grupa : 335CB
--
-- Project : idea
-- File : key_encryption.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity key_encryption is
    Port (
          key_original : in std_logic_vector(127 downto 0);
          number_round : in std_logic_vector(3 downto 0);
          new_key      : out std_logic_vector(127 downto 0)
          );
end key_encryption;

architecture Behavioral of key_encryption is

    signal prev_key : std_logic_vector(127 downto 0);
    signal current_key : std_logic_vector(127 downto 0);

begin
    
    current_key <= key_original(102 downto 0) & key_original(127 downto 103) when number_round = "0010"  else
                   key_original(77 downto 0) & key_original(127 downto 78) when (number_round = "0011" or number_round = "0100")  else  
                   key_original(52 downto 0) & key_original(127 downto 53) when number_round = "0101" else  
                   key_original(27 downto 0) & key_original(127 downto 28) when number_round = "0110" else  
                   key_original(2 downto 0) & key_original(127 downto 3) when (number_round = "1000" or  number_round = "0111") else
                   key_original(105 downto 0) & key_original(127 downto 106) when number_round = "1001";
                   
    
    prev_key <= key_original(102 downto 0) & key_original(127 downto 103) when number_round = "0011" else
                key_original(52 downto 0) & key_original(127 downto 53) when number_round = "0110" else
                key_original(27 downto 0) & key_original(127 downto 28) when number_round = "0111";
               
    new_key <= key_original when number_round = "0001" else
               key_original(31 downto 0) & current_key(127 downto 32) when number_round = "0010" else
               prev_key(63 downto 0) & current_key(127 downto 64) when number_round = "0011" else
               current_key(95 downto 0) & key_original(127 downto 96) when number_round = "0100" else
               current_key when number_round = "0101" else
               prev_key(31 downto 0) & current_key(127 downto 32) when number_round = "0110" else
               prev_key(63 downto 0) & current_key(127 downto 64) when number_round = "0111" else
               current_key(95 downto 0) & key_original(127 downto 96) when number_round = "1000" else
               current_key when number_round = "1001";
               
end Behavioral;
