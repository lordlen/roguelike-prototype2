extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	if actor.deck.offhand != null:
		actor.deck.offhand.defense_decay = actor.deck.offhand.defense
		card_effect_finished.emit()
