extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	target_char.deck.discard_top()
