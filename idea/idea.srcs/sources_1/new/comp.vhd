----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.01.2019 16:13:49
-- Design Name: 
-- Module Name: comp - Behavioral
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

entity comp is
    Port (
            x : in std_logic_vector(15 downto 0);
            x_comp : out std_logic_vector(15 downto 0)
          );
end comp;

architecture Behavioral of comp is
    
    component cla16bit is
    Port (
            a    : in std_logic_vector(15 downto 0);
            b    : in std_logic_vector(15 downto 0);
            cin  : in std_logic;
            sum  : out std_logic_vector(15 downto 0);
            cout : out std_logic
          );
    end component cla16bit;

    signal neg_x : std_logic_vector(15 downto 0);
    
begin
    
    neg_x <= not x;
    
    sum : cla16bit port map (a => neg_x, b => "0000000000000001", cin => '0', sum => x_comp, cout => open); 
    
end Behavioral;
