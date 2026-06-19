class_name CustomAstar
extends AStarGrid2D

var costs: Dictionary[RoomPattern.TileType, float]
func set_cost_dict(c: Dictionary[RoomPattern.TileType, float]):
	costs = c

var char_cost := 4.0
func set_char_cost(c: float):
	char_cost = c

func _compute_cost(from_id: Vector2i, to_id: Vector2i) -> float:
	var tile := Globals.floor_map.get_tile(to_id)
	
	# check if there is an actor in the way
	
	var actor_found := false
	for a in ActorManager.get_chars():
		if a.grid_position == to_id:
			actor_found = true
			break

	var actor_cost := char_cost if actor_found else 0.0
	
	if tile in costs:
		return costs[tile] + actor_cost
	else:
		return INF
