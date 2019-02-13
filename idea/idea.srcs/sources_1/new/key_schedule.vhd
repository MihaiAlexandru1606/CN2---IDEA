----------------------------------------------------------------------------------
-- Nume : Niculescu
-- Prenume : Mihai Alexandru
-- Grupa : 335CB
--
-- Project : idea
-- File : key_schedule.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity key_schedule is
    Port (
            key_original : in std_logic_vector(127 downto 0);
            number_round : in std_logic_vector(3 downto 0);
            encrypt      : in std_logic;
            K1           : out std_logic_vector(15 downto 0);
            K2           : out std_logic_vector(15 downto 0);
            K3           : out std_logic_vector(15 downto 0);
            K4           : out std_logic_vector(15 downto 0);
            K5           : out std_logic_vector(15 downto 0);
            K6           : out std_logic_vector(15 downto 0)           
          );
          
end key_schedule;

architecture Behavioral of key_schedule is
    
    component key_encryption is
        Port (
              key_original : in std_logic_vector(127 downto 0);
              number_round : in std_logic_vector(3 downto 0);
              new_key      : out std_logic_vector(127 downto 0)
             );
    end component key_encryption;
    
    component key_decryption is
        Port (
              key_original : in std_logic_vector(127 downto 0);
              number_round : in std_logic_vector(3 downto 0);
              new_key      : out std_logic_vector(127 downto 0)
              );
    end component key_decryption;
    
    signal encrypt_key : std_logic_vector(127 downto 0);
    signal decrypt_key : std_logic_vector(127 downto 0);
    signal current_key : std_logic_vector(127 downto 0);
    
begin

    encryp : key_encryption PORT MAP (
                                       key_original => key_original,
                                       number_round => number_round,
                                       new_key => encrypt_key
                                       );   
     
    decrypt : key_decryption PORT MAP (
                                       key_original => key_original,
                                       number_round => number_round,
                                       new_key => decrypt_key
                                       );   
    
    current_key <= encrypt_key when (encrypt = '1') else
                   decrypt_key;
        
    K1 <= current_key(127 downto 112);
    K2 <= current_key(111 downto 96);
    K3 <= current_key(95 downto 80);
    K4 <= current_key(79 downto 64);
    K5 <= current_key(63 downto 48);
    K6 <= current_key(47 downto 32);
    
end Behavioral;
