class_name SetAtk
extends CardEffect

@export var atk_value: int

func do(actor: Char, target_char: Char, card: CardInstance) -> void:

	card.attack = atk_value
	
	card_effect_finished.emit()

func get_full_description(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_full_description(card)]

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
