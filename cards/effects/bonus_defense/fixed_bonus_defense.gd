extends CardEffect

@export var value: int

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	if actor.deck.offhand:
		actor.deck.offhand.bonus_defense += value
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
