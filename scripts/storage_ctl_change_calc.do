vsim -t ps storage_ctl
#add wave price cmd_served cmd_complete disp_sum change_count_2 change_count_1 change_count_05 change_count_02
add wave *

# cmd_complete must be 1 at the end of each test

# TEST 1 (negative)
# expected output : disp_sum = Undefined, negative = 1, zero = 0, change_count = 0 (for each type of coin)
force price 0000000011000000 0
force temp_storage_sum 0000000001000000 0

#TEST 2 (zero)
# expected output : disp_sum = 0, negative = 0, zero = 1, change_count = 0 (for each type of coin)
#force price 0000000011000000 0
#force temp_storage_sum 0000000011000000 0

#TEST 3 (normal)
# expected output : disp_sum = 0000000111000000, negative = 0, zero = 0, change_count :(2f: 1, 1f: 1, 05f: 1, 02f: 0)
force insert_coin 0
force release_coins 0
force merge_coins 0
force give_change 0
force main_storage_sum 1111111111111111
force main_storage_count 11111
#force price 0000000011000000 0
#force temp_storage_sum 0000001010000000 0


#TEST 4 (normal 2)
# expected output : disp_sum = 0000000011011001, negative = 0, zero = 0, change_count :(2f: 0, 1f: 1, 05f: 1, 02f: 1)
#force price 0000000011000000 0
#force temp_storage_sum 0000000110011001 0

force cmd_served 0 0, 1 10
force show_change 1 0
force calc_change 0 0, 1 10
force clk 1 0, 0 10 -repeat 20

run 1000
