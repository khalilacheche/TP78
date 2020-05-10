library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package fixed_point_pkg is
    --There are up to 31 coins of each type, which gives the maximum value
    --of 31 * 8.7 = 269.7. Hence we need 9 bits for the whole part. The
    --smallest fraction we need to represent is 1/5, which is decently
    --approximated by 1/8 + 1/16 + 1/128 (31 * error < 0.2). Hence, we
    --need 7 more bits for the fractional part.
    --The representation is thus 9:7.
    constant fifth       : unsigned(15 downto 0) := x"0019";
    --0000 0000 0.001 1001
    constant half        : unsigned(15 downto 0) := x"0040";
    --0000 0000 0.100 0000
    constant one         : unsigned(15 downto 0) := x"0080";
    --0000 0000 1.000 0000
    constant two         : unsigned(15 downto 0) := x"0100";
    --0000 0001 0.000 0000
    constant five        : unsigned(15 downto 0) := x"0280";
    --0000 0010 1.000 0000
    function fixed_to_float(fixed : std_logic_vector) return real;
    --Converts a 9.7 16-bit fixed point number to a real.
    function float_to_fixed(float : real) return unsigned;
    --Converts a real to a 9.7 16-bit fixed point number.
    function float_eq(a : real; b : real) return boolean;
    --Compares two floats by truncating them to two decimal points. 

    type init_count_t is array(0 to 4) of natural;
    --Represents the numbers of coins of each type loaded at maintenance.
    --The first element corresponds to the 20 cents coins and the last to 5 franc ones.
    type init_sum_t   is array(0 to 4) of unsigned(15 downto 0);
    --Represents the total values of the coins of each type loaded at maintentance.
    --The order is the same as for >>init_count_t<<.
    constant main_init_counts : init_count_t := (20, 10, 10, 5, 0);
    constant main_init_sums   : init_sum_t := (x"0200", x"0280", x"0500", x"0500", x"0000");
end package fixed_point_pkg;

package body fixed_point_pkg is
    function fixed_to_float(fixed : std_logic_vector) return real is
        type val_t is array(15 downto 0) of real;
        constant vals : val_t := (256.0, 128.0, 64.0, 32.0, 16.0, 8.0, 4.0, 2.0, 1.0,
                                  0.5, 0.25, 0.125, 0.0625, 0.03125, 0.015625, 0.0078125);
        variable sum  : real := 0.0;
    begin
        for i in 0 to 15 loop
            if fixed(i) = '1' then
                sum := sum + vals(i);
            end if;
        end loop;
        return sum;
    end function fixed_to_float;

    function float_to_fixed(float : real) return unsigned is
    begin
        return to_unsigned(integer(trunc(float * 128.0)), 16);
    end function float_to_fixed;

    function float_eq(a : real; b : real) return boolean is
        variable a_int, b_int : integer;
    begin
        a_int := integer(trunc(a * 100.0));
        b_int := integer(trunc(b * 100.0));
        return a_int = b_int;
    end function float_eq;
    
end package body fixed_point_pkg;
