--Converts an 8-bit natural binary number into two BCD digits.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity bin_to_bcd is
port(bin   : in std_logic_vector(7 downto 0);
     --Input number to be split into BCD digits.
     l_bcd : out std_logic_vector(3 downto 0);
     --The less significant digit (ones).
     u_bcd : out std_logic_vector(3 downto 0));
     --The more significant digit (tens).
end entity bin_to_bcd;
