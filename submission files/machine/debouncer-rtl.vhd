architecture rtl of debouncer is
Signal q1,q2,q3,q4 : std_logic;
begin
  process (button, clear , clk) is
    begin
    if rising_edge(clk) THEN
      q1<=button and not clear;
      q2<= q1 and not clear;
      q3<= q2 and not clear;
      q4<= ((q2 and not q3) or q4)and not clear;
    end if;
  end process;
  button_o<=q4;
end architecture rtl;
