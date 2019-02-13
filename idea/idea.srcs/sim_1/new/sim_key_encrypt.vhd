----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2019 21:24:17
-- Design Name: 
-- Module Name: sim_key_encrypt - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim_key_encrypt is
--  Port ( );
end sim_key_encrypt;

architecture Behavioral of sim_key_encrypt is
    component key_schedule is
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
     
     end component;
     
     signal key_original : std_logic_vector(127 downto 0) := "00000000011001000000000011001000000000010010110000000001100100000000000111110100000000100101100000000010101111000000001100100000";
     signal number_round : std_logic_vector(3 downto 0);
     signal encrypt      : std_logic := '0';
     signal K1           : std_logic_vector(15 downto 0);
     signal K2           : std_logic_vector(15 downto 0);
     signal K3           : std_logic_vector(15 downto 0);
     signal K4           : std_logic_vector(15 downto 0);
     signal K5           : std_logic_vector(15 downto 0);
     signal K6           : std_logic_vector(15 downto 0);
     
begin
    
    uutl : key_schedule port map (
                                  key_original => key_original,
                                  number_round => number_round,
                                  encrypt => encrypt, 
                                  K1 => K1, 
                                  K2 => K2, 
                                  K3 => K3,
                                  K4 => K4,
                                  K5 => K5,
                                  K6 => K6
                                  );
    
    ceva: process
    begin
        number_round <= "0001";     
        wait for 100ns;
        number_round <= "0010";     
        wait for 100ns;
        number_round <= "0011";     
        wait for 100ns;
        number_round <= "0100";     
        wait for 100ns;
        number_round <= "0101";     
        wait for 100ns;
        number_round <= "0110";     
        wait for 100ns;
        number_round <= "0111";     
        wait for 100ns;
        number_round <= "1000";     
        wait for 100ns;
        number_round <= "1001";     
        wait for 100ns;        
    end process;

end Behavioral;
