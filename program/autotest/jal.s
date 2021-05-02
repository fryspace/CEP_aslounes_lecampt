# TAG = jal
	.text

    li x2, 0x1010  # on charge 0x1000 à x2
    jal x31, 0x1010 

	# max_cycle 50
	# pout_start
    # 0000100c
	# pout_end