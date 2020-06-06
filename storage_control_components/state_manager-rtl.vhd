architecture rtl of state_manager is
SIGNAL s_busy,s_idle,s_completed : std_logic;
begin
  idle_reg : process(s_idle,s_busy,s_completed,start_process,end_process,clk,reset)
  begin
    if reset = '1' then
      s_idle<='1';
      s_busy<='0';
      s_completed<='0';
    end if;
    if rising_edge(clk)then
      s_idle<= (not s_idle and not s_busy and not s_completed) OR (not start_process and s_idle) OR (end_process and s_completed);
      s_busy<= not s_completed and((s_idle and start_process)or( s_busy and((insert and not insert_completed)or(merge and not merge_completed)or(release and not release_completed)or(calc_change and not calc_change_completed)or(give_change and not give_change_completed))));
      s_completed<= (s_completed and not end_process)or(s_busy and(s_busy and((insert and  insert_completed)or(merge and  merge_completed)or(release and  release_completed)or(calc_change and  calc_change_completed)or(give_change and  give_change_completed))));
    end if;
  end process;
  idle<=s_idle;
  busy<=s_busy;
  completed<=s_completed;

end architecture rtl;
