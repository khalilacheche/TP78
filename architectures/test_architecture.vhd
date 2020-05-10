architecture rtl of main is
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
begin
  test: single_coin_type_storage
    GENERIC MAP (INIT_COUNT=>0,INIT_SUM=>to_unsigned(0,16),COIN_VAL=>fifth)
    PORT MAP(clk=>clock,reset=>reset,en=>enable,add_coin=>add_coin,rem_coin=>rem_coin,count=>count,sum=>sum,fault=>fault);
end architecture rtl;
