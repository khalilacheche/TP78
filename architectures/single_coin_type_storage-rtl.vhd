ARCHITECTURE rtl OF single_coin_type_storage IS
  SIGNAL s_counter_reg,e_counter_reg,s_inc_dec_unit: unsigned (4 DOWNTO 0);
  SIGNAL s_sum_reg,e_sum_reg,s_add_sub_unit: unsigned (15 DOWNTO 0);
  SIGNAL ovf_inc_dec_unit,enable_sum_reg :std_logic:='0';
BEGIN

inc_dec_unit : PROCESS(add_coin , rem_coin, s_counter_reg) IS
BEGIN
    IF(add_coin='1') THEN   -- When both add_coin and rem_coin are 1, addition
      IF (s_counter_reg= to_unsigned( 31 , 5 )) THEN
        ovf_inc_dec_unit <= '1';
      ELSE
        ovf_inc_dec_unit<='0';
        s_inc_dec_unit <= s_counter_reg + 1;
      END IF;
    ELSIF(rem_coin='1') THEN
      IF (s_counter_reg= to_unsigned( 0 , 5 )) THEN
        ovf_inc_dec_unit <= '1';
      ELSE
        ovf_inc_dec_unit<='0';
        s_inc_dec_unit <= s_counter_reg - 1;
      END IF;
    END IF;
END PROCESS;
e_counter_reg<= to_unsigned(INIT_COUNT,5) WHEN reset='1' ELSE s_inc_dec_unit;
counter_reg : PROCESS(clk,en,e_counter_reg)
BEGIN
    IF(en='1') THEN
      IF(rising_edge(clk)) THEN
        s_counter_reg<=e_counter_reg;
      END IF;
    END IF;
END PROCESS;

count <= std_logic_vector(to_unsigned(0,5)) WHEN en = '0' ELSE std_logic_vector(s_counter_reg);
fault <=en AND ovf_inc_dec_unit;
add_sub_unit : PROCESS(add_coin,rem_coin,s_sum_reg)
BEGIN
  IF(add_coin='1') THEN   -- When both add_coin and rem_coin are 1, addition
      s_add_sub_unit <= float_to_fixed(fixed_to_float(std_logic_vector(s_sum_reg)) + fixed_to_float(std_logic_vector(COIN_VAL)));
  ELSIF(rem_coin='1') THEN
      s_add_sub_unit <= float_to_fixed(fixed_to_float(std_logic_vector(s_sum_reg)) - fixed_to_float(std_logic_vector(COIN_VAL)));
  END IF;
END PROCESS;
e_sum_reg<= INIT_SUM WHEN reset='1' ELSE s_add_sub_unit;
enable_sum_reg<= en AND NOT ovf_inc_dec_unit;
sum_reg : PROCESS(clk,enable_sum_reg,e_sum_reg)
BEGIN
    IF(rising_edge(clk)) THEN
      IF(enable_sum_reg ='1') THEN
        s_sum_reg<=e_sum_reg;
      END IF;
    END IF;
END PROCESS;

sum<=std_logic_vector(s_sum_reg);


END ARCHITECTURE rtl;
