extends CardEffect

@export var summoned_char: CharacterStats

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# spawn a random enemy with some hp
	var valid_adjacent := Globals.floor_map.get_valid_adjacent(actor.grid_position)

	# if there are no valid tiles, just do nothing
	if valid_adjacent.is_empty():
		card_effect_finished.emit()
		return

	var rand_adjacent : Vector2i = valid_adjacent.pick_random()

	var char := Char.new(summoned_char, rand_adjacent)

	# force discard all to prevent attacking on summon
	char.deck.discard_all()
	card_effect_finished.emit()
