extends CardEffect

func do(attacker: Char, defender: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	var offhand := attacker.deck.offhand
	
	if offhand == null:
		return
	
	offhand.do_attack(attacker, defender, path)
	attacker.deck.discard_offhand()
