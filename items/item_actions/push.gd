class_name PushAction
extends ItemAction

func get_description() -> String:
	return "Push target away."

func use(owner: Char, pos: Vector2i) -> bool:
	var target_chars := _get_target_chars(owner, pos)

	await do_animation(owner, pos)

	for target_char in target_chars:
		CardHelper.push_target(target_char, owner.grid_position, 100)
	return true
