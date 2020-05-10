--LED driving module.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity led_driver is
port(msg             : in std_logic_vector(2 downto 0);
     --Message address specified by the main FSM.
     --Address 0x00 holds a constant zero.
     --0x01 holds >>fr<<.
     --0x02 holds >>drink<<.
     --0x03 holds >>x_new<<.
     --0x04 holds >>cup<<.
     --0x05 holds >>donate<<.
     --Change distribution is memory-mapped at 0x06 and should be displayed along with >>ok<<.
     --Blinking timer led is memory-mapped at 0x07.
     change_count_2  : in std_logic_vector(4 downto 0);
     --Number of 2 franc coins to be returned. Should be displayed in thermometer encoding.
     change_count_1  : in std_logic_vector(4 downto 0);
     --Number of 1 franc coins to be returned. Should be displayed in thermometer encoding.
     change_count_05 : in std_logic_vector(4 downto 0);
     --Number of 1/2 franc coins to be returned. Should be displayed in thermometer encoding.
     change_count_02 : in std_logic_vector(4 downto 0);
     --Number of 20 cents coins to be returned. Should be displayed in thermometer encoding.
     progress_led    : in std_logic;
     --Pulsing signal from the drink preparation unit, indicating progress.
     leds            : out std_logic_vector(107 downto 0));
     --Row-major LED matrix.
end entity led_driver;
