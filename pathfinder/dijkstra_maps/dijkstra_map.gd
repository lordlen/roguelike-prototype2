class_name DijkstraMap
extends RefCounted

const max_int:=9223372036854775807

var map: PackedFloat64Array
var width: int
var height: int
var targets: Array[Vector2i]
var floor : Floor
var cost_map: Dictionary[RoomPattern.TileType, float]
var char_dict: Dictionary[Vector2i, Char]
var chars: Array[Char]
var traversal: Char.Traversal

func _init(floor: Floor) -> void:
	self.floor = floor
	width = floor.width
	height = floor.height
	char_dict = {}
	chars = []
	map = PackedFloat64Array()
	map.resize(width * height)

func get_ind(v: Vector2i) -> int:
	return v.x + v.y * width

func set_targets(targets: Array[Vector2i]):
	self.targets = targets

func set_traversal(t: Char.Traversal):
	self.traversal = t

func set_chars(chars: Array[Char]):
	self.chars = chars

#func roll_down(pos: Vector2i, char_impassable: bool = false) -> Vector2i:
	#var best_pos := pos
	#var best_dist := map[get_ind(pos)]
	#
	#for v in _get_adjacent_edges(pos):
		#var char_in_location := false if char_impassable else chars.any(func(ch: Char): return ch.grid_position == v)
		#if is_within_bounds(v) and !char_in_location:
			#var curr_dist := map[get_ind(v)]
			#if best_dist > curr_dist or (char_impassable and best_dist == curr_dist):
				#best_dist = curr_dist
				#best_pos = v
	#return best_pos

func roll_down(pos: Vector2i, char_impassable: bool = false) -> Vector2i:
	var pq := PriorityQueue.new()
	for v in _get_adjacent_edges(pos):
		# var char_in_location := false if char_impassable else chars.any(func(ch: Char): return ch.grid_position == v)
		# if is_within_bounds(v) and !char_in_location:
		if is_within_bounds(v):
			var curr_dist := map[get_ind(v)]
			pq.push(v, curr_dist)
	# get the first element in pq that is not occupied by any char
	var char_dict := ActorManager.get_chars_dict()
	var best_pos := pos
	while !pq.is_empty():
		var top = pq.pop()
		var v: Vector2i = Vector2i(top.x, top.y)
		if v not in char_dict:
			return v
	return best_pos

func instantiate(depth: int = max_int) -> void:
	for char in chars:
		char_dict[char.grid_position] = char
	# map acts as the explored array. If not explored or a wall, it's max int
	map.fill(INF)

	var pq := PriorityQueue.new()
	
	# push all targets into the pq
	for t in targets:
		map[get_ind(t)] = 0.0
		pq.push(t, 0.0)

	while !pq.is_empty():
		var pair: Vector3 = pq.pop()
		var d = pair.z
		var u := Vector2i(pair.x, pair.y)
	
		# check if already explored with a better value or depth is reached
		if d > depth or d > map[get_ind(u)]:
			continue

		for v in _get_adjacent_edges(u):
			# determine the cost
			var tile := floor.get_tile(v)
			
			# if out of bounds, impassable tile, or a character who hasn't moved
			# is in the way, treat all as impassable
			var blocking_char := ActorManager.get_actor_in_position(v)
			var w := Tiles.get_pf_cost(traversal, tile)\
			+ (4.0 if (blocking_char != null and !blocking_char.moved_last_turn) else 0.0)
			if !is_within_bounds(v) or w == INF:
				continue
			
			# cost of current location + the adjacent
			var total_cost := map[get_ind(u)] + w
			var curr_best_cost := map[get_ind(v)]
			
			if total_cost < curr_best_cost:
				map[get_ind(v)] = map[get_ind(u)] + w
				pq.push(v, total_cost)

static func _is_diagonal(u: Vector2i, v: Vector2i):
	return u.x - v.x != 0 and u.y - v.y != 0

static func _get_adjacent_edges(coord: Vector2i) -> Array[Vector2i]:
	# prioritize the diagonal edges before the cardinal edges
	return [
		coord + Vector2i.UP,
		coord + Vector2i.DOWN,
		coord + Vector2i.LEFT,
		coord + Vector2i.RIGHT,
		coord + Vector2i.UP + Vector2i.LEFT,
		coord + Vector2i.UP + Vector2i.RIGHT,
		coord + Vector2i.DOWN + Vector2i.LEFT,
		coord + Vector2i.DOWN + Vector2i.RIGHT,
	]

static func _get_cardinal_edges(coord: Vector2i) -> Array[Vector2i]:
	return [
		coord + Vector2i.UP,
		coord + Vector2i.DOWN,
		coord + Vector2i.LEFT,
		coord + Vector2i.RIGHT,
	]

static func _get_diagonal_edges(coord: Vector2i) -> Array[Vector2i]:
	return [
		coord + Vector2i.UP + Vector2i.LEFT,
		coord + Vector2i.UP + Vector2i.RIGHT,
		coord + Vector2i.DOWN + Vector2i.LEFT,
		coord + Vector2i.DOWN + Vector2i.RIGHT,
	]

func is_within_bounds(v: Vector2i):
	return 0 <= v.x and 0 <= v.y and v.x < width and v.y < height

func destination_reached(pos: Vector2i):
	return map[get_ind(pos)] == 0
