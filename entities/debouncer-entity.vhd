--Implements button synchronization and debouncing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity debouncer is
port(clk      : in std_logic;
     --System clock.
     button   : in std_logic;
     --Input from the button.
     clear    : in std_logic;
     --Clears the debouncer.
     button_o : out std_logic);
     --Debounced output.
end entity debouncer;
