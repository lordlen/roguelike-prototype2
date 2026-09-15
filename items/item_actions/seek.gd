class_name SeekAction
extends ItemAction

func get_description() -> String:
	return "Choose a card from the draw pile to replace your main hand."

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false

	var target_chars := _get_target_chars(owner, pos)
	if target_chars.is_empty():
		return false

	for target_char in target_chars:
		target_char.deck.discard_primary()
		await CardHelper.seek(target_char, 100)
		target_char.deck.draw_empty()
	return true
