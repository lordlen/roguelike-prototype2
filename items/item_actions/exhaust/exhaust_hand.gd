class_name ExhaustHand
extends ItemAction

func get_description() -> String:
	return "Exhaust hand%s." % [get_radius_desc()]

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false

	var target_chars := _get_target_chars(pos)

	for target_char in target_chars:
		target_char.deck.exhaust_primary()
		target_char.deck.exhaust_offhand()
		target_char.deck.draw_empty()
		EventBus.character_deck_updated.emit(target_char)
	return true
