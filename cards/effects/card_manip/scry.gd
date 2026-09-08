class_name Scry
extends CardEffect

@export var num_cards: int

func get_identifier() -> String:
	return "scry"

func get_description() -> String:
	return "Look at the top n cards in the draw pile and select cards to discard."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	await CardHelper.scry(actor, num_cards)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [num_cards, super.get_shortform(card)]
