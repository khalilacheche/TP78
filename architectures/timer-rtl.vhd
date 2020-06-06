architecture rtl of timer is


  signal s_secondCounter : natural;
  signal s_tickCounter   : natural;

begin


  nada : process (clk)
  begin
    if(rising_edge(clk)) then
      if(clear = '1') then
        s_tickCounter <= 1;
        s_secondCounter <= 0;
      elsif (en = '0') then
	null;
      else
        if(s_tickCounter = FCLK) then
          s_secondCounter <= s_secondCounter + 1;
          s_tickCounter <= 1;
          done <= '0';
          pulse <= '0';
        elsif (s_secondCounter = to_integer(unsigned(timeout))) then
           pulse <= '0';
           done  <= '1';
        else
          if(s_tickCounter < FCLK / 2) then
            pulse <= '0';
            done <= '0';
            s_secondCounter <= s_secondCounter;
            s_tickCounter <= s_tickCounter + 1;
          elsif(s_tickCounter >= FCLK/2) then
            pulse <= '1';
            done <= '0';
            s_secondCounter <= s_secondCounter;
            s_tickCounter <= s_tickcounter + 1;
          end if;
        end if;
      end if;
    end if;

  end process nada;
end architecture rtl;
