# TAG = sltiu
	.text

	sltiu x31, x0, 0x0     #Test chargement d'une valeur nulle
	addi x1, x0, 0x11 	# On ajoute 17 à x1
	sltiu x31, x1, 6	    # On fait x1 <= 6

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000000
	# pout_end