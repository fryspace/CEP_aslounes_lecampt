# TAG = auipc
	.text

	auipc x31, 0       #Test chargement d'une valeur nulle
	auipc x31, 0x6  #Test avec ajout à pc de 6

	# max_cycle 50
	# pout_start
	# 00001000
	# 00007004
	# pout_end
