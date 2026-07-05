class_name SetNumHits
extends CardEffect

@export var num_hits: int

func do(actor: Char, target_char: Char, card: CardInstance) -> void:

	if actor.deck.primary != null:
		actor.deck.primary.num_hits = num_hits
	
	card_effect_finished.emit()

func get_description() -> String:
	return description % num_hits
