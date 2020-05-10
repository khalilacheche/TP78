--Splits a 9.7 16-bit fixed-point-encoded number into the 9-bit whole part
--and the two most significant digits of the fractional part (truncated, not rounded),
--encoded in 7-bit natural binary.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity sum_splitter is
port(sum   : in std_logic_vector(15 downto 0);
     --Input number to be split.
     whole : out std_logic_vector(8 downto 0);
     --Whole part encoded in 9-bit natural binary.
     frac  : out std_logic_vector(6 downto 0));
     --Two most significant digits of the fractional part, encoded in 7-bit natural binary.
end entity sum_splitter;

