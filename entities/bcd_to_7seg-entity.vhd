--Converts a single BCD digit into a vector driving a 7-segment display.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity bcd_to_7seg is
port(en       : in std_logic;
     --Enables the display.
     bcd      : in std_logic_vector(3 downto 0);
     --The digit to be displayed.
     point_on : in std_logic;
     --Indicates if the decimal point should be turned on.
     disp     : out std_logic_vector(7 downto 0));
     --Output driving the display.
     --7 6 5 4 3 2 1 0
     --a b c d e f g p
end entity bcd_to_7seg;
