# TAG = and
	.text

	and x31, x0, x0      # Test 0 and 0
	addi x1, x0, 0x2A # On ajoute 42 à x1
	addi x2, x0, 0x45 # On ajoute 69 à x2
	and x31, x1, x2 # On fait x1 and x2


	# max_cycle 50
	# pout_start
	# 00000000
	# 00000000
	# pout_end
