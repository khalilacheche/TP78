architecture rtl of coin_storage is
  COMPONENT single_coin_type_storage IS
  generic(INIT_COUNT : natural;
          INIT_SUM   : unsigned(15 downto 0);
          COIN_VAL   : unsigned(15 downto 0));
  port(clk     : in std_logic;
       reset    : in std_logic;
       en       : in std_logic;
       add_coin : in std_logic;
       rem_coin : in std_logic;
       count    : out std_logic_vector(4 downto 0);
       sum      : out std_logic_vector(15 downto 0);
       fault    : out std_logic);
  end COMPONENT;
  SIGNAL enable,count_five,count_two,count_one,count_half,count_fifth : std_logic_vector(4 downto 0);
  SIGNAL sum_five,sum_two,sum_one,sum_half,sum_fifth : std_logic_vector(15 downto 0);
  SIGNAL fault_five,fault_two,fault_one,fault_half,fault_fifth : std_logic;
begin
unit_5F: single_coin_type_storage
  GENERIC MAP (INIT_COUNT=>INIT_COUNTS(4),INIT_SUM=>INIT_SUMS(4),COIN_VAL=>five)
  PORT MAP(clk=>clk,reset=>reset,en=>enable(4),add_coin=>add_coin,rem_coin=>rem_coin,count=>count_five,sum=>sum_five,fault=>fault_five);
unit_2F: single_coin_type_storage
  GENERIC MAP (INIT_COUNT=>INIT_COUNTS(3),INIT_SUM=>INIT_SUMS(3),COIN_VAL=>two)
  PORT MAP(clk=>clk,reset=>reset,en=>enable(3),add_coin=>add_coin,rem_coin=>rem_coin,count=>count_two,sum=>sum_two,fault=>fault_two);
unit_1F: single_coin_type_storage
    GENERIC MAP (INIT_COUNT=>INIT_COUNTS(2),INIT_SUM=>INIT_SUMS(2),COIN_VAL=>one)
    PORT MAP(clk=>clk,reset=>reset,en=>enable(2),add_coin=>add_coin,rem_coin=>rem_coin,count=>count_one,sum=>sum_one,fault=>fault_one);
unit_50c: single_coin_type_storage
    GENERIC MAP (INIT_COUNT=>INIT_COUNTS(1),INIT_SUM=>INIT_SUMS(1),COIN_VAL=>half)
    PORT MAP(clk=>clk,reset=>reset,en=>enable(1),add_coin=>add_coin,rem_coin=>rem_coin,count=>count_half,sum=>sum_half,fault=>fault_half);
unit_20c: single_coin_type_storage
    GENERIC MAP (INIT_COUNT=>INIT_COUNTS(0),INIT_SUM=>INIT_SUMS(0),COIN_VAL=>fifth)
    PORT MAP(clk=>clk,reset=>reset,en=>enable(0),add_coin=>add_coin,rem_coin=>rem_coin,count=>count_fifth,sum=>sum_fifth,fault=>fault_fifth);
enable <= std_logic_vector(to_unsigned(0,5)) WHEN en= '0' ELSE coin_type;
fault<= fault_five OR fault_two OR fault_one OR fault_half OR fault_fifth;
count <= count_five OR count_two OR count_one OR count_half OR count_fifth;
sum<= std_logic_vector(float_to_fixed(fixed_to_float(sum_five) + fixed_to_float(sum_two) + fixed_to_float(sum_one) + fixed_to_float(sum_half) + fixed_to_float(sum_fifth)));
end architecture rtl;
