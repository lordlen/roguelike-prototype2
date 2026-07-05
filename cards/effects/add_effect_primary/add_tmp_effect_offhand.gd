extends CardEffect

@export var card_effect: CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	if actor.deck.offhand != null:
		CardEffect.combine_effects(actor.deck.offhand.tmp_on_hit_effects, [card_effect])

func get_description() -> String:
	return description % card_effect.get_description()
