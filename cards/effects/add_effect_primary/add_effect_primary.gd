extends CardEffect

@export var card_effect: CardEffect

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	if target_char.deck.primary != null:
		target_char.deck.primary.attack_effects.push_back(card_effect)
		target_char.deck.primary.is_changed = true

func get_description() -> String:
	return description % card_effect.get_description()
