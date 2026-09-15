class_name SwapAction
extends ItemAction

func get_description() -> String:
	return "Switch locations with the target."

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false
	
	var target_chars := _get_target_chars(owner, pos)
	if target_chars.is_empty():
		return false

	for target_char in target_chars:
		var tmp := owner.grid_position
		owner.move_to(pos)
		if is_instance_valid(target_char):
			target_char.move_to(tmp)
	return true
