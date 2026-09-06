class_name Pull
extends CardEffect

func get_identifier() -> String:
	return "pull"
	
func get_description() -> String:
	return 'Pull target to myself'

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var target_char := ActorManager.get_actor_in_position(target_pos)
	if is_instance_valid(target_char):
		var line := Geometry2D.bresenham_line(actor.grid_position, target_pos)
		if len(line) >= 3:
			target_char.move_to(line[1])
	card_effect_finished.emit()
