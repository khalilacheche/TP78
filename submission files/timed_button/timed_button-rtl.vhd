architecture rtl of timed_button is
  COMPONENT timer IS
    GENERIC (FCLK : natural := 10);
    port(clk     : in std_logic;
         clear   : in std_logic;
         en      : in std_logic;
         timeout : in std_logic_vector(4 downto 0);
         pulse   : out std_logic;
         done    : out std_logic);
  END COMPONENT;
  COMPONENT debouncer is
    port(clk      : in std_logic;
         button   : in std_logic;
         clear    : in std_logic;
         button_o : out std_logic);
  end COMPONENT;
  signal clear_debouncer,timer_done : std_logic ;
begin
  timer_r : timer
    port map(clk=>clk,clear=>clear,en=>'1',done=>timer_done,timeout=>"00001");
  clear_debouncer <= not timer_done;
  debouncer_r : debouncer
    port map(clk=>clk,clear=>clear_debouncer,button=>button,button_o=>button_o);
end architecture rtl;
