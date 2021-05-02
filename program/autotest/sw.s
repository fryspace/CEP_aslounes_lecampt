# TAG = sw
	.text

    addi x1, x0, 0x11
    li x2, 0x1000 
    sw x1, 0(x2)  
    lw x31, 0(x2) 

	# max_cycle 50
	# pout_start
    # 00000011 #à faire une fois que vivado sera up!
	# pout_end