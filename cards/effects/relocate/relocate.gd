extends CardEffect

func do(attacker: Char, defender: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	# assume that this only gets called if the attacker is in range
	
	# no need to move if the target is 1 tile away
	if len(path) - 1 < 2:
		return
	
	# get the second last 
	attacker.move_to(path[len(path) - 2])
