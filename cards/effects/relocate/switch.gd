class_name Switch
extends CardEffect

func get_identifier() -> String:
	return "switch"
	
func get_description() -> String:
	return 'Switch locations with the target.'

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	actor.char_move_effect.emit()
	var tmp := actor.grid_position
	actor.move_to(target_char.grid_position)
	target_char.move_to(tmp)
	# await actor.char_finished_moving
	card_effect_finished.emit()
