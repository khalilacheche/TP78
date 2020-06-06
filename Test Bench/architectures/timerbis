architecture rtl of timer is
signal s_done : std_logic;
signal init_value : unsigned (31 downto 0);
signal tick_counter : unsigned(31 downto 0):= to_unsigned(0,32);
signal seconds_counter : unsigned (4 downto 0):= to_unsigned(0,5);
begin
  state : process(clk, clear, en, timeout)
  begin
    if rising_edge(clk) then
        if clear = '1' THEN
          seconds_counter <= to_unsigned(0,5);
          tick_counter <= init_value;
          s_done<='0';
        else
          if en ='1' and s_done='0' then
            if seconds_counter>= unsigned(timeout)then s_done<='1';else s_done<='0'; end if;
            if tick_counter = to_unsigned(0,32) then
              tick_counter <= init_value;
            else
              if tick_counter = to_unsigned(1,32) then
                seconds_counter <= seconds_counter + 1;
              end if;
            tick_counter <= tick_counter - 1;
          end if;
        end if;
      end if;
    end if;
  end process;
init_value <=to_unsigned(FCLK,32)-1;
pulse <= '1' when tick_counter < shift_right(to_unsigned(FCLK,32),1) and en ='1' and clear ='0' else '0';
done <= s_done;
end architecture rtl;
