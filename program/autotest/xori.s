# TAG = xori
	.text

	xori x31, x0, 0x0      #Test chargement d'une valeur nulle
	addi x1, x0, 0x6 # On ajoute 6 à x1
	xori x31, x1, 0x1 # On fait x1 xor 1


	# max_cycle 50
	# pout_start
	# 00000000
	# 00000007
	# pout_end
