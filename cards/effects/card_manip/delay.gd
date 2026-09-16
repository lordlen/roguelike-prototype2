class_name Delay
extends CardEffect

func get_identifier() -> String:
	return "delay"

func get_description() -> String:
	return "Insert your main hand into the draw pile randomly."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	if actor.deck.primary:
		actor.deck.insert_to_draw_randomly(actor.deck.primary)
		actor.deck.primary = null
	card_effect_finished.emit()
