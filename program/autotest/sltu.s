# TAG = sltu
	.text

	sltu x31, x0, x0     #Test chargement d'une valeur nulle
	addi x1, x0, 0x11 	# On ajoute 17 à x1
    addi x2, x0, 0X6    # on ajoute 6 à x2
	sltu x31, x1, x2	    # On fait x1 <= x2
    sltu x31, x2, x1     #on fait x2 <= x1

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000000
    # 00000001
	# pout_end