class_name Seek
extends CardEffect

@export var num_cards: int

func get_identifier() -> String:
	return "seek"

func get_description() -> String:
	return "Pick 1 of n cards from the draw pile to put on top of the draw pile."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	await CardHelper.seek(actor, num_cards)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [num_cards, super.get_shortform(card)]
