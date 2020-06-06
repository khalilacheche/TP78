architecture rtl of bin_to_bcd is
    --It is guaranteed that bin never exceeds two digits, i.e., 99.
begin
  bin2bcd : process(bin) is
    variable unit,dec : unsigned(3 downto 0):=to_unsigned(0,4);
    variable binary : unsigned(7 downto 0);
  begin
    binary :=unsigned(bin);
    unit:=to_unsigned(0,4);
    dec := to_unsigned(0,4);
    for i in 0 to 7 loop
      if to_integer(unit)>= 5 THEN
        unit := unit + 3;
      end if;
      if to_integer(dec)>= 5 THEN
        unit := unit + 3;
      end if;
      dec := shift_left(dec,1);
      dec(0):=unit(3);
      unit := shift_left(unit,1);
      unit(0):=binary(7);
      binary := shift_left(binary,1);
    end loop;
    l_bcd<=std_logic_vector(unit);
    u_bcd<=std_logic_vector(dec);
  end process;
end architecture rtl;
