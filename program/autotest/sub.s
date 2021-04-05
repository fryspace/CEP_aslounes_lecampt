# TAG = sub
	.text

	sub x31, x0, x0      #Test chargement d'une valeur nulle
	addi x1, x0, 0x11 # On ajoute 17 à x1
	addi x2, x0, 0x6 # On ajoute 11 à x2
	sub x31, x1, x2 # On fait x1 - x2
	sub x31, x2, x1 # On fait x2 - x1


	# max_cycle 50
	# pout_start
	# 00000000
	# 0000000B
	# FFFFFFF5
	# pout_end
