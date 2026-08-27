class_name ExhaustOff
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "exhaust_off"

func get_description() -> String:
	return "Exhaust the offhand."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else target_char
	t.deck.offhand = null
	card_effect_finished.emit()
