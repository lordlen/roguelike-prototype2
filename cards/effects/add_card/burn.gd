class_name Burn
extends CardEffect

@export var num_cards: int

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var add_card_effect := AddCard.new()
	add_card_effect.card_resource = load("res://cards/card_resources/special/burn.tres")
	add_card_effect.target = Target.ENEMY
	add_card_effect.num_cards = num_cards
	add_card_effect.do(actor, target_char, card)
	card_effect_finished.emit()

func get_identifier() -> String:
	return "burn"

func get_description() -> String:
	return 'Add n "Burn" cards to the discard pile.'

func get_numeric() -> String:
	return "n"

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [num_cards, super.get_shortform(card)]
