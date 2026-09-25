class_name DisarmAction
extends ItemAction

func get_description() -> String:
	return "Discard target main hand%s." % [get_radius_desc()]

func use(owner: Char, pos: Vector2i) -> bool:
	var target_chars := _get_target_chars(owner, pos)
	
	await do_animation(owner, pos)

	for target_char in target_chars:
		target_char.deck.discard_primary()
		target_char.deck.draw_empty()
	return true
