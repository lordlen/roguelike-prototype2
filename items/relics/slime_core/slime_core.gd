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

		var char := Char.new(slime, rand_adjacent)

		# force discard all to prevent attacking on summon
		char.deck.discard_all()
	## add some water around me
	## find a floor tile in an adjacent tile
	#var adj := DijkstraMap._get_adjacent_edges(actor.grid_position)
	#var valid_tiles: Array[Vector2i] = []
	#for cell in adj + [actor.grid_position]:
		#var tile = Tiles.TileDictionary[Globals.floor_map.get_tile(cell)]
		#if is_instance_of(tile, Tiles.Ground):
			#valid_tiles.push_back(cell)
	#for i in range(num_tiles):
		#if valid_tiles.is_empty():
			#break
		#var random_cell : Vector2i = valid_tiles.pick_random()
		#Globals.floor_map.update_tile(random_cell, RoomPattern.TileType.WATER)
		#valid_tiles.erase(random_cell)
