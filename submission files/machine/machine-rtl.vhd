architecture rtl of machine is
  COMPONENT main_fsm IS
  port(clk                : in std_logic;
       reset              : in std_logic;
       accept             : in std_logic;
       accept_clear       : out std_logic;
       cancel             : in std_logic;
       cancel_clear       : out std_logic;
       yes                : in std_logic;
       yes_clear          : out std_logic;
       no                 : in std_logic;
       no_clear           : out std_logic;
       clear_choices      : out std_logic;
       in_coin_type       : in std_logic_vector(4 downto 0);
       drink_type         : in std_logic_vector(4 downto 0);
       available          : in std_logic;
       base_price         : in std_logic_vector(15 downto 0);
       drink_type_o       : out std_logic_vector(4 downto 0);
       pour_cmd_served    : out std_logic;
       pour_cmd_complete  : in std_logic;
       zero               : in std_logic;
       negative           : in std_logic;
       insert_coin        : out std_logic;
       calc_change        : out std_logic;
       give_change        : out std_logic;
       release_coins      : out std_logic;
       merge_coins        : out std_logic;
       coin_type          : out std_logic_vector(4 downto 0);
       final_price        : out std_logic_vector(15 downto 0);
       show_change        : out std_logic;
       money_cmd_served    : out std_logic;
       money_cmd_complete  : in std_logic;
       msg                 : out std_logic_vector(2 downto 0));
  END COMPONENT;
  COMPONENT money_storage IS
  port(clk                   : in std_logic;
       reset                 : in std_logic;
       insert_coin           : in std_logic;
       calc_change           : in std_logic;
       give_change           : in std_logic;
       release_coins         : in std_logic;
       merge_coins           : in std_logic;
       in_coin_type          : in std_logic_vector(4 downto 0);
       price                 : in std_logic_vector(15 downto 0);
       show_change           : in std_logic;
       zero                  : out std_logic;
       negative              : out std_logic;
       cmd_served            : in std_logic;
       cmd_complete          : out std_logic;
       disp_on               : out std_logic;
       disp_sum              : out std_logic_vector(15 downto 0);
       change_count_2        : out std_logic_vector(4 downto 0);
       change_count_1        : out std_logic_vector(4 downto 0);
       change_count_05       : out std_logic_vector(4 downto 0);
       change_count_02       : out std_logic_vector(4 downto 0));
  END COMPONENT;
  COMPONENT drink_preparation IS
  port(clk          : in std_logic;
       reset        : in std_logic;
       drink_type   : in std_logic_vector(4 downto 0);
       available    : out std_logic;
       price        : out std_logic_vector(15 downto 0);
       cmd_served   : in std_logic;
       cmd_complete : out std_logic;
       led_out      : out std_logic);
  END COMPONENT;
  COMPONENT disp_driver IS
  port(en          : in std_logic;
       num         : in std_logic_vector(15 downto 0);
       whole_disp  : out std_logic_vector(7 downto 0);
       frac_disp_u : out std_logic_vector(7 downto 0);
       frac_disp_l : out std_logic_vector(7 downto 0));
  END COMPONENT;
  COMPONENT led_driver IS
    port(msg             : in std_logic_vector(2 downto 0);
         change_count_2  : in std_logic_vector(4 downto 0);
         change_count_1  : in std_logic_vector(4 downto 0);
         change_count_05 : in std_logic_vector(4 downto 0);
         change_count_02 : in std_logic_vector(4 downto 0);
         progress_led    : in std_logic;
         leds            : out std_logic_vector(107 downto 0));
  END COMPONENT;
