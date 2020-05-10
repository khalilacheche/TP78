--The module describes one complete coin storage unit.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity coin_storage is
generic(INIT_COUNTS : init_count_t;
        --Holds the numbers of coins of each type loaded
        --at maintenance.
        INIT_SUMS   : init_sum_t);
        --Holds the total values of the coins of each type
        --loaded at maintenance.
port(clk       : in std_logic;
     --System clock.
     reset     : in std_logic;
     --System reset.
     en        : in std_logic;
     --Enable input. When low, no register updates can
     --happen and the output of >>count<< should be zero.
     add_coin  : in std_logic;
     --Signals that a coin is being added.
     rem_coin  : in std_logic;
     --Signals that a coin is being removed.
     coin_type : in std_logic_vector(4 downto 0);
     --One-hot-encoded signal selecting the type of coin
     --to be added (when >>add_coin<< is high), or removed
     --(when >>rem_coin<< is high). The MSB corresponds to
     --the 5 franc coins, while the LSB to the 20 cents ones.
     count     : out std_logic_vector(4 downto 0);
     --Number of coins of type determined by >>coin_type<<
     --that are currently stored. If >>en<< is low, must be zero.
     --If >>coin_type<< is zero, must be zero.
     sum       : out std_logic_vector(15 downto 0);
     --Value of all coins currently stored. Should be
     --output at all times, regardless of >>en<< or >>coin_type<<.
     fault     : out std_logic);
     --Signals that an attempt to insert a coin into a full
     --storage unit or to remove it from an empty unit is 
     --being made.
end entity coin_storage;
