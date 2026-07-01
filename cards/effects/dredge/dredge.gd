extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	actor.deck.dredge()
	card_effect_finished.emit()
