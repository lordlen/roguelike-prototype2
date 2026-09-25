class_name SeekAction
extends ItemAction

func get_description() -> String:
	return "Choose a card from the draw pile to replace your main hand."

func use(owner: Char, pos: Vector2i) -> bool:
	var target_chars := _get_target_chars(owner, pos)
	
	await do_animation(owner, pos)

	for target_char in target_chars:
		target_char.deck.discard_primary()
		await CardHelper.seek(target_char, 100)
		target_char.deck.draw_empty()
	return true
