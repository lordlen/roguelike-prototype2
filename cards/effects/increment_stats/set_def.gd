class_name SetDef
extends CardEffect

@export var value: int

func do(actor: Char, target_char: Char, card: CardInstance) -> void:

	card.defense = value
	
	card_effect_finished.emit()

func get_full_description(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_full_description(card)]

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
