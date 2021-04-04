# TAG = beq
	.text

	beq x0, x0, suite      #Test chargement d'une valeur nulle
	addi x31, x0, 0x1 		# On ajoute 1  à x0
suite:
	addi x31, x0, 0x6 		# On ajoute 6 à x0


	# max_cycle 50
	# pout_start
	# 00000006
	# pout_end
