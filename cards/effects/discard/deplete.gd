class_name Deplete
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "deplete" if target == Target.ENEMY else "self-deplete"

func get_description() -> String:
	return "Discard the draw pile."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else target_char
	t.deck.discard_draw_pile()
	card_effect_finished.emit()
