# TAG = or
	.text

	or x31, x0, x0      #Test chargement d'une valeur nulle
	addi x1, x0, 0x2A # On ajoute 42 à x1
	addi x2, x0, 0x45 # On ajoute 69 à x2
	or x31, x1, x2 # On fait x1 or x2


	# max_cycle 50
	# pout_start
	# 00000000
	# 0000006F
	# pout_end
