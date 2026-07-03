class_name MirrorShrine2
extends ItemAction

func get_description() -> String:
	return "Duplicate current enemies on the floor"

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false
	
	var actors := ActorManager.get_ai_controlled_chars().duplicate()
	for enemy: Char in actors:
		
		var final_hp := enemy.curr_hp

		# spawn a random enemy with some hp
		var valid_adjacent := Globals.floor_map.get_valid_adjacent(enemy.grid_position)

		# if there are no valid tiles, just do nothing
		if valid_adjacent.is_empty() or final_hp <= 0:
			continue

		var rand_adjacent : Vector2i = valid_adjacent.pick_random()

		var char := Char.new(enemy.char_stats, rand_adjacent)
		char.set_hp(final_hp)
		# force discard all to prevent attacking on summon
		char.deck.discard_all()
		# follow the enemy it was duplicated off of
		char.follow(enemy)
		if !enemy.is_asleep():
			char.wander()
	# maybe also double items?
	return true
