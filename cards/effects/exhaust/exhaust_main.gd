class_name ExhaustMain
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "exhaust_main"

func get_description() -> String:
	return "Exhaust the main-hand."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else target_char
	t.deck.primary = null
	card_effect_finished.emit()
