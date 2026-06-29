class_name ExploreAll
extends ItemAction

func get_description() -> String:
	return "Unfog all tiles%s." % [get_radius_desc()]

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false
	
	var target_chars := _get_target_chars(pos)
	if target_chars.is_empty():
		return false
	
	for target_char in target_chars:
		for x in range(Globals.floor_map.width):
			for y in range(Globals.floor_map.height):
				target_char.explored_set[Vector2i(x,y)] = true
		target_char.update_vision()
	return true
