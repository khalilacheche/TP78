library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tb_pkg is
   function print_stdl_vec(vec : std_logic_vector) return string;
end package tb_pkg;

package body tb_pkg is
    function print_stdl_vec(vec : std_logic_vector) return string is
        variable str : string(vec'left + 1 downto 1);
    begin
        for i in vec'reverse_range loop
            case vec(i) is
                when '0' =>
                    str(i + 1) := '0';
                when '1' =>
                    str(i + 1) := '1';
                when 'Z' =>
                    str(i + 1) := 'Z';
                when 'W' =>
                    str(i + 1) := 'W';
                when 'L' =>
                    str(i + 1) := 'L';
                when 'H' =>
                    str(i + 1) := 'H';
                when '-' =>
                    str(i + 1) := '-';
                when 'U' =>
                    str(i + 1) := 'U';
                when 'X' =>
                    str(i + 1) := 'X';
            end case;
        end loop;
        return str;
    end function print_stdl_vec;
end package body tb_pkg;
