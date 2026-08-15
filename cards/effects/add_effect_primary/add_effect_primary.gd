extends CardEffect

@export var card_effect: CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	if target_char.deck.primary != null:
		CardEffect.combine_effects(target_char.deck.primary.attack_effects, [card_effect.duplicate()])
		target_char.deck.primary.is_changed = true
	card_effect_finished.emit()

func get_description() -> String:
	return description % card_effect.get_description()
