class_name TeleportRandomly
extends ItemAction


func get_description() -> String:
	return "Teleport to a random location%s." % [get_radius_desc()]

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false

	var target_chars := _get_target_chars(pos)

	var positions : Array[Vector2i] = Globals.floor_map.get_type_positions([TileResource.Terrains.GROUND])
	for target_char in target_chars:
		# find a random, unoccupied location
		
		var rand_pos : Vector2i = positions.pick_random()
		while ActorManager.get_actor_in_position(rand_pos):
			rand_pos = positions.pick_random()
		
		# now there are no actors in the selected position
		# teleport to that tile
		target_char.move_to(rand_pos)
		target_char.update_vision()
	return true
