# TAG = slli
	.text

	slli x31, x0, 0x0      #Test chargement d'une valeur nulle
	addi x1, x0, 0x1  # On ajoute 1 à x1
	slli x31, x1, 0x1 # On fait x1 << 1


	# max_cycle 50
	# pout_start
	# 00000000
	# 00000002
	# pout_end
