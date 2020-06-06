architecture rtl of storage_ctl is
  --state manager
  SIGNAL insert_completed,merge_completed, release_completed,calc_change_completed,give_change_completed : std_logic:='0';
  SIGNAL idle: std_logic:='1';
  SIGNAL busy,completed: std_logic:='0';
  --start/end event
  SIGNAL start_out,start_reg,end_out,end_reg : std_logic:='0';
  -- calc change
   SIGNAL change_smaller : std_logic:='0';
   SIGNAL reg_2f,reg_1f,reg_05f,reg_02f :  unsigned(4 downto 0):=to_unsigned(0,5);
   SIGNAL mult :  unsigned(20 downto 0):=to_unsigned(0,21);

  SIGNAL s_completed,cmd_completed : std_logic:='0';
  SIGNAL merge_coin_type,release_coin_type : std_logic_vector(4 downto 0):="10000";
  SIGNAL give_change_coin_type,calc_change_coin_type : std_logic_vector(4 downto 0):="01000";
  SIGNAL merge_add_main, merge_rem_temp, give_change_rem_main,release_rem_temp : std_logic:='0';
  SIGNAL change_target,change_current_sum,change_current_coin_value : unsigned(15 downto 0):=to_unsigned(0,16);
begin
  state_managment : process(idle,busy,completed,start_out,end_out,clk,reset)
      begin
        if reset = '1' then
          idle<='1';
          busy<='0';
          completed<='0';
        end if;
        if rising_edge(clk)then
          idle<= (not idle and not busy and not completed) OR (not start_out and idle) OR (end_out and completed);
          busy<= not completed and((idle and start_out)or( busy and((merge_coins and not merge_completed)or(release_coins and not release_completed)or(calc_change and not calc_change_completed)or(give_change and not give_change_completed))));
          completed<= (completed and not end_out)or(busy and((merge_completed)or(release_completed)or(calc_change_completed)or(give_change_completed)));
        end if;
      end process;
  start_end_event : process(clk,reset,cmd_served,start_out,start_reg,end_out,end_reg)
  begin
    if reset = '1' then
      start_reg<='0';
      end_reg<='0';
    elsif rising_edge(clk)then
      start_reg<= cmd_served and (start_out or start_reg);
      end_reg<= not cmd_served and (end_out or end_reg);
    end if;
  end process;
  start_out <= not (start_reg) when cmd_served ='1' else '0';
  end_out <= not (end_reg) when cmd_served='0' else '0';

  cmd_comp : process(clk,s_completed,completed,cmd_served,reset,calc_change_completed,give_change_completed,merge_completed,release_completed)
  begin
    if reset='1' then
      s_completed<='0';
      cmd_completed <= '0';
    elsif rising_edge(clk) then
      s_completed<=cmd_served and cmd_completed;
      cmd_completed <= s_completed or completed or (calc_change_completed) or (give_change_completed) or (merge_completed) or (release_completed);
    end if;
  end process;
