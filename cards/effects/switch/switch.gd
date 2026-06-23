extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	var discard_card : CardInstance = actor.deck.discard_pile.pop_back()
	actor.deck.discard_offhand()
	actor.deck.offhand = discard_card
