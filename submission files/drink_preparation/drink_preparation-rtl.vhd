architecture rtl of drink_preparation is
  COMPONENT timer is
    generic(FCLK : natural := 10);
    port(clk     : in std_logic;
         clear   : in std_logic;
         en      : in std_logic;
         timeout : in std_logic_vector(4 downto 0);
         pulse   : out std_logic;
         done    : out std_logic);
  END COMPONENT;
  type prep_times_t is array(0 to 4) of std_logic_vector(4 downto 0);
  type prices_t is array(0 to 4) of std_logic_vector(15 downto 0);
  type ing_t is array(0 to 4) of unsigned(1 downto 0);
  constant prep_times : prep_times_t :=  ("00101","00111","00111","01001","01101");
--Preparation times are as follows (ordered from MSB to LSB):
--5, 7, 7, 9, 13
  constant prices : prices_t:=(std_logic_vector(float_to_fixed(1.2)),std_logic_vector(float_to_fixed(1.4)),std_logic_vector(float_to_fixed(1.4)),std_logic_vector(float_to_fixed(1.8)),std_logic_vector(float_to_fixed(2.5)));
--Prices are as follows (ordered from MSB to LSB):
--1.2, 1.4, 1.4, 1.8, 2.5
--You may use the >>float_to_fixed<< routine to convert to unsigned.
  constant num_ingredients :ing_t:= ("10","10","10","10","01");
  --Numbers of ingredients packages are as follows (ordered from MSB to LSB):
  --2, 2, 2, 2, 1
  SIGNAL ing1 : unsigned (1 downto 0):=num_ingredients(0);
  signal ing2 : unsigned (1 downto 0):=num_ingredients(1);
  signal ing3 : unsigned (1 downto 0):=num_ingredients(2);
  signal ing4 : unsigned (1 downto 0):=num_ingredients(3);
  signal ing5 : unsigned (1 downto 0):=num_ingredients(4);
  SIGNAL clear_timer,en_timer, done_timer, started, s_completed : std_logic:='0';
  SIGNAL current_prep_time : std_logic_vector(4 downto 0);
begin
  prep_timer : timer
    port map(clk=>clk,clear=>clear_timer,en=>en_timer,timeout=>current_prep_time,pulse => led_out,done=>done_timer);
  manager : process(clk,reset,drink_type)
  begin
    if rising_edge(clk) THEN
      if reset = '1' THEN
        started <= '0';
        s_completed <='0';
        ing1<=num_ingredients(0); ing2<=num_ingredients(1); ing3<=num_ingredients(2); ing4<=num_ingredients(3); ing5<=num_ingredients(4);
      else
        s_completed <= (done_timer or s_completed) and started;
        if cmd_served = '1' THEN
          if started ='0' then
            started <='1';
            case(drink_type ) is
              when "10000" => if ing1>0 then ing1<=ing1-1; end if;
              when "01000" => if ing2>0 then ing2<=ing2-1; end if;
              when "00100" => if ing3>0 then ing3<=ing3-1; end if;
              when "00010" => if ing4>0 then ing4<=ing4-1; end if;
              when "00001" => if ing5>0 then ing5<=ing5-1; end if;
              when others =>
            end case;
          end if;
        else started <='0';
        end if;

      end if;
    end if;
  end process;
  cmd_complete<= s_completed;--'1' when done_timer= '1' and started ='0' else '0';
  en_timer <= cmd_served;
  clear_timer <= reset or not cmd_served;

  current_prep_time <= prep_times(0) when drink_type = "10000"
      else prep_times(1) when drink_type = "01000"
      else prep_times(2) when drink_type = "00100"
      else prep_times(3) when drink_type = "00010"
      else prep_times(4) when drink_type = "00001";
  price <= prices(0) when drink_type = "10000"
    else prices(1) when drink_type = "01000"
    else prices(2) when drink_type = "00100"
    else prices(3) when drink_type = "00010"
    else prices(4) when drink_type = "00001";

  available <= '1' when (drink_type = "10000" and ing1 >0) or (drink_type = "01000" and ing2 >0) or (drink_type = "00100" and ing3 >0) or (drink_type = "00010" and ing4 >0) or (drink_type = "00001" and ing5 >0) else '0';


end architecture rtl;
