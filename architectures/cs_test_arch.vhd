architecture rtl of cs_test is
  COMPONENT coin_storage IS
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
begin
  test: coin_storage
    GENERIC MAP(INIT_COUNTS=>(0,0,0,0,0),INIT_SUMS=>(x"0000",x"0000",x"0000",x"0000",x"0000"))
    PORT MAP(clk=>clock,reset=>reset,en=>enable,add_coin=>add_coin,rem_coin=>rem_coin,count=>count,sum=>sum,fault=>fault,coin_type=>std_logic_vector(to_unsigned(1,5)));
end architecture rtl;
