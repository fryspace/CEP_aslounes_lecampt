# TAG = and
	.text

	and x31, x0, x0      # Test 0 and 0
	addi x6, x0, 0x6 	# On ajoute 6 à x6
	addi x2, x0, 0x1 	# On ajoute 1 à x2
	and x31, x6, x2		 # On fait x1 and x2


	# max_cycle 50
	# pout_start
	# 00000000
	# 00000000
	# pout_end
