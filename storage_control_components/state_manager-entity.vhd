--The module describes one complete coin storage unit.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_manager is
port(clk       : in std_logic;
     reset     : in std_logic;
     start_process : in std_logic;
     end_process : in std_logic;
     insert  : in std_logic;
     insert_completed  : in std_logic;
     merge  : in std_logic;
     merge_completed  : in std_logic;
     release: in std_logic;
     release_completed  : in std_logic;
     calc_change  : in std_logic;
     calc_change_completed  : in std_logic;
     give_change  : in std_logic;
     give_change_completed  : in std_logic;

     idle     : out std_logic;
     busy     : out std_logic;
     completed     : out std_logic);
end entity state_manager;
