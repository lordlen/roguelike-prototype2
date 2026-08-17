class_name SetDef
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "set_def"
	
func get_description() -> String:
	return "Set the defense of this card to n."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:

	card.defense = value
	
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
