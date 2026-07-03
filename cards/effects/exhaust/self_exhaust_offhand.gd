extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	actor.deck.exhaust_offhand()
	card_effect_finished.emit()
