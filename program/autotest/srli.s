# TAG = srli
	.text

	srli x31, x0, 0x0      #Test chargement d'une valeur nulle
	addi x1, x0, 0x2 # On ajoute 1 à x1
	srli x31, x1, 0x1 # On fait x1 >> 0x1


	# max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# pout_end
