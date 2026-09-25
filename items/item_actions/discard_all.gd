class_name DiscardAll
extends ItemAction

func get_description() -> String:
	return "Discard all cards%s." % [get_radius_desc()]

func use(owner: Char, pos: Vector2i) -> bool:
	var target_chars := _get_target_chars(owner, pos)
	
	await do_animation(owner, pos)

	for target_char in target_chars:
		# only damage enemies
		if target_char.alignment != owner.alignment:
			await target_char.deck.discard_all()
			EventBus.character_deck_updated.emit(target_char)
	return true
