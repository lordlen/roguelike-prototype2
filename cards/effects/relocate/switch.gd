class_name Switch
extends CardEffect

func get_identifier() -> String:
	return "switch"
	
func get_description() -> String:
	return 'Switch locations with the target.'

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	actor.char_move_effect.emit()
	var tmp := actor.grid_position
	actor.move_to(target_pos)
	var target_char := ActorManager.get_actor_in_position(target_pos)
	if is_instance_valid(target_char):
		target_char.move_to(tmp)
	# await actor.char_finished_moving
	card_effect_finished.emit()
