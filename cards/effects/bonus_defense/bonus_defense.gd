extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	if actor.deck.offhand:
		actor.deck.offhand.bonus_defense += card.get_defense()
	card_effect_finished.emit()
