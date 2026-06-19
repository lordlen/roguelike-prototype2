extends CardEffect

@export var card_effect: CardEffect

func do(attacker: Char, defender: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	attacker.deck.primary.tmp_attack_effects.push_back(card_effect)

func get_description() -> String:
	return description.format(card_effect.get_description())
