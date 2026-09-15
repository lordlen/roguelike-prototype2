class_name Die
extends CardEffect

func get_identifier() -> String:
	return "die"
	
func get_description() -> String:
	return "The user dies."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	actor.die()
	card_effect_finished.emit()
