extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	var offhand := actor.deck.offhand
	
	if offhand == null:
		return
	
	offhand.do_attack(actor, target_char, path)
	actor.deck.discard_offhand()
