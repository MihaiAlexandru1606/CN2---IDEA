----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2019 14:04:31
-- Design Name: 
-- Module Name: calc_inversMod - Behavioral
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

entity calc_inversMod is
    Port (
           x_input : in std_logic_vector(15 downto 0);
           invMod  : out std_logic_vector(15 downto 0)
          );
end calc_inversMod;

architecture Behavioral of calc_inversMod is
    
    component mult1 is
        Port (
               a   : in std_logic_vector(19 downto 0);
               b   : in std_logic_vector(19 downto 0);
               multMod : out std_logic_vector(19 downto 0)
            );
    end component mult1;
    
    type MAT is array (0 to 16) of std_logic_vector(19 downto 0);
    signal x   : MAT;
    signal pow : MAT; 
    
begin

    calcul: for i in 0 to 15 generate
       
       pow_calc  : mult1 PORT MAP (
                                  a       => x(i),
                                  b       => pow(i),
                                  multMod => pow(i + 1)
                                  );
        
        x_update : mult1 PORT MAP (
                                  a       => x(i),
                                  b       => x(i),
                                  multMod => x(i + 1) 
                                  );
    end generate calcul;
    
    x(0)   <= "0000" & x_input;
    pow(0) <= "00000000000000000001";

    invMod <= pow(16)(15 downto 0);
    
end Behavioral;
