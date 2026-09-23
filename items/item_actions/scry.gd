class_name ScryAction
extends ItemAction

func get_description() -> String:
	return "Return all cards into the draw pile. Look at the draw pile and select cards to discard."

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false

	var target_chars := _get_target_chars(owner, pos)
	if target_chars.is_empty():
		return false

	for target_char in target_chars:
		# first, shuffle the deck including hand
		await target_char.deck.discard_all()
		target_char.deck.shuffle()
		await CardHelper.scry(target_char, 100)
		target_char.deck.draw_empty()
	return true
