--The module models the behavior of the control unit of money storage.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity storage_ctl is
port(clk                   : in std_logic;
     --System clock.
     reset                 : in std_logic;
     --System reset.
     
     ------------------------------------------------------------------------------------
     --Commands and Other Inputs from the Main FSM
     ------------------------------------------------------------------------------------
     insert_coin           : in std_logic;
     --Signals that a coin should be inserted into the temporary storage.
     calc_change           : in std_logic;
     --Signals that change calculation operation should be performed.
     give_change           : in std_logic;
     --Signals that change should be returned to the user.
     release_coins         : in std_logic;
     --Signals that coins should be released from the temporary storage to the user.
     merge_coins           : in std_logic;
     --Signals that coins from the temporary storage should be merged into the main one.
     in_coin_type          : in std_logic_vector(4 downto 0);
     --One-hot-encoding of the coin type being inserted into the temporary storage.
     price                 : in std_logic_vector(15 downto 0);
     --Price of the drink chosen by the user.
     show_change           : in std_logic;
     --Signals that the accumulated change value should be displayed.

     ------------------------------------------------------------------------------------
     --Status Signals for the Main FSM
     ------------------------------------------------------------------------------------
     zero                  : out std_logic;
     --Indicates that the user inserted the exact amount needed to pay for the drink.
     negative              : out std_logic;
     --Indicates that the user did not insert enough coins.

     ------------------------------------------------------------------------------------
     --Main FSM Handshake Protocol
     ------------------------------------------------------------------------------------
     cmd_served            : in std_logic;
     --Signals that the main FSM issued a command and is waiting for response.
     cmd_complete          : out std_logic;
     --Signals that the command has been completed and the results are ready to be consumed.

     ------------------------------------------------------------------------------------
     --Status Signals from the Storage Units
     ------------------------------------------------------------------------------------
     main_storage_count    : in std_logic_vector(4 downto 0);
     -->>count<< output of the main storage.
     main_storage_sum      : in std_logic_vector(15 downto 0);
     -->>sum<< output of the main storage.
     main_storage_fault    : in std_logic;
     -->>fault<< output of the main storage.
     temp_storage_count    : in std_logic_vector(4 downto 0);
     -->>count<< output of the temporary storage.
     temp_storage_sum      : in std_logic_vector(15 downto 0);
     -->>sum<< output of the temporary storage.
     temp_storage_fault    : in std_logic;
     -->>fault<< output of the temporary storage.

     ------------------------------------------------------------------------------------
     --Commands for the Storage Units
     ------------------------------------------------------------------------------------
     cptr                  : out std_logic_vector(4 downto 0);
     --Pointer of the coin type.
     main_storage_en       : out std_logic;
     --Enables the main storage unit.
     main_storage_add_coin : out std_logic;
     --Instructs the main storage unit to add a coin of type determined by >>cptr<<.
     main_storage_rem_coin : out std_logic;
     --Instructs the main storage unit to remove a coin of type determined by >>cptr<<.
     temp_storage_en       : out std_logic;
     --Enables the temporary storage unit.
     temp_storage_add_coin : out std_logic;
     --Instructs the temporary storage unit to add a coin of type determined by >>cptr<<.
     temp_storage_rem_coin : out std_logic;
     --Instructs the temporary storage unit to remove a coin of type determined by >>cptr<<.

     ------------------------------------------------------------------------------------
     --Display and LED Interfaces
     ------------------------------------------------------------------------------------
     disp_on               : out std_logic;
     --Specifies if the sum should be displayed.
     disp_sum              : out std_logic_vector(15 downto 0);
     --Sum to be displayed on the 7-segment displays
     --(i.e., the value inserted by the user and the value of change that can be returned).
     change_count_2        : out std_logic_vector(4 downto 0);
     --Number of 2 franc coins to be returned (for display on LEDs).
     change_count_1        : out std_logic_vector(4 downto 0);   
     --Number of 1 franc coins to be returned (for display on LEDs).
     change_count_05       : out std_logic_vector(4 downto 0);   
     --Number of 1/2 franc coins to be returned (for display on LEDs).
     change_count_02       : out std_logic_vector(4 downto 0));   
     --Number of 20 cents coins to be returned (for display on LEDs).
end entity storage_ctl;
