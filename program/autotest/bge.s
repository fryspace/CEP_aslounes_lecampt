# TAG = bge
	.text

	addi x1, x0, 0x11 # On ajoute 17 à x0
	bge x1, x0, suite   
	addi x31, x0, 0x11 # On ajoute 17 à x0
suite:
	addi x31, x0, 0x6 # On ajoute 6 à x0


	# max_cycle 50
	# pout_start
	# 0000006
	# pout_end
