----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2019 15:19:55
-- Design Name: 
-- Module Name: idea - Behavioral
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

entity idea is
    Port (
            input        : in std_logic_vector(63 downto 0);
            key_original : in std_logic_vector(127 downto 0);
            encrypt      : in std_logic;
            clk          : in std_logic;
            output       : out std_logic_vector(63 downto 0)
          );
end idea;

architecture Behavioral of idea is

    component round is
    Port (
            input : in std_logic_vector(196 downto 0);
            output : out std_logic_vector(196 downto 0)
          );
    end  component round;
    
    component final_round is
        Port (
            input : in std_logic_vector(196 downto 0);
            output : out std_logic_vector(196 downto 0)
          );
    end component final_round;

    component registrer is
        generic(DataWidth : integer);   -- lungimea unui registru

        Port (
                d : in std_logic_vector(DataWidth - 1 downto 0);
                clk : in  std_logic;
                load : in std_logic;
                reset : in std_logic;
                q : out std_logic_vector(DataWidth - 1 downto 0)
               );
    end component registrer;

    type BUSS_DATA is array(0 to 17) of std_logic_vector(196 downto 0);
    signal buss : BUSS_DATA; 
    signal dump : std_logic_vector(132 downto 0);

begin
    
    reg0 : registrer generic map(DataWidth => 197) 
                     port map( d(196 downto 133) => input, d(132) => encrypt, d(131 downto 128) => "0001", 
                               d(127 downto 0) => key_original, clk => clk, load => '1', reset => '0', q => buss(0) );   

   generat: for i in 1 to 8 generate
        
        rnd:  round PORT MAP ( input => buss( 2* (i - 1) ), output => buss( 2* (i - 1) + 1) );
        reg:  registrer generic map(DataWidth => 197)
                        port map (d => buss( 2* (i - 1 ) +1 ), clk => clk, load => '1', reset => '0', q => buss(2 * i) );
        
    end generate generat;
  
    final: final_round port map ( input => buss(16), output => buss(17) );
    
    final_reg : registrer generic map(DataWidth => 197)
                          port map (d => buss(17), clk => clk, load => '1', reset => '0', q(196 downto 133) => output, q(132 downto 0) => dump);                      
    
end Behavioral;
