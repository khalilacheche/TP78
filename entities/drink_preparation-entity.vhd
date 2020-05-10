--Models the drink preparation unit.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity drink_preparation is
port(clk          : in std_logic;
     --System clock.
     reset        : in std_logic;
     --System reset.
     drink_type   : in std_logic_vector(4 downto 0);
     --One-hot-encoded signal that specifies the drink type.
     available    : out std_logic;
     --Indicates if the ingredients necessary to prepare the drink are available.
     price        : out std_logic_vector(15 downto 0);
     --The base price of the chosen drink (prior to the possible cup reduction).

     ------------------------------------------------------------------------------------
     --Main FSM Handshake Protocol
     ------------------------------------------------------------------------------------
     cmd_served   : in std_logic;
     --Signals that the main FSM issued a command and is waiting for response.
     cmd_complete : out std_logic;
     --Signals that the command has been completed and the results are ready to be consumed.

     led_out      : out std_logic);
     --Output to the blinked LED, indicating the preparation progress.
end entity drink_preparation;
