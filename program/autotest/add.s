# TAG = add
	.text

	add x31, x0, x0      #Test chargement d'une valeur nulle
	addi x6, x0, 0x11 	# On ajoute 17 à x6
	add x31, x6, x31 	# On ajoute x6 et x31


	# max_cycle 50
	# pout_start
	# 00000000
	# 00000011
	# pout_end
