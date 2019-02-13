----------------------------------------------------------------------------------
-- Nume : Niculescu
-- Prenume : Mihai Alexandru
-- Grupa : 335CB
--
-- Project : idea
-- File : key_decryption.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_decryption is
    Port (
          key_original : in std_logic_vector(127 downto 0);
          number_round : in std_logic_vector(3 downto 0);
          new_key      : out std_logic_vector(127 downto 0)
          );
end key_decryption;

architecture Behavioral of key_decryption is
    component calc_inversMod is
        Port (
            x_input : in std_logic_vector(15 downto 0);
             invMod  : out std_logic_vector(15 downto 0)
          );    
    end component calc_inversMod;

    component comp is
    Port (
            x : in std_logic_vector(15 downto 0);
            x_comp : out std_logic_vector(15 downto 0)
          );
    end component comp;

    signal K1, K2, K3, K4, K5, K6 : std_logic_vector(15 downto 0);
    
    signal prev_key : std_logic_vector(127 downto 0);
    signal current_key : std_logic_vector(127 downto 0);

begin

    invMod1 : calc_inversMod port map (x_input => K1, invMod => new_key(127 downto 112));
    comp1 : comp port map (x => K2, x_comp => new_key(111 downto 96));
    comp2 : comp port map (x => K3, x_comp => new_key(95 downto 80));
    invMod2 : calc_inversMod port map (x_input => K4, invMod => new_key(79 downto 64));
    new_key(63 downto 48) <= K5;
    new_key(47 downto 32) <= K6;
    new_key(31 downto 0) <= (others => '0');
    
    prev_key <= key_original(102 downto 0) & key_original(127 downto 103) when  number_round = "1000"  else
               key_original(52 downto 0) & key_original(127 downto 53) when number_round = "0101"  else  
               key_original(27 downto 0) & key_original(127 downto 28) when number_round = "0100"  else  
               key_original(105 downto 0) & key_original(127 downto 106) when number_round = "0001";
               
    current_key <= key_original(102 downto 0) & key_original(127 downto 103) when number_round = "0111"  else
                key_original(77 downto 0) & key_original(127 downto 78) when (number_round = "0101" or number_round = "0110")  else  
                key_original(52 downto 0) & key_original(127 downto 53) when number_round = "0100" else  
                key_original(27 downto 0) & key_original(127 downto 28) when number_round = "0011" else  
                key_original(2 downto 0) & key_original(127 downto 3) when (number_round = "0010" or  number_round = "0001");               
  
    K1 <= prev_key(127 downto 112)  when number_round = "0001" else
          current_key(95 downto 80) when number_round = "0010" else
          current_key(63 downto 48) when number_round = "0011" else
          current_key(31 downto 16) when number_round = "0100" else
          prev_key(127 downto 112) when number_round = "0101" else
          current_key(95 downto 80) when number_round = "0110" else
          current_key(63 downto 48) when number_round = "0111" else
          key_original(31 downto 16) when number_round = "1000" else
          key_original(127 downto 112) when number_round = "1001";      

    K2 <= prev_key(111 downto 96)  when number_round = "0001" else
          current_key(63 downto 48) when number_round = "0010" else
          current_key(31 downto 16) when number_round = "0011" else
          prev_key(127 downto 112) when number_round = "0100" else
          prev_key(95 downto 80) when number_round = "0101" else
          current_key(63 downto 48) when number_round = "0110" else
          current_key(31 downto 16) when number_round = "0111" else
          prev_key(127 downto 112) when number_round = "1000" else
          key_original(111 downto 96) when number_round = "1001";      

    K3 <= prev_key(95 downto 80)  when number_round = "0001" else
          current_key(79 downto 64) when number_round = "0010" else
          current_key(47 downto 32) when number_round = "0011" else
          current_key(15 downto 0) when number_round = "0100" else
          prev_key(111 downto 96) when number_round = "0101" else
          current_key(79 downto 64) when number_round = "0110" else
          current_key(47 downto 32) when number_round = "0111" else
          key_original(15 downto 0) when number_round = "1000" else
          key_original(95 downto 80) when number_round = "1001";      

    K4 <= prev_key(79 downto 64)  when number_round = "0001" else
          current_key(47 downto 32) when number_round = "0010" else
          current_key(15 downto 0) when number_round = "0011" else
          prev_key(111 downto 96) when number_round = "0100" else
          prev_key(79 downto 64) when number_round = "0101" else
          current_key(47 downto 32) when number_round = "0110" else
          current_key(15 downto 0) when number_round = "0111" else
          prev_key(111 downto 96) when number_round = "1000" else
          key_original(79 downto 64) when number_round = "1001";      

    K5 <= current_key(31 downto 16)  when number_round = "0001" else
          current_key(127 downto 112) when number_round = "0010" else
          current_key(95 downto 80) when number_round = "0011" else
          current_key(63 downto 48) when number_round = "0100" else
          current_key(31 downto 16) when number_round = "0101" else
          current_key(127 downto 112) when number_round = "0110" else
          current_key(95 downto 80) when number_round = "0111" else
          key_original(63 downto 48) when number_round = "1000" else
          "0000000000000000" when number_round = "1001";      

    K6 <= current_key(15 downto 0)  when number_round = "0001" else
          current_key(111 downto 96) when number_round = "0010" else
          current_key(79 downto 64) when number_round = "0011" else
          current_key(47 downto 32) when number_round = "0100" else
          current_key(15 downto 0) when number_round = "0101" else
          current_key(111 downto 96) when number_round = "0110" else
          current_key(79 downto 64) when number_round = "0111" else
          key_original(47 downto 32) when number_round = "1000" else
          "0000000000000000" when number_round = "1001";      
   
          
end Behavioral;
