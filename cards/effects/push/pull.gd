class_name Pull
extends CardEffect

func get_identifier() -> String:
	return "pull"
	
func get_description() -> String:
	return 'Pull target to myself'

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var line := Geometry2D.bresenham_line(actor.grid_position, target_char.grid_position)
	if len(line) >= 3:
		target_char.move_to(line[1])
	card_effect_finished.emit()
