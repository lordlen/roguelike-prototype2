class_name Break
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "break" if target == Target.ENEMY else "self-break"

func get_description() -> String:
	return "Discard target off-hand"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else target_char
	if t.deck.offhand:
		t.deck.offhand.do_on_discard_effects(t)
		t.deck.discard_offhand()
	card_effect_finished.emit()
