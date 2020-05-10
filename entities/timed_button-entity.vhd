--Button synchronizing and debouncing circuit with a 1 second pause.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity timed_button is
port(clk      : in std_logic;
     --System clock.
     button   : in std_logic;
     --Input from the button.
     clear    : in std_logic;
     --Clears the debouncer and restarts the timer.
     button_o : out std_logic);
     --Debounced output.
end entity timed_button;
