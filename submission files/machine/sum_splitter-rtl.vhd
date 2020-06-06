architecture rtl of sum_splitter is
begin
whole <= sum(15 downto 7);
conversion : process (sum) IS
  variable b,s: std_logic_vector(15 downto 0);
  variable a: std_logic_vector(6 downto 0);
  begin
    b:= sum and x"007f";
    s:= std_logic_vector(shift_left(unsigned(b),2) + shift_left(unsigned(b),5) + shift_left(unsigned(b),6));
    frac<=s(13 downto 7);
  end process;
end architecture rtl;
