----------------------------------------------------------------------------------
-- Nume : Niculescu
-- Prenume : Mihai Alexandru
-- Grupa : 335CB
--
-- Project : idea
-- File : add.vhd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add is
    Port (
            a   : in std_logic_vector(15 downto 0);
            b   : in std_logic_vector(15 downto 0);
            sum : out std_logic_vector(15 downto 0)
          );
end add;

architecture Behavioral of add is
    
    component cla16bit is
        Port (
              a   : in std_logic_vector(15 downto 0);
              b   : in std_logic_vector(15 downto 0);
              cin : in std_logic;
              sum : out std_logic_vector(15 downto 0);
              cout: out std_logic 
             ); 
    end component cla16bit;
    
begin

    cla: cla16bit PORT MAP (
                            a => a,
                            b => b,
                            cin => '0',
                            sum => sum,
                            cout => open
                            );

end Behavioral;
