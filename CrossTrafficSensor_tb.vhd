library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CrossTrafficSensor_tb is
    -- Testbench does not have any ports
end CrossTrafficSensor_tb;

architecture Behavioral of CrossTrafficSensor_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component CrossTrafficSensor
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               distance : in STD_LOGIC_VECTOR(7 downto 0);
               brake_signal : out STD_LOGIC);
    end component;

    -- Signal Declaration
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal distance : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal brake_signal : STD_LOGIC;

    -- Clock generation
    constant clk_period : time := 10 ns;

begin
    uut: CrossTrafficSensor
        Port map (
            clk => clk,
            reset => reset,
            distance => distance,
            brake_signal => brake_signal
        );
    -- Clock process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stimulus_process : process
    variable calculated_distance : integer;
    begin
        -- Reset the system
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Loop to simulate different time values
        for time_ns in 0 to 300 loop
            wait for 10 ns; -- wait for clock cycle

            -- Calculate distance as integer: 
            -- Speed of Sound (in cm/ns) = 343 (scaled by factor of 1000 for integer math)
            -- Distance = (Speed of Sound * Time) / 2 (dividing by 2 to reflect distance traveled in 2 ways)
            calculated_distance := (343 * time_ns) / 2000; -- 2000 to account for scaling

            -- Make sure calculated_distance fits in 8 bits before converting
            if calculated_distance > 255 then
                calculated_distance := 255;  -- Cap at the maximum value for 8 bits
            end if;

            -- Convert calculated distance to std_logic_vector
            distance <= std_logic_vector(to_unsigned(calculated_distance, 8));

            -- Check brake signal depending on calculated distance
            if to_integer(unsigned(distance)) < 50 then
                assert (brake_signal = '1') 
                report "Brake should be applied (Distance < 50 cm) at Time: "  severity warning;
            else
                assert (brake_signal = '0') 
                report "Brake should not be applied (Distance >= 50 cm) at Time: "  severity warning;
            end if;
        end loop;

        -- End of test
        wait;
    end process;

end Behavioral;
