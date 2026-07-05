extends CardEffect

@export var def_value: int

func do(actor: Char, target_char: Char, card: CardInstance) -> void:

	if actor.deck.primary != null:
		actor.deck.primary.defense += def_value
	
	card_effect_finished.emit()

func get_description() -> String:
	return description % def_value
