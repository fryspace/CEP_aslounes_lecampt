# TAG = srli
	.text

	srli x31, x0, 0x0      #Test chargement d'une valeur nulle
	addi x1, x0, 0x2A # On ajoute 42 à x1
	addi x2, x0, 0x45 # On ajoute 69 à x2
	srli x31, x2, 0x1 # On fait x2 >> 0x1
	srli x31, x1, 0x1 # On fait x1 >> 0x1


	# max_cycle 50
	# pout_start
	# 00000000
	# 00000022
	# 00000015
	# pout_end
