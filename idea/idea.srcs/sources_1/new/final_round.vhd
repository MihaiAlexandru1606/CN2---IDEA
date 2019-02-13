----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2019 15:19:40
-- Design Name: 
-- Module Name: final_round - Behavioral
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

entity final_round is
    Port (
        input : in std_logic_vector(196 downto 0);
        output : out std_logic_vector(196 downto 0)
      );
end final_round;

architecture Behavioral of final_round is

    component add is
        Port (
              a   : in std_logic_vector(15 downto 0);
              b   : in std_logic_vector(15 downto 0);
              sum : out std_logic_vector(15 downto 0)
             );
    end component add;
    
    component mult is
        Port (
                a   : in std_logic_vector(15 downto 0);
                b   : in std_logic_vector(15 downto 0);
                multMod : out std_logic_vector(15 downto 0)
              );
    end component mult;
    
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
          
    end component key_schedule;

    signal K1, K2, K3, K4, K5, K6 : std_logic_vector(15 downto 0);
    signal P1, P2, P3, P4 : std_logic_vector(15 downto 0);
    signal R1, R2, R3, R4 : std_logic_vector(15 downto 0);
        
begin
        generate_key : key_schedule PORT MAP(
                                     key_original => input(127 downto 0),
                                     number_round => input(131 downto 128),
                                     encrypt => input(132),
                                     K1 => K1, K2 => K2, K3 => K3, K4 => K4, K5 => K5, K6 => K6
                                     );

    step1  : mult PORT MAP ( a => input(196 downto 181), b => K1, multMod => R1 );                                      
    step2  : add PORT MAP (a => input(164 downto 149) , b => K2, sum => R2);
    step3  : add PORT MAP (a => input(180 downto 165), b => K3, sum => R3);
    step4  : mult PORT MAP (a => input(148 downto 133), b => K4, multMod => R4 );
    
    P1 <= input(196 downto 181);
    P2 <= input(180 downto 165);
    P3 <= input(164 downto 149);
    P4 <= input(148 downto 133);
    
    output(196 downto 181) <= R1;
    output(180 downto 165) <= R2;
    output(164 downto 149) <= R3;
    output(148 downto 133) <= R4;
    
    output (132 downto 0) <= (others => '0');
    
end Behavioral;
