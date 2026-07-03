extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	actor.deck.discard_offhand()
	card_effect_finished.emit()
