class_name PushAction
extends ItemAction

func get_description() -> String:
	return "Push target away."

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false
	
	var target_chars := _get_target_chars(owner, pos)
	if target_chars.is_empty():
		return false

	for target_char in target_chars:
		CardHelper.push_target(target_char, owner.grid_position, 100)
	return true
