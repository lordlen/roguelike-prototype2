extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	if actor.deck.offhand != null:
		actor.deck.offhand.is_swift = true
