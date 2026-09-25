class_name IncrementAllAttack
extends ItemAction

# heals percent of missing hp
@export var value: int

func get_description() -> String:
	return "Increase the attack of all cards for this floor by %d%s." % [value, get_radius_desc()]

func use(owner: Char, pos: Vector2i) -> bool:
	var target_chars := _get_target_chars(owner, pos)
	
	await do_animation(owner, pos)

	for target_char in target_chars:
		for c in target_char.deck.draw_pile:
			if c.atk_range > 0:
				c.attack += value

		for c in target_char.deck.discard_pile:
			if c.atk_range > 0:
				c.attack += value

		if target_char.deck.primary:
			if target_char.deck.primary.atk_range > 0:
				target_char.deck.primary.attack += value

		if target_char.deck.offhand:
			if target_char.deck.offhand.atk_range > 0:
				target_char.deck.offhand.attack += value
		EventBus.character_deck_updated.emit(target_char)
	return true
