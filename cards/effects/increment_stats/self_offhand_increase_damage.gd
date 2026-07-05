class_name SelfOffhandIncreaseAtk
extends CardEffect

@export var atk_value: int

func do(actor: Char, target_char: Char, card: CardInstance) -> void:

	if actor.deck.offhand != null:
		actor.deck.offhand.attack += atk_value
	
	card_effect_finished.emit()

func get_description() -> String:
	return description % atk_value
