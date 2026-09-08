class_name ScryAction
extends ItemAction

func get_description() -> String:
	return "Look at the draw pile and select cards to discard." % [get_radius_desc()]

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false

	var target_chars := _get_target_chars(owner, pos)
	if target_chars.is_empty():
		return false

	for target_char in target_chars:
		await CardHelper.scry(target_char, 100)
	return true
