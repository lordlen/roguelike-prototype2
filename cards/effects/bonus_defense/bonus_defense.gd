extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	actor.bonus_defense += card.get_defense()
	card_effect_finished.emit()
