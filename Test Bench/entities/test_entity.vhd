library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;
entity main is
  PORT(
  add_coin,rem_coin,enable,clock,reset : in std_logic;
  fault : out std_logic;
  count : out std_logic_vector(4 DOWNTO 0);
  sum : out std_logic_vector(15 DOWNTO 0)
  );

end main;
