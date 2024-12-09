library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CrossTrafficSensor is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           distance : in STD_LOGIC_VECTOR(7 downto 0); -- Distance input in cm
           brake_signal : out STD_LOGIC);
end CrossTrafficSensor;

architecture Behavioral of CrossTrafficSensor is

    constant SAFE_DISTANCE : integer := 50; -- Safe distance in cm

begin

    process(clk, reset)
    begin
        if reset = '1' then
            brake_signal <= '0';
        elsif rising_edge(clk) then
            -- Convert distance from STD_LOGIC_VECTOR to integer
            if to_integer(unsigned(distance)) < SAFE_DISTANCE then
                brake_signal <= '1'; -- Apply brakes
            else
                brake_signal <= '0'; -- No need to apply brakes
            end if;
        end if;
    end process;

end Behavioral;
