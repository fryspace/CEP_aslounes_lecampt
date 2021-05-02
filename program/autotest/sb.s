# TAG = sb
	.text

    addi x1, x0, 0x11
    li x2, 0x1010  
    sb x1, 0(x2)  
    lb x31, 0(x2) 

	# max_cycle 50
	# pout_start
    # 00000011
	# pout_end