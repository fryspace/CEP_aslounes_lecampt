# TAG = jalr
	.text

    li x2, 0x1010  # on charge 0x1000 à x2
    jalr x31, 0(x2)   

	# max_cycle 50
	# pout_start
    # 0000100c
	# pout_end