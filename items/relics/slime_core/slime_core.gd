class_name SlimeCore
extends Relic

@export var num_tiles: int

var num_tracker: int = 0
const num_trigger: int = 2
var slime := load("res://char/stats/slime.tres")

func on_reshuffle(actor: Char):
	num_tracker += 1
	if num_tracker >= num_trigger:
		num_tracker = 0
		# summon slime
		# spawn a random enemy with some hp
		var valid_adjacent := Globals.floor_map.get_valid_adjacent(actor.grid_position)

		# if there are no valid tiles, just do nothing
		if valid_adjacent.is_empty():
			return

		var rand_adjacent : Vector2i = valid_adjacent.pick_random()

		var char := ActorManager.spawn_character(slime)
		char.move_to(rand_adjacent)

		# force discard all to prevent attacking on summon
		char.deck.discard_all()
