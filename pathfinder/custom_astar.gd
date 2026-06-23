class_name CustomAstar
extends AStarGrid2D

var costs: Dictionary[RoomPattern.TileType, float]

var char_cost := 4.0

var traversal: Char.Traversal
func set_traversal(t: Char.Traversal):
	self.traversal = t

func set_char_cost(c: float):
	char_cost = c

func _compute_cost(from_id: Vector2i, to_id: Vector2i) -> float:
	var tile := Globals.floor_map.get_tile(to_id)
	
	# check if there is an actor in the way
	var actor := ActorManager.get_actor_in_position(to_id)

	var actor_cost := char_cost if actor != null else 0.0
	
	return Tiles.TileDictionary[tile].pf_cost(traversal) + actor_cost
