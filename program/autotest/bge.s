# TAG = bge
	.text

	addi x1, x0, 0x2A # On ajoute 42 à x0
	bge x1, x0, suite   
	addi x31, x0, 0x2A # On ajoute 42 à x0
suite:
	addi x31, x0, 0x45 # On ajoute 69 à x0


	# max_cycle 50
	# pout_start
	# 00000045
	# pout_end
