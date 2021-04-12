# TAG = lbu
	.text

    addi x2, x0, 0x100   # on charge 0x1000 à x2
    lbu x31, 0(x2)     

	# max_cycle 50
	# pout_start
    # 00000000
	# pout_end