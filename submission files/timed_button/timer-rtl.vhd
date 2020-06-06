architecture rtl of timer is
signal tick_counter : natural :=0;
signal seconds_counter : unsigned(4 downto 0 ) := to_unsigned(0,5);
signal s_pulse : std_logic := '0';
signal s_done : std_logic :='0';
begin
 process(clk) is
 begin
    if(rising_edge(clk))then
       	if(clear='1')then
    		tick_counter <= natural(0);
    		seconds_counter <= to_unsigned(0,5);
    		s_done <='0';
    		s_pulse<='0';
    	else
    	if(tick_counter =natural(0))then
    	  s_pulse <='0';
    	end if ;
        if(en='1' and s_done='0')then
       		if(tick_counter =natural(FCLK/2))then
    			s_pulse <= '1';
    		  end if ;
          tick_counter <= tick_counter +1 ;
    		if(tick_counter = natural(FCLK-1))then
          tick_counter <=natural(0);
    			seconds_counter <=seconds_counter + 1 ;
        	end if ;
        	if(seconds_counter = unsigned(timeout))then
        		s_done <='1';
        	else
        		s_done <='0';
        	end if ;
       else
            if(en='0')then
       	   		s_pulse <='0';
       	   		end if ;
      end if ;
      end if;
    end if;
 end process;
 done<=s_done;
 pulse<=s_pulse;
end architecture rtl;
