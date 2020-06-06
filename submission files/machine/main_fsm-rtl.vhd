architecture rtl of main_fsm is

constant insert_st : std_logic_vector(3 downto 0):="0001";
constant choose_st : std_logic_vector(3 downto 0):="0010";
constant repeat_st : std_logic_vector(3 downto 0):="0011";
constant reuse_st : std_logic_vector(3 downto 0):="0100";
constant calc_st : std_logic_vector(3 downto 0):="0101";
constant ok_st : std_logic_vector(3 downto 0):="0110";
constant donate_st : std_logic_vector(3 downto 0):="0111";
constant give_st : std_logic_vector(3 downto 0):="1000";
constant pour_st : std_logic_vector(3 downto 0):="1001";
constant merge_st : std_logic_vector(3 downto 0):="1010";
constant release_st : std_logic_vector(3 downto 0):="1011";
  --1 insert/ 2 choose drink / 3 repeat choice / 4 reuse cup / 5 calc change / 6 ok / 7 donate / 8 give_change / 9 pour / 10 merge money / 11 release coins
SIGNAL c_calc,c_give,c_merge,c_release,c_pour : std_logic:='0' ;
SIGNAL current_state : std_logic_vector(3 downto 0):=insert_st;
SIGNAL choice_reduced_price,s_pour_cmd_served : std_logic:='0';
SIGNAL chosen_drink_type : std_logic_vector (4 downto 0);
begin
  state_manager : process(clk,reset,current_state,pour_cmd_complete,money_cmd_complete,accept,yes,no,cancel,available,zero,negative)
  begin
    if rising_edge(clk) then
      if reset='1' then
        current_state <= insert_st;
        c_calc<='0';c_give<='0';c_release<='0';c_merge<='0';c_pour<='0';
        choice_reduced_price <='0';
        chosen_drink_type <= "00000";
      else
        case( current_state ) is
          --insert
          when insert_st =>
            choice_reduced_price <='0';
            chosen_drink_type <="00000";
            c_release <='0';
            c_merge <='0';
          if in_coin_type/="00000" and in_coin_type/="UUUUU"  then
          elsif accept = '1' then
            --choose drink
            current_state <= choose_st;
          elsif cancel ='1' then
            current_state <= release_st;
          end if;
          --choose drink
          when choose_st =>
          if (drink_type/="00000" and drink_type/="UUUUU") then
            chosen_drink_type <= drink_type;
            if available ='1' then
              --reuse cup
              current_state <= reuse_st;
            elsif available = '0' then
              --repeat choice
              current_state <= repeat_st;
            end if;
          elsif cancel='1' then
            --release_coins
            current_state <= release_st;
          end if;
          --repeat choice
          when repeat_st =>
          if yes='1' then
            --choose drink
            current_state <= choose_st;
          elsif no = '1' or cancel = '1' then
            --release_coins
            current_state <= release_st;
          end if;
          --reuse cup
          when reuse_st =>
            if yes='1' then
              choice_reduced_price <= '1';
              current_state <= calc_st;
            elsif no ='1' then
              choice_reduced_price <= '0';
              --calc_change
              current_state <= calc_st;
            elsif cancel = '1' then
              --release_coins
              current_state <= release_st;
          end if;
          --calc_change
          when calc_st =>
          if money_cmd_complete ='1' then
            c_calc<='1';
          end if;
          if c_calc ='1' then
            if negative ='1' then
              --release_coins
              current_state <= release_st;
            elsif zero = '1' then
              --pour
              current_state <= pour_st;
            elsif zero='0' then
              --ok
              current_state <= ok_st;
            end if;
          end if;
          --ok
          when ok_st =>
          c_calc <='0';
          if no='1' then
            current_state <= release_st;
          elsif cancel='1' then
            --release
            current_state <= release_st;
          elsif yes='1' then
            --donate
            current_state <= donate_st;
          end if;
          --donate
          when donate_st =>
          if yes = '1' then
            --pour
            current_state <= pour_st;
          elsif no = '1' then
            --give change
            current_state <= give_st;
          elsif cancel='1' then
            current_state <= release_st;
          end if;
          --give_change
          when give_st =>
          if money_cmd_complete ='1' then
            c_give <='1';
          end if;
          if c_give ='1' then
            current_state <= pour_st;
          end if;
          --pour
          when pour_st =>
          c_calc <='0';
          c_give<='0';
          if pour_cmd_complete='1' then
            c_pour <='1';
          end if;
          if c_pour ='1' then
            current_state <= merge_st;
          end if;
          --merge_coins
          when merge_st =>
          c_pour<='0';
          if money_cmd_complete ='1' then
            --insert
            c_merge <= '1';
          end if;
          if c_merge ='1' then
            current_state <= insert_st;
          end if;
          --release_coins
          when release_st =>
          c_calc <='0';
          if money_cmd_complete ='1' then
            --insert_coin
            c_release <='1';
          end if;
          if c_release ='1' then
            current_state <= insert_st;
          end if;
          when others => current_state <= insert_st;
        end case;
        --Reset user choices when we are back to insert state

      end if;
    end if;
  end process;

coin_type <= in_coin_type;
insert_coin <='1' when (in_coin_type="10000" or in_coin_type="01000" or in_coin_type="00100" or in_coin_type="00010" or in_coin_type="00001") and current_state=insert_st else '0';

no_clear<='1' when no='1' else '0';
yes_clear<='1' when yes='1' else '0';
cancel_clear<='1' when cancel='1' else '0';
accept_clear<='1' when accept='1' else '0';
clear_choices <='1' when (in_coin_type/="00000" and in_coin_type/="UUUUU") or (drink_type/="00000" and drink_type/="UUUUU") else '0';

drink_type_o <= chosen_drink_type or drink_type;

pour_cmd_served<='1' when current_state =pour_st else '0';
money_cmd_served<= '1' when current_state = calc_st or current_state = give_st or current_state = merge_st or current_state = release_st else '0';
calc_change <= '1' when current_state = calc_st else '0';
give_change <= '1' when current_state = give_st else '0';
release_coins <= '1' when current_state = release_st else '0';
merge_coins <= '1' when current_state = merge_st else '0';
show_change <= '1' when current_state = ok_st else '0';
final_price <= base_price when (choice_reduced_price='0' and base_price/=x"0000" and base_price/="UUUUUUUUUUUUUUUU")else std_logic_vector(unsigned(base_price)-fifth) when (choice_reduced_price='1' and base_price/=x"0000" and base_price/="UUUUUUUUUUUUUUUU") else x"0000";

msg <= "001" when current_state = insert_st
  else "010" when current_state = choose_st
  else "011" when current_state = repeat_st
  else "100" when current_state = reuse_st
  else "101" when current_state = donate_st
  else "110" when current_state = ok_st
  else "111" when current_state = pour_st
  else "000";
end architecture rtl;
