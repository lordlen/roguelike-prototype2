class_name Backslide
extends CardEffect

func get_identifier() -> String:
	return "backslide"
	
func get_description() -> String:
	return 'Move back 1 tile.'

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# subtract the target and actor location
	var difference := actor.grid_position - target_char.grid_position
	var new_position := actor.grid_position + difference
	
	# make a line to the new position
	var pf := Pathfinder.new()
	var backslide_path := pf.get_straight_path_actor(actor.grid_position, new_position, actor.traversal)
	var dest := backslide_path[len(backslide_path) - 1]
	
	if dest != actor.grid_position:
		actor.char_move_effect.emit()
	
	actor.move_to(dest)
	card_effect_finished.emit()
