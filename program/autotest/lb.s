# TAG = lb
	.text

    addi x2, x0, 0x3e8  # on charge 0x1000 à x2
    lb x31, 0(x2)   

	# max_cycle 50
	# pout_start
    # FFFFFF83
	# pout_end