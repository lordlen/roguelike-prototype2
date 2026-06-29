class_name CleanseAction
extends ItemAction

func get_description() -> String:
	return "Remove all status effects and return all exhausted cards. Reshuffle%s." % [get_radius_desc()]

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false

	var target_chars := _get_target_chars(pos)

	for target_char in target_chars:
		# only damage enemies
		target_char.deck.initialize()
		EventBus.character_deck_updated.emit(target_char)
	return true
