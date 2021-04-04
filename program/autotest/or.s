# TAG = or
	.text

	or x31, x0, x0      #Test chargement d'une valeur nulle
	addi x1, x0, 0x11   # On ajoute 17 à x1
	addi x31, x0, 0x6   # On ajoute 6 à x31
	or x31, x1, x31		# On fait x1 or x31


	# max_cycle 50
	# pout_start
	# 00000000
	# 00000006
	# 00000017
	# pout_end
