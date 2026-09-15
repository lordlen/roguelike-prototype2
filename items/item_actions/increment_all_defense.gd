class_name IncrementAllDefense
extends ItemAction

# heals percent of missing hp
@export var value: int

func get_description() -> String:
	return "Increase the defense of all cards for this floor by %d%s." % [value, get_radius_desc()]

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false

	var target_chars := _get_target_chars(owner, pos)
	if target_chars.is_empty():
		return false

	for target_char in target_chars:
		for c in target_char.deck.draw_pile:
			c.defense += value

		for c in target_char.deck.discard_pile:
			c.defense += value

		if target_char.deck.primary:
			target_char.deck.primary.defense += value

		if target_char.deck.offhand:
			target_char.deck.offhand.defense += value
		EventBus.character_deck_updated.emit(target_char)
	return true
