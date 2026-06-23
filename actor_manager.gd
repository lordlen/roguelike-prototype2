extends Node

# prevents the _process from doing continuous loops
var block_process := false

var rng = RandomNumberGenerator.new()

var spawn_turn_count := 0
var num_turns_to_spawn: int
var subsequent_spawns: SpawnDescription
func _ready():
	spawn_turn_count = 0
	num_turns_to_spawn = -1
	subsequent_spawns = null
	rng.randomize()
	EventBus.connect("new_actor_added", _add_actor)
	EventBus.connect("character_died", _remove_actor)

func _add_actor(ch: Char):
	if ch.user_controlled:
		Globals.user_controlled.push_back(ch)
	else:
		Globals.ai_controlled.push_back(ch)

func _remove_actor(ch: Char):
	if ch.user_controlled:
		Globals.user_controlled.erase(ch)
	else:
		Globals.ai_controlled.erase(ch)
	ch.queue_free()

func _process(delta: float) -> void:
	if block_process:
		return
	await do_actor_turns()

func do_actor_turns():
	block_process = true
	# get the user controlled actors
	for ch: Char in get_user_controlled_chars():
		ch.act_player.call_deferred()
		await EventBus.turn_ended
		ch.pass_turn()

	for ch: Char in get_ai_controlled_chars():
		if ch.is_dead():
			continue
		var actions := await ch.act_ai()
		for action in actions:
			await action.execute()
		ch.pass_turn()
	
	spawn_turn_count += 1
	
	if spawn_turn_count == num_turns_to_spawn:
		
		spawn_turn_count = 0
		var spawn_group := subsequent_spawns.get_random_spawn_group()
		random_spawn_character(spawn_group, true)

	block_process = false

func configure_spawning(spawn_desc: SpawnDescription, num_turns_to_spawn):
	self.subsequent_spawns = spawn_desc
	self.num_turns_to_spawn = num_turns_to_spawn
	self.spawn_turn_count = 0

func random_spawn_character(spawn_group: SpawnGroup, is_awake := false):
	# find a random point on the map. If aquatic, only get water tiles
	# if not aquatic, just pick a non-water tile
	var ch_stats := spawn_group.group[0]
	var followers : Array[CharacterStats] = spawn_group.group.slice(1)
	var spawn_tiles : Array[RoomPattern.TileType] = [RoomPattern.TileType.FLOOR, RoomPattern.TileType.GRASS]
	if ch_stats.traversal == Char.Traversal.AQUATIC:
		spawn_tiles = [RoomPattern.TileType.WATER]
	var possible_positions := Globals.floor_map.get_type_positions(spawn_tiles)
	# check all actors
	var actor_positions = ActorManager.get_chars().map(func(ch: Char) -> Vector2i: return ch.grid_position)
	var players_locations := get_user_controlled_chars().map(func(ch: Char): return ch.grid_position)
	
	var min_spawn_dist := 10
	var unoccupied_tiles = possible_positions.filter(\
		func(pos: Vector2i):
			return pos not in actor_positions and !players_locations.any(func(v: Vector2i): return Pathfinder.chebychev_dist(v, pos) < min_spawn_dist))
	
	if len(unoccupied_tiles) == 0:
		print('no valid spawn tiles')
	else:
		var pos : Vector2i = unoccupied_tiles.pick_random()
		var leader := Char.new(ch_stats, pos)
		var f_ind := 0
		for x in range(pos.x - 1, pos.x + 2):
			for y in range(pos.y - 1, pos.y + 2):
				var new_pos := Vector2i(x,y)
				if f_ind >= len(followers):
					break
				if new_pos == pos:
					continue
				if new_pos in unoccupied_tiles:
					var f_stats := followers[f_ind]
					var follower := Char.new(f_stats, new_pos)
					follower.follow(leader)
					f_ind += 1
		if is_awake:
			leader.wander()

func spawn_initial_characters(spawn_description: SpawnDescription, num_spawns: int):
	for i in range(num_spawns):
		# pick a random index from
		var ind = rng.rand_weighted(spawn_description.weights)
		var spawn_group := spawn_description.pool[ind]
		random_spawn_character(spawn_group)

func get_actor_in_position(pos: Vector2i) -> Char:
	var actors := get_chars()
	var ind := actors.find_custom(func(ch: Char): return ch.grid_position == pos)
	if ind != -1:
		return actors[ind]
	else:
		return null

func get_user_controlled_chars() -> Array[Char]:
	return Globals.user_controlled

func get_ai_controlled_chars() -> Array[Char]:
	return Globals.ai_controlled

func get_chars() -> Array[Char]:
	return Globals.user_controlled + Globals.ai_controlled
