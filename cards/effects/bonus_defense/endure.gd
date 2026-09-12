class_name Endure
extends CardEffect

func get_identifier() -> String:
	return "endure"

func get_description() -> String:
	return "Remove all decay from own offhand."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	if actor.deck.offhand:
		actor.deck.offhand.reset_defense_decay()
	card_effect_finished.emit()