signal n_accept,n_cancel,n_yes,n_no,ins,cal,giv,rel,merg,shw,zr,ng,mcs,mcc,pcs,pcc,avl,ledo,dispo,c1_in,c2_in,c3_in,c4_in,c5_in,c1_o,c2_o,c3_o,c4_o,c5_o,c1_clear,c5_clear,clear_choices,no_clear,yes_clear,cancel_clear,accept_clear,accept_o,cancel_o,disp_en:std_logic;
signal disp_msg:std_logic_vector(2 downto 0);
signal ctpe,dtpe,dtpi,cc2,cc1,cc05,cc02,in_coin_type:std_logic_vector(4 downto 0);
signal fprc,bprc,nam:std_logic_vector(15 downto 0);
begin
  c5_clear <= yes_clear or clear_choices or reset;
  c1_clear <= no_clear or clear_choices or reset;
  dtpi <= (c5_in &  c4_in &  c3_in &  c2_in &  c1_in) when disp_msg/="001" else "00000";
  disp_en<='1' when (dispo='1' and (disp_msg="001" or disp_msg="110")) else '0';
  in_coin_type <=  ( c5_in &  c4_in &  c3_in &  c2_in &  c1_in) when disp_msg="001" else "00000";
   n_yes<=c5_in when disp_msg="011" or disp_msg="100" or disp_msg="101" or disp_msg="110";
   n_no<=c1_in when disp_msg="011" or disp_msg="100" or disp_msg="101" or disp_msg="110";
   n_accept<= not n_accept_button;
   n_cancel<= not n_cancel_button;
fsm:main_fsm
 port map(
     clk       =>clk,
     reset           =>reset,
     accept          => n_accept,
     accept_clear     =>accept_clear,
     cancel       => n_cancel,
     cancel_clear       =>cancel_clear,
     yes           => n_yes,
     yes_clear        =>yes_clear,
     no            => n_no,
     no_clear       =>no_clear,
     clear_choices    =>clear_choices,
     in_coin_type   =>in_coin_type,
     drink_type    =>dtpi,
     available     =>avl,
     base_price     =>bprc,
     drink_type_o  =>dtpe,
     pour_cmd_served   =>pcs,
     pour_cmd_complete =>pcc,
     zero          =>zr,
     negative      =>ng,
     insert_coin     =>ins,
     calc_change => cal,
     give_change     =>giv,
     release_coins    =>rel,
     merge_coins       =>merg,
     coin_type       =>ctpe,
     final_price      =>fprc,
     show_change      =>shw,
     money_cmd_served   =>mcs,
     money_cmd_complete =>mcc,
     msg          =>disp_msg
 );
money:money_storage
 port map(
    clk      =>clk,
    reset      =>reset,
    insert_coin     =>ins,
    calc_change      =>cal,
    give_change     =>giv,
    release_coins    =>rel,
    merge_coins      =>merg,
    in_coin_type      =>ctpe,
    price            =>fprc,
    show_change      =>shw,
    zero             =>zr,
    negative        =>ng,
    cmd_served      =>mcs,
    cmd_complete     =>mcc,
    disp_on           =>dispo,
    disp_sum      =>nam,
    change_count_2    =>cc2,
    change_count_1     =>cc1,
    change_count_05    =>cc05,
    change_count_02   =>cc02
 );
drink:drink_preparation
 port map(
     clk     => clk,
     reset   => reset,
     drink_type   =>dtpe,
     available  =>avl,
     price      =>bprc,
     cmd_served  =>pcs,
     cmd_complete =>pcc,
     led_out  =>ledo
 );
 c1_in<=not n_choice_buttons(0);
 c2_in<=not n_choice_buttons(1);
 c3_in<=not n_choice_buttons(2);
 c4_in<=not n_choice_buttons(3);
 c5_in<=not n_choice_buttons(4);
 disp:disp_driver
 port map(
    en=>disp_en,
    num  =>nam,
    whole_disp=>disp_2,
    frac_disp_u=>disp_1,
    frac_disp_l=>disp_0
 );
 led:led_driver
 port map(
    msg  =>disp_msg,
    change_count_2    =>cc2,
    change_count_1    =>cc1,
    change_count_05   =>cc05,
    change_count_02   =>cc02,
    progress_led=>ledo,
    leds=>leds
 );
end architecture rtl;
