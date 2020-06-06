architecture rtl of disp_driver is
  COMPONENT sum_splitter IS
  port(sum   : in std_logic_vector(15 downto 0);
       whole : out std_logic_vector(8 downto 0);
       frac  : out std_logic_vector(6 downto 0));
  end COMPONENT;
  COMPONENT bin_to_bcd IS
  port(bin   : in std_logic_vector(7 downto 0);
       l_bcd : out std_logic_vector(3 downto 0);
       u_bcd : out std_logic_vector(3 downto 0));
  end COMPONENT;
  COMPONENT bcd_to_7seg IS
  port(en       : in std_logic;
       bcd      : in std_logic_vector(3 downto 0);
       point_on : in std_logic;
       disp     : out std_logic_vector(7 downto 0));
  end COMPONENT;
SIGNAL sum_split_whole,units_bcd,tens_bcd : std_logic_vector(3 downto 0);
SIGNAL sum_split_frac : std_logic_vector (7 downto 0):=x"00";
SIGNAL open_port : std_logic_vector(4 downto 0);
begin
  sum_split: sum_splitter
    PORT MAP(sum=>num,whole(3 downto 0)=>sum_split_whole,whole(8 downto 4)=>open_port,frac=>sum_split_frac(6 downto 0));
  frac_converter: bin_to_bcd
    PORT MAP(bin=>sum_split_frac,l_bcd=>units_bcd,u_bcd=>tens_bcd);
  whole_7seg_decoder: bcd_to_7seg
    PORT MAP(en=>en,bcd=>sum_split_whole,point_on=>'1',disp=>whole_disp);
  frac_units_decoder: bcd_to_7seg
    PORT MAP(en=>en,bcd=>units_bcd,disp=>frac_disp_l,point_on=>'0');
  frav_tens_decoder: bcd_to_7seg
  PORT MAP (en=>en,bcd=>tens_bcd,disp=>frac_disp_u,point_on=>'0');
end architecture rtl;
