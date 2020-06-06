architecture rtl of money_storage is
  COMPONENT storage_ctl is
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
       main_storage_count    : in std_logic_vector(4 downto 0);
       main_storage_sum      : in std_logic_vector(15 downto 0);
       main_storage_fault    : in std_logic;
       temp_storage_count    : in std_logic_vector(4 downto 0);
       temp_storage_sum      : in std_logic_vector(15 downto 0);
       temp_storage_fault    : in std_logic;
       cptr                  : out std_logic_vector(4 downto 0);
       main_storage_en       : out std_logic;
       main_storage_add_coin : out std_logic;
       main_storage_rem_coin : out std_logic;
       temp_storage_en       : out std_logic;
       temp_storage_add_coin : out std_logic;
       temp_storage_rem_coin : out std_logic;
       disp_on               : out std_logic;
       disp_sum              : out std_logic_vector(15 downto 0);
       change_count_2        : out std_logic_vector(4 downto 0);
       change_count_1        : out std_logic_vector(4 downto 0);
       change_count_05       : out std_logic_vector(4 downto 0);
       change_count_02       : out std_logic_vector(4 downto 0));
     end COMPONENT;
     COMPONENT coin_storage is
       generic(INIT_COUNTS : init_count_t;
               INIT_SUMS   : init_sum_t);
       port(clk       : in std_logic;
            reset     : in std_logic;
            en        : in std_logic;
            add_coin  : in std_logic;
            rem_coin  : in std_logic;
            coin_type : in std_logic_vector(4 downto 0);
            count     : out std_logic_vector(4 downto 0);
            sum       : out std_logic_vector(15 downto 0);
            fault     : out std_logic);
     end COMPONENT;
     SIGNAL main_storage_en,temp_storage_en,main_storage_add_coin, main_storage_rem_coin, temp_storage_add_coin, temp_storage_rem_coin,main_fault,temp_fault : std_logic;
     SIGNAL main_coin_type, temp_coin_type,main_count,temp_count,cptr : std_logic_vector(4 downto 0);
     SIGNAL main_sum,temp_sum,change_sum : std_logic_vector(15 downto 0);
     SIGNAL main_sum_f,temp_sum_f,price_f,change_f : real;
     begin
  main_storage : coin_storage
    generic map (INIT_COUNTS=>main_init_counts, INIT_SUMS=> main_init_sums)
    port map(clk=> clk, reset => reset,en=>main_storage_en,add_coin=>main_storage_add_coin,rem_coin=>main_storage_rem_coin,
    coin_type=>main_coin_type,count=>main_count, sum => main_sum,fault=>main_fault);
  temp_storage : coin_storage
    generic map (INIT_COUNTS=>(0, 0, 0, 0, 0), INIT_SUMS=> (x"0000", x"0000", x"0000", x"0000", x"0000"))
    port map(clk=> clk, reset => reset,en => temp_storage_en,add_coin=>temp_storage_add_coin,rem_coin=>temp_storage_rem_coin,
    coin_type=>temp_coin_type,count=>temp_count, sum => temp_sum,fault=>temp_fault);
  storage_control : storage_ctl
    port map(clk=>clk,reset=>reset,insert_coin=>insert_coin,calc_change=>calc_change,give_change=>give_change,release_coins=>release_coins,merge_coins=>merge_coins,
    in_coin_type=>in_coin_type,price=>price,show_change=>show_change, zero =>zero , negative =>negative, cmd_served=>cmd_served,cmd_complete=>cmd_complete,
    main_storage_en=>main_storage_en,main_storage_add_coin=>main_storage_add_coin,main_storage_rem_coin=>main_storage_rem_coin,
    main_storage_count=>main_count,main_storage_sum=>main_sum, main_storage_fault => main_fault,
    temp_storage_en=>temp_storage_en,temp_storage_add_coin=>temp_storage_add_coin,temp_storage_rem_coin=>temp_storage_rem_coin,
    temp_storage_count=>temp_count,temp_storage_sum=>temp_sum, temp_storage_fault => temp_fault,
    cptr=>cptr,
    disp_on=>disp_on,disp_sum=>change_sum,change_count_2=>change_count_2,change_count_1=>change_count_1,change_count_05=>change_count_05,change_count_02=>change_count_02);
    main_sum_f<=fixed_to_float(main_sum);
    temp_sum_f<=fixed_to_float(temp_sum);
    price_f<=fixed_to_float(price);
    change_f<=fixed_to_float(change_sum);
    disp_sum<=change_sum;
    main_coin_type<= cptr when main_storage_en ='1' else "00000";
    temp_coin_type<= cptr when temp_storage_en ='1' else "00000";


end architecture rtl;
