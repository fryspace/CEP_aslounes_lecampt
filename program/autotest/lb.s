# TAG = lb
	.text

    li x2, 0x1000  # on charge 0x1000 à x2
    lb x31, 0(x2)   

	# max_cycle 50
	# pout_start
    # ffffffb7
	# pout_end