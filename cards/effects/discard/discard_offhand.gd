extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	target_char.deck.discard_offhand()
	card_effect_finished.emit()
