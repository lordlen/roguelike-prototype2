class_name SplitConsciousness
extends Relic

var used := false
var num_dupes := 1

func on_hit(actor: Char, attacker: Char):
	if used == true:
		return true
	if actor.curr_hp >= actor.max_hp / 2:
		return true
	
	# spawn a random enemy with some hp
	var valid_adjacent := Globals.floor_map.get_valid_adjacent(actor.grid_position)

	# if there are no valid tiles, just do nothing
	if valid_adjacent.is_empty() or actor.curr_hp <= 0:
		return true

	used = true
	
	valid_adjacent.shuffle()
	
	for i in range(min(num_dupes, len(valid_adjacent))):
		var rand_adjacent := valid_adjacent[i]
		var char := Char.new(actor.char_stats, rand_adjacent)
		char.set_hp(actor.curr_hp)
		char.max_hp = actor.curr_hp
		# remove / disable the relic
		char.inventory.clear_relics()
		# force discard all to prevent attacking on summon
		char.deck.discard_all()
	return true
