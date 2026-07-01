extends CardEffect

@export var char_id: String

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	# calculate damage I would take
	var final_hp := actor.curr_hp - target_char.deck.primary.attack

	# spawn a random enemy with some hp
	var valid_adjacent := Globals.floor_map.get_valid_adjacent(actor.grid_position)

	# if there are no valid tiles, just do nothing
	if valid_adjacent.is_empty() or final_hp <= 0:
		card_effect_finished.emit()
		return

	var rand_adjacent : Vector2i = valid_adjacent.pick_random()

	var char_stats := load(Char.stats_resources[char_id]) as CharacterStats
	var char := Char.new(char_stats, rand_adjacent)
	char.set_hp(final_hp)
	# force discard all to prevent attacking on summon
	char.deck.discard_all()
	card_effect_finished.emit()
