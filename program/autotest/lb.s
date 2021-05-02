# TAG = lb
	.text

    li x2, 0x1000  # on charge 0x1000 à x2
    lbu x31, 0(x2)   

	# max_cycle 50
	# pout_start
    # 00000037
	# pout_end