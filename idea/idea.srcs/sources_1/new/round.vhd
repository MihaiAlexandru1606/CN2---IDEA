----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.01.2019 15:18:32
-- Design Name: 
-- Module Name: round - Behavioral
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

entity round is
    Port (
            input : in std_logic_vector(196 downto 0);
            output : out std_logic_vector(196 downto 0)
          );
end round;

architecture Behavioral of round is

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

    component cla4bit is
    Port (
            a    : in std_logic_vector(3 downto 0);
            b    : in std_logic_vector(3 downto 0);
            cin  : in std_logic; 
            sum  : out std_logic_vector(3 downto 0);
            cout : out std_logic
            );
    end component cla4bit;

    type MAT is array (1 to 14) of std_logic_vector(15 downto 0);
    signal P : MAT;
    signal K1, K2, K3, K4, K5, K6 : std_logic_vector(15 downto 0);
    
    signal Po1, Po2, Po3, Po4 : std_logic_vector(15 downto 0);
    signal numb : std_logic_vector(3 downto 0);
    
begin
    
    numb <= input(131 downto 128);
    Po1 <= input(196 downto 181);
    Po2 <= input(180 downto 165);
    Po3 <= input(164 downto 149);
    Po4 <= input(148 downto 133);
    
    generate_key : key_schedule PORT MAP(
                                         key_original => input(127 downto 0),
                                         number_round => input(131 downto 128),
                                         encrypt => input(132),
                                         K1 => K1, K2 => K2, K3 => K3, K4 => K4, K5 => K5, K6 => K6
                                         );
                                         
    step1  : mult PORT MAP ( a => input(196 downto 181), b => K1, multMod => P(1) );                                      
    step2  : add PORT MAP (a => input(180 downto 165), b => K2, sum => P(2));
    step3  : add PORT MAP (a => input(164 downto 149), b => K3, sum => P(3));
    step4  : mult PORT MAP (a => input(148 downto 133), b => K4, multMod => P(4) );
    step5  : P(5) <= P(1) xor P(3);
    step6  : P(6) <= P(2) xor P(4);
    step7  : mult PORT MAP (a => P(5), b => K5, multMod => P(7));
    step8  : add PORT MAP (a => P(6), b => P(7), sum => P(8));
    step9  : mult PORT MAP (a => P(8), b => K6, multMod => P(9));
    step10 : add PORT MAP (a => P(7), b => P(9), sum => P(10));
    step11 : P(11) <= P(1) xor P(9);
    step12 : P(12) <= P(3) xor P(9);
    step13 : P(13) <= P(2) xor P(10);
    step14 : P(14) <= P(4) xor P(10);
    
    next_round : cla4bit PORT MAP (a => "0001", b => input(131 downto 128), cin => '0', sum => output(131 downto 128), cout => open);
    
    output(127 downto 0) <= input(127 downto 0);
    output(132) <= input(132);
    output(196 downto 181) <= P(11);
    output(164 downto 149) <= P(13);
    output(180 downto 165) <= P(12);
    output(148 downto 133) <= P(14);
    
end Behavioral;
