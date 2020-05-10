--The module takes care of storage of coins of a single type.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity single_coin_type_storage is
generic(INIT_COUNT : natural;
        --Number of coins loaded at maintenance.
        INIT_SUM   : unsigned(15 downto 0);
        --Value of the coins loaded at maintenance.
        COIN_VAL   : unsigned(15 downto 0));
        --Value of a single coin.
port(clk     : in std_logic;
     --System clock.
     reset    : in std_logic;
     --System reset.
     en       : in std_logic;
     --Enable input. When low, no register updates can
     --happen and the output of >>count<< should be zero.
     add_coin : in std_logic;
     --Signals that a coin is being added.
     rem_coin : in std_logic;
     --Signals that a coin is being removed.
     count    : out std_logic_vector(4 downto 0);
     --Number of coins currently stored. If >>en<< is low,
     --must be zero.
     sum      : out std_logic_vector(15 downto 0);
     --Value of all coins currently stored. Should be
     --output at all times, regardless of >>en<<.
     fault    : out std_logic);
     --Signals that an attempt to insert a coin into a full
     --storage unit or to remove it from an empty unit is 
     --being made.
end entity single_coin_type_storage;
