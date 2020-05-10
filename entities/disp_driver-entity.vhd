--Top-level module of the 7-segment display driver.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity disp_driver is
port(en          : in std_logic;
     --Enables the displays.
     num         : in std_logic_vector(15 downto 0);
     --16-bit fixed-point-encoded number to be displayed.
     whole_disp  : out std_logic_vector(7 downto 0);
     --Output driving the display of the whole part.
     frac_disp_u : out std_logic_vector(7 downto 0);
     --Output driving the display of the most significant digit of the fractional part.
     frac_disp_l : out std_logic_vector(7 downto 0));
     --Output driving the display of the second most significant digit of the fractional part.
end entity disp_driver;
