class_name Disarm
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "disarm" if target == Target.ENEMY else "self-disarm"

func get_description() -> String:
	return "Discard target main-hand"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else target_char
	if t.deck.primary:
		t.deck.primary.do_on_discard_effects(t)
		t.deck.discard_primary()
	card_effect_finished.emit()
