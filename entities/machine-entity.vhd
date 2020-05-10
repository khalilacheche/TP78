--Top-level module of the coffee machine.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity machine is
--All buttons are active low.
port(clk              : in std_logic;
     --System clock.
     reset            : in std_logic;
     --System reset.
     n_choice_buttons : in std_logic_vector(4 downto 0);
     --The horizontal button row.
     n_accept_button  : in std_logic;
     --The accept button.
     n_cancel_button  : in std_logic;
     --The cancel button.
     leds             : out std_logic_vector(107 downto 0);
     --LEDs.
     disp_2           : out std_logic_vector(7 downto 0);
     --Display No. 2.
     disp_1           : out std_logic_vector(7 downto 0);
     --Display No. 1.
     disp_0           : out std_logic_vector(7 downto 0));
     --Display No. 0.
end entity machine;
