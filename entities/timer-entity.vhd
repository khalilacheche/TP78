--A basic timer module.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity timer is
generic(FCLK : natural := 10);
--Clock frequency. Keep the default low value for simulation.
--Set to hardware clock frequency (e.g., 12 MHz) for board testing.
--You can use a 32-bit tick counter.
port(clk     : in std_logic;
     --System clock.
     clear   : in std_logic;
     --Synchronously clears both the internal tick counter and the second counter.
     en      : in std_logic;
     --Enables counting.
     timeout : in std_logic_vector(4 downto 0);
     --Specifies the number of seconds that the timer should count.
     pulse   : out std_logic;
     --A pulse signal with the pulsing frequency of 1 Hz.
     done    : out std_logic);
     --Indicates that the specified number of seconds has passed.
end entity timer;
