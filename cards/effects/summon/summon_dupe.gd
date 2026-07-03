extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# calculate damage I would take
	var final_hp := actor.curr_hp

	# spawn a random enemy with some hp
	var valid_adjacent := Globals.floor_map.get_valid_adjacent(actor.grid_position)

	# if there are no valid tiles, just do nothing
	if valid_adjacent.is_empty() or final_hp <= 0:
		card_effect_finished.emit()
		return

	var rand_adjacent : Vector2i = valid_adjacent.pick_random()

	var char := Char.new(actor.char_stats, rand_adjacent)
	char.set_hp(final_hp)
	# force discard all to prevent attacking on summon
	char.deck.discard_all()
	card_effect_finished.emit()