--TASKS
  --Release
  release : process(clk,reset,temp_storage_count,release_completed,release_coin_type,busy,release_coins)
  begin
    if reset = '1' then
      release_coin_type<="10000";
    elsif rising_edge(clk)then
      if temp_storage_count = "00000" and (busy='1') and ( release_coins='1') then
        if release_coin_type = "00001" then
          release_coin_type <= "10000";
        elsif release_coin_type="00000" THEN
          release_coin_type <= "10000";
        else
          release_coin_type <= std_logic_vector(shift_right(unsigned(release_coin_type),1));
        end if;
      end if;
    end if;
  end process;
  release_completed <= '1' when (release_coin_type = "00001") and (temp_storage_count = "00000") and release_coins='1' else '0';
  release_rem_temp <='1' when busy ='1' and release_coins='1' and temp_storage_count/="00000" else '0';

  --Merge
  merge : process(clk,reset,temp_storage_count,merge_completed,merge_coin_type,busy,merge_coins)
  begin
    if reset = '1' then
      merge_coin_type<="10000";
    elsif rising_edge(clk)then
      if busy='1' and merge_coins='1' and temp_storage_count = "00000"  then
        if merge_coin_type = "00001" then
          merge_coin_type <= "10000";
        elsif merge_coin_type="00000"then
          merge_coin_type <= "10000";
        else
          merge_coin_type <= std_logic_vector(shift_right(unsigned(merge_coin_type),1));
        end if;
      end if;
    end if;
  end process;
  merge_completed <= '1' when (merge_coin_type = "00001") and (temp_storage_count = "00000") and merge_coins='1'else '0';
  merge_add_main <= '1' when busy='1' and merge_coins ='1' and temp_storage_count /="00000" else '0';
  merge_rem_temp <= '1' when busy='1' and merge_coins ='1' and temp_storage_count /="00000" else '0';

  --Calculate change
  change_give_calculation : process(clk,reset)
    begin
      if reset = '1' then
        calc_change_completed<='0';
        calc_change_coin_type<="01000";
        reg_2f<="00000";
        reg_1f<="00000";
        reg_05f<="00000";
        reg_02f<="00000";
        give_change_coin_type<="01000";
      elsif rising_edge(clk)then
        if release_coins ='1' then
          reg_2f<="00000"; reg_1f<= "00000"; reg_05f <="00000" ; reg_02f <= "00000";
        end if;
        ----------------CALC
        if busy='1' and calc_change='1' and ((temp_storage_sum < price) or (temp_storage_sum = price) or (calc_change_coin_type="00001" and (change_smaller='0' or unsigned(main_storage_count) < reg_02f +1)))then
          calc_change_completed <='1';
        else calc_change_completed <='0';
        end if;
        if busy='1' and calc_change='1' THEN----
          --Moving coin type index
          if calc_change_completed = '0' and not((temp_storage_sum < price) or (temp_storage_sum = price)) and ((change_smaller ='0' or ( calc_change_coin_type="00001" and unsigned(main_storage_count) < reg_02f +1)
          or ( calc_change_coin_type="00010" and unsigned(main_storage_count) < reg_05f +1) or ( calc_change_coin_type="00100" and unsigned(main_storage_count) < reg_1f +1) or ( calc_change_coin_type="01000" and unsigned(main_storage_count) < reg_2f +1)))then
            if (calc_change_coin_type = "00001") then
              calc_change_coin_type <= "01000";
            elsif calc_change_coin_type = "00000" THEN
              calc_change_coin_type <= "01000";
            else
              calc_change_coin_type <= std_logic_vector(shift_right(unsigned(calc_change_coin_type),1));
            end if;
          end if;

          --- Incrementing counters
          if calc_change_completed = '0' and change_smaller='1' then
            case calc_change_coin_type is
              when "01000" => if unsigned(main_storage_count) >= reg_2f + 1 then reg_2f <= reg_2f + 1; end if;
              when "00100"=> if unsigned(main_storage_count) >= reg_1f + 1 then reg_1f <= reg_1f + 1; end if;
              when "00010"=> if unsigned(main_storage_count) >= reg_05f + 1 then reg_05f <= reg_05f + 1; end if;
              when "00001" =>if unsigned(main_storage_count) >= reg_02f + 1 then reg_02f <= reg_02f + 1; end if;
              when others => reg_2f<= reg_2f;
            end case;
          end if;
        end if;---
        --------------- Give Change
        if busy = '1' and give_change = '1' then-----begin give change
          --Emptying counters
          if give_change_completed = '0'then
            case give_change_coin_type is
              when "01000" => if reg_2f > 0 then reg_2f <= reg_2f - 1; end if;
              when "00100"=>if reg_1f > 0 then reg_1f <= reg_1f - 1; end if;
              when "00010"=>if reg_05f > 0 then reg_05f <= reg_05f - 1; end if;
              when "00001" =>if reg_02f > 0 then reg_02f <= reg_02f - 1; end if;
              when others => reg_2f<= reg_2f;
            end case;
          end if;
          --Moving coin type index
          if (give_change_coin_type = "00001" and reg_02f = "00000")or(give_change_coin_type = "00010" and reg_05f = "00000")or(give_change_coin_type = "00100" and reg_1f = "00000")or(give_change_coin_type = "01000" and reg_2f = "00000") THEN
            if give_change_coin_type = "00001" then
              give_change_coin_type <= "01000";
            elsif give_change_coin_type = "00000" THEN
              give_change_coin_type<="01000";
            else
              give_change_coin_type <= std_logic_vector(shift_right(unsigned(give_change_coin_type),1));
            end if;
          end if;

        end if;----end give change

      end if;-----END RISING EDGE
    end process;

    change_smaller <='1' when change_current_sum + change_current_coin_value <=change_target else '0';

    change_current_coin_value <= two when calc_change_coin_type ="01000" else one when calc_change_coin_type="00100" else half when calc_change_coin_type="00010" else fifth when calc_change_coin_type ="00001" ;
    mult <= reg_2f * two + reg_1f * one + reg_05f * half + reg_02f * fifth;
    change_current_sum <=mult(15 downto 0);
    change_target <= (unsigned(temp_storage_sum)-unsigned(price))when temp_storage_sum > price else to_unsigned(0,16);

    give_change_completed <= '1' when (give_change_coin_type = "00001") and (reg_02f = "00000") and give_change='1' else '0';
    give_change_rem_main <='0' when (give_change_coin_type = "00001" and reg_02f = "00000")or(give_change_coin_type = "00010" and reg_05f = "00000")or(give_change_coin_type = "00100" and reg_1f = "00000")or(give_change_coin_type = "01000" and reg_2f = "00000")   else '1';

  --Output Managment
  disp_on <= '1';
  disp_sum <= std_logic_vector(change_current_sum) when show_change='1' else temp_storage_sum;
  change_count_2<= std_logic_vector(reg_2f);
  change_count_1<= std_logic_vector(reg_1f);
  change_count_05<= std_logic_vector(reg_05f);
  change_count_02<= std_logic_vector(reg_02f);
  negative <= '1' when temp_storage_sum < price and cmd_completed='1' and calc_change='1' else '0';
  zero <= '1' when temp_storage_sum = price and cmd_completed='1' and calc_change='1' else '0';

  cmd_complete<=cmd_completed;
  cptr<= in_coin_type when insert_coin ='1'
    else merge_coin_type when merge_coins='1'
    else release_coin_type when release_coins='1'
    else give_change_coin_type when give_change='1'
    else calc_change_coin_type when calc_change ='1'
    else "00000";
  main_storage_en <= (merge_coins or give_change or calc_change);
  temp_storage_en <= (release_coins or merge_coins) or insert_coin;
  main_storage_add_coin <= merge_add_main and busy and merge_coins;
  main_storage_rem_coin <= give_change_rem_main and busy and give_change;
  temp_storage_add_coin <= insert_coin;
  temp_storage_rem_coin <= ((merge_rem_temp and merge_coins) or( release_rem_temp and release_coins)) and busy;
  --
end architecture rtl;
