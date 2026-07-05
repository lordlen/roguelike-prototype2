extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	card.num_hits += len(actor.deck.discard_pile)

	card_effect_finished.emit()
