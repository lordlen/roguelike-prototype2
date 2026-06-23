extends CardEffect

@export var card_effect: CardEffect

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	target_char.deck.primary.tmp_attack_effects.push_back(card_effect)

func get_description() -> String:
	return description % card_effect.get_description()
