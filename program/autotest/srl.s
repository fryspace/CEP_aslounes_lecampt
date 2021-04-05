# TAG = srl
	.text

	srl x31, x0, x0      #Test chargement d'une valeur nulle
	addi x1, x0, 0x2 # On ajoute 2 à x1
	addi x2, x0, 0x1 # On ajoute 1 à x2
	srl x31, x1, x2 # On fait x1 >> x2


	# max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# pout_end
