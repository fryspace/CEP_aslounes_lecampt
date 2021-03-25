# TAG = sll
	.text

	sll x31, x0, x0      #Test chargement d'une valeur nulle
	addi x1, x0, 0x2A # On ajoute 42 à x1
	addi x2, x0, 0x45 # On ajoute 69 à x2
	sll x31, x2, x1 # On fait x2 << x1


	# max_cycle 50
	# pout_start
	# 00000000
	# 00011400
	# pout_end
