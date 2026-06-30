extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	# subtract the target and actor location
	var difference := actor.grid_position - target_char.grid_position
	var new_position := actor.grid_position + difference
	
	# make a line to the new position
	var pf := Pathfinder.new()
	var backslide_path := pf.get_straight_path_actor(actor.grid_position, new_position, actor.traversal)
	var dest := backslide_path[len(backslide_path) - 1]
	
	actor.move_to(dest)
