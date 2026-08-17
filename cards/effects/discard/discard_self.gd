class_name Sap
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "sap" if target == Target.ENEMY else "self-sap"

func get_description() -> String:
	return "Discard target top draw pile"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else target_char
	t.deck.discard_top()
	card_effect_finished.emit()
