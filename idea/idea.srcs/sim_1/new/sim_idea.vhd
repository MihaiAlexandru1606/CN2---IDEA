----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2019 23:09:09
-- Design Name: 
-- Module Name: sim_idea - Behavioral
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

entity sim_idea is
--  Port ( );
end sim_idea;

architecture Behavioral of sim_idea is

    component idea is
    Port (
            input        : in std_logic_vector(63 downto 0);
            key_original : in std_logic_vector(127 downto 0);
            encrypt      : in std_logic;
            clk          : in std_logic;
            output       : out std_logic_vector(63 downto 0)
          );
    end component idea;
    
    signal clk : std_logic := '0';
    constant clk_period : time := 1 ns;
    
    signal key_original : std_logic_vector(127 downto 0);
    signal encrypt      : std_logic ;  
    signal input : std_logic_vector(63 downto 0);
    signal output : std_logic_vector(63 downto 0);
    
begin
    
   clk_process :process
   begin
       clk <= '1';
       wait for clk_period/2;  
       clk <= '0';
       wait for clk_period/2;  
   end process;
    
   uttl : idea port map (input => input, key_original => key_original, encrypt => encrypt, clk => clk, output => output); 

   ceva : process
   begin
        key_original <= "00000000011001000000000011001000000000010010110000000001100100000000000111110100000000100101100000000010101111000000001100100000";
        input <= "0000010100110010000010100110010000010100110010000001100111111010";
        encrypt <= '1';
        wait for clk_period;
        encrypt <= '0';
        input <= "0110010110111110100001111110011110100010010100111000101011101101";
        wait for clk_period;
        
        key_original <= "01001100011000010111011101110010011010010110010101000010011100100110111101110111011011100101100001011001010110100101000001010001";
        encrypt <= '1';
        input <= "0100110001100001011101110111001001101001011001010010011101110011";
        wait for clk_period;
        encrypt <= '0';
        input <= "1010000100001110100010111111011011111010111100001111011010111101";
        wait for clk_period;
        
        encrypt <= '1';
        key_original <= "01111100101000010001000001000101010010100001101001101110010101110000000110100001110101101101000000111001011101110110011101000010";
        input <= "0110100100001111010110110000110110011010001001101001001110011011";
        wait for clk_period;
        encrypt <= '0';
        input <= "0001101111011101101100100100001000010100001000110111111011000111";
        wait for clk_period;
        
        encrypt <= '1';
        key_original <= "11011111100000010011100010001010010010011111000001100111000100001010111110011110000000011101010110010000110100000011011001100110";
        input <= "1011111000111000001000010010010010110001110001101101111011101101";
        wait for clk_period;
        encrypt <= '0';
        input <= "1101001101010000111011010001010110111001110110001001000011111100";
        wait for clk_period;
   end process;
end Behavioral;
