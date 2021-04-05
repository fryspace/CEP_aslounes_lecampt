# TAG = xor
	.text

	xor x31, x0, x0      # Test 0 and 0
	addi x1, x0, 0x1 # On ajoute 1 à x1
	addi x2, x0, 0x2 # On ajoute 2 à x2
	xor x31, x1, x2 # On fait x1 xor x2


	# max_cycle 50
	# pout_start
	# 00000000
	# 00000003
	# pout_end
