class_name CardEffect
extends Resource

signal card_effect_finished

@export var description: String

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	card_effect_finished.emit()

func get_description() -> String:
	return description
