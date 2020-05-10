library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity main_fsm is
port(clk                : in std_logic;
     --System clock.
     reset              : in std_logic;
     --System reset.
    
     ------------------------------------------------------------------------------------
     --Button Interfaces
     ------------------------------------------------------------------------------------
     accept             : in std_logic;
     --Input from the debounced >>accept<< button.
     accept_clear       : out std_logic;
     --Clears the >>accept<< button debouncer.     
     cancel             : in std_logic;
     --Input from the debounced >>cancel<< button.
     cancel_clear       : out std_logic;
     --Clears the >>cancel<< button debouncer.     
     yes                : in std_logic;
     --Input from the debounced >>yes<< button.
     yes_clear          : out std_logic;
     --Clears the >>yes<< button debouncer.     
     no                 : in std_logic;
     --Input from the debounced >>no<< button.
     no_clear           : out std_logic;
     --Clears the >>no<< button debouncer.
     clear_choices      : out std_logic;
     --Clears the choice button debouncers. 

     ------------------------------------------------------------------------------------
     --Indicators of the User's Choices
     ------------------------------------------------------------------------------------
     in_coin_type       : in std_logic_vector(4 downto 0);
     --One-hot-encoding of the coin type being inserted into the temporary storage.
     drink_type         : in std_logic_vector(4 downto 0);
     --One-hot-encoding of the chosen drink type.

     ------------------------------------------------------------------------------------
     --Indicators from the Drink Preparation Unit
     ------------------------------------------------------------------------------------
     available          : in std_logic;
     --Indicates if the ingredients to prepare the chosen drink are available.
     --If not available, the user should be asked if they want to choose again.
     base_price         : in std_logic_vector(15 downto 0);
     --Gives the basic drink price (i.e., before the possible cup reduction).

     ------------------------------------------------------------------------------------
     --Commands and Other Inputs to the Drink Preparation Unit
     ------------------------------------------------------------------------------------
     drink_type_o       : out std_logic_vector(4 downto 0);
     --One-hot-encoding of the chosen drink type.

     ------------------------------------------------------------------------------------
     --Drink Preparation Unit Handshake Protocol
     ------------------------------------------------------------------------------------
     pour_cmd_served    : out std_logic;
     --Indicates that the chosen drink should be poured.
     pour_cmd_complete  : in std_logic;
     --Indicates that pouring has been completed.

     ------------------------------------------------------------------------------------
     --Indicators from the Money Storage Unit
     ------------------------------------------------------------------------------------
     zero               : in std_logic;
     --Indicates that the user inserted the exact amount needed to pay for the drink.
     --We can immediately proceed to pouring as there is no change to be returned.
     negative           : in std_logic;
     --Indicates that the user did not insert enough coins. Triggers release of the
     --inserted coins and return to the idle state.

     ------------------------------------------------------------------------------------
     --Commands and Other Inputs to the Money Storage Unit
     ------------------------------------------------------------------------------------
     insert_coin        : out std_logic;
     --Signals that a coin should be inserted into the temporary storage.
     calc_change        : out std_logic;
     --Signals that change calculation operation should be performed.
     give_change        : out std_logic;
     --Signals that change should be returned to the user.
     release_coins      : out std_logic;
     --Signals that coins should be released from the temporary storage to the user.
     merge_coins        : out std_logic;
     --Signals that coins from the temporary storage should be merged into the main one.
     coin_type          : out std_logic_vector(4 downto 0);
     --Passes the inserted coin type information.
     final_price        : out std_logic_vector(15 downto 0);
     --Price of the drink after the cup reduction has been applied.
     show_change        : out std_logic;
     --Signals that the accumulated change value should be displayed.

     ------------------------------------------------------------------------------------
     --Money Storage Unit Handshake Protocol
     ------------------------------------------------------------------------------------
     money_cmd_served    : out std_logic;
     --Indicates that the set money storage command should be executed.
     money_cmd_complete  : in std_logic;
     --Indicates that the scheduled command has been executed.

     ------------------------------------------------------------------------------------
     --LED Interfaces
     ------------------------------------------------------------------------------------
     msg                 : out std_logic_vector(2 downto 0));
     --Address of the message to be printed on the LEDs. When the coin insertion process
     --is ongoing or expected, the message should be >>fr<<. When drink is to be chosen,
     --the message should be >>drink<<. If the drink is not available and the user is
     --is being asked if they want to make another choice, the message should be >>x_new<<.
     --When the user is being asked if they want to use their own cup, the message should be
     -->>cup<<. When the user is being asked if they agree on the computed change, the
     --message should be >>ok<<. Finally, when the user is being asked if they want to
     --donate the change, the message should be >>donate<<. In all other cases, no message
     --should be displayed (i.e., the >>msg<< vector should be zero).

     --Memory map:
     -------------
     --Message address specified by the main FSM.
     --Address 0x00 holds a constant zero.
     --0x01 holds >>fr<<.
     --0x02 holds >>drink<<.
     --0x03 holds >>x_new<<.
     --0x04 holds >>cup<<.
     --0x05 holds >>donate<<.
     --Change distribution is memory-mapped at 0x06 and should be displayed along with >>ok<<.
     --Blinking timer led is memory-mapped at 0x07.
end entity main_fsm;
