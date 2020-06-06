--Detects a rising edge in input for one frame
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity change_calculator is
port(clk       : in std_logic;
     reset     : in std_logic;
     enable: in std_logic;
     main_count: in std_logic_vector(4 downto 0);
     temp_storage_sum: in std_logic_vector (15 downto 0);
     price: in std_logic_vector (15 downto 0);
     change_count_2     : out std_logic_vector(4 downto 0);
     change_count_1     : out std_logic_vector(4 downto 0);
     change_count_05     : out std_logic_vector(4 downto 0);
     change_count_02     : out std_logic_vector(4 downto 0);
     coin_type : out std_logic_vector(4 downto 0);
     zero: out std_logic;
     negative: out std_logic;
     completed : out std_logic);
end entity change_calculator;
