architecture rtl of bcd_to_7seg is
  signal number: unsigned  (6 downto 0);
begin
  process(bcd)
begin
case bcd is
when "0000" =>
number <= "1111110"; ---0
when "0001" =>
number <= "0110000"; ---1
when "0010" =>
number <= "1101101"; ---2
when "0011" =>
number <= "1111001"; ---3
when "0100" =>
number <= "0110011"; ---4
when "0101" =>
number <= "1011011"; ---5
when "0110" =>
number <= "1011111"; ---6
when "0111" =>
number <= "1110000"; ---7
when "1000" =>
number <= "1111111"; ---8
when "1001" =>
number <= "1111011"; ---9
when others =>
number <= "0000000"; ---null
end case;
end process;
disp<= std_logic_vector(number)&point_on when en='1' else "00000000";

end architecture rtl;
