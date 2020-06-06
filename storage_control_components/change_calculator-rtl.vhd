architecture rtl of change_calculator is
SIGNAL s_completed,smaller : std_logic;
SIGNAL current_coin_reg,reg_2f,reg_1f,reg_05f,reg_02f : unsigned(4 downto 0);
SIGNAL target,current_sum,current_coin_value : unsigned(15 downto 0);
SIGNAL mult : unsigned (20 downto 0);
begin
  main : process(clk,reset,enable,main_count,temp_storage_sum,s_completed,current_coin_reg,smaller,reg_2f,reg_1f,reg_05f,reg_02f,mult)
  begin
    if reset = '1' then
      s_completed<='0';
      current_coin_reg<="01000";
      reg_2f<="00000";
      reg_1f<="00000";
      reg_05f<="00000";
      reg_02f<="00000";
    end if;
    case current_coin_reg is
      when "01000" => current_coin_value <= two;
      when "00100"=>current_coin_value <= one;
      when "00010"=>current_coin_value <= half;
      when "00001" =>current_coin_value <= fifth;
      when others => current_coin_value <= x"0000";
    end case;
    if current_sum + current_coin_value <=target THEN
      smaller <='1';
    else
      smaller <='0';
    end if;
    mult <= reg_2f * two + reg_1f * one + reg_05f * half + reg_02f * fifth;
    current_sum <=mult(15 downto 0);
    if rising_edge(clk)then
      if (temp_storage_sum < price) or (temp_storage_sum = price) or (current_coin_reg="00001" and (smaller='0' or unsigned(main_count) < reg_02f +1)) THEN
        s_completed <='1';
      else s_completed <='0';
      end if;
      --- case 00001 eresetekmlg
      if enable = '1' and (smaller ='0' or ( current_coin_reg="00001" and unsigned(main_count) < reg_02f +1)
        or ( current_coin_reg="00010" and unsigned(main_count) < reg_05f +1) or ( current_coin_reg="00100" and unsigned(main_count) < reg_1f +1) or ( current_coin_reg="01000" and unsigned(main_count) < reg_2f +1))then
        if (current_coin_reg /= "00001") then
          current_coin_reg <= shift_right(current_coin_reg,1);
        else
        end if;
      end if;

      if enable='1' and s_completed = '0' and smaller='1' then
        case current_coin_reg is
          when "01000" => if unsigned(main_count) >= reg_2f + 1 then reg_2f <= reg_2f + 1; end if;
          when "00100"=> if unsigned(main_count) >= reg_1f + 1 then reg_1f <= reg_1f + 1; end if;
          when "00010"=> if unsigned(main_count) >= reg_05f + 1 then reg_05f <= reg_05f + 1; end if;
          when "00001" =>if unsigned(main_count) >= reg_02f + 1 then reg_02f <= reg_02f + 1; end if;
          when others => reg_2f<= reg_2f;
        end case;
      end if;
    end if;
  end process;
  change_count_2<= std_logic_vector(reg_2f) when s_completed ='1' else "00000";
  change_count_1<= std_logic_vector(reg_1f) when s_completed ='1' else "00000";
  change_count_05<= std_logic_vector(reg_05f) when s_completed ='1' else "00000";
  change_count_02<= std_logic_vector(reg_02f) when s_completed ='1' else "00000";
  coin_type <= std_logic_vector(current_coin_reg);
  target <= (unsigned(temp_storage_sum)-unsigned(price))when temp_storage_sum > price else to_unsigned(0,16);
  completed <= s_completed;
  negative <= '1' when temp_storage_sum < price and s_completed='1' else '0';
  zero <= '1' when temp_storage_sum = price and s_completed='1' else '0';
end architecture rtl;
