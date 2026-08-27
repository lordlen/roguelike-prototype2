class_name SetAtk
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "set_atk"
	
func get_description() -> String:
	return "Set the attack of this card to n."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:

	card.attack = value
	
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
