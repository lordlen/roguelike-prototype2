class_name Invert
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "invert" if target == Target.ENEMY else "self-invert"

func get_description() -> String:
	return "Swap the draw and discard pile."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else target_char
	t.deck.invert_piles()
	card_effect_finished.emit()
