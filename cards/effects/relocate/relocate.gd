extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	# assume that this only gets called if the attacker is in range
	
	# no need to move if the target is 1 tile away
	if len(path) - 1 < 2:
		card_effect_finished.emit()
		return
	
	# get the second last 
	actor.move_to(path[len(path) - 2])
	# await actor.char_finished_moving
	card_effect_finished.emit()
