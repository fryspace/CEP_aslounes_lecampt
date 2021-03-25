# TAG = add
	.text

	add x31, x0, x0      #Test chargement d'une valeur nulle
	addi x1, x0, 0x2A # On ajoute 42 à x1
	add x31, x1, x31 # On ajoute x1 et x31


	# max_cycle 50
	# pout_start
	# 00000000
	# 0000002A
	# pout_end
