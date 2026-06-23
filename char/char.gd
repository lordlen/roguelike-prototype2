class_name Char
extends Sprite2D 

const stats_resources := {
	hero = "res://char/stats/hero.tres",
	jackal = "res://char/stats/jackal.tres",
	toad = "res://char/stats/toad.tres"
}

enum Alignment {
	GOOD,
	EVIL
}

enum Traversal {
	GROUNDED,
	AQUATIC,
	FLYING
}

static var _curr_char_id := 0

var char_id: int
var grid_position: Vector2i
var character_name: String
var max_hp: int
var curr_hp: int

var bonus_defense := 0

var wandering_state: AiState
var hunting_state: HuntingState
var sleeping_state: AiState
var curr_state: AiState

var target_ch: Char = self

var alignment: Alignment
var traversal: Traversal
var user_controlled: bool

var vision_set: Dictionary[Vector2i, bool] = {}
var explored_set : Dictionary[Vector2i, bool] = {}
var visible_actors: Array[Char] = []
var vision_range: int
var scent_range: int

var action_queue: Array[Action] = []

var deck: Deck

var leader: Char
var followers: Array[Char]

var flow_map: DijkstraMap
var target_flow_map: DijkstraMap
var moved_last_turn: bool
var moved_this_turn: bool

func _init(stats: CharacterStats, position: Vector2i):
	self.char_id = _curr_char_id
	_curr_char_id += 1
	self.texture = stats.texture
	self.grid_position = position
	centered = false
	self.position = Vector2(grid_position.x * Consts.TILE_SIZE, grid_position.y * Consts.TILE_SIZE)
	self.character_name = stats.character_name
	self.max_hp = stats.max_hp
	self.curr_hp = stats.max_hp
	
	self.deck = Deck.new(stats.cards)
	self.deck.initialize()
	
	# AI
	self.wandering_state = stats.wandering
	self.sleeping_state = stats.sleeping
	self.hunting_state = stats.hunting
	self.curr_state = sleeping_state
	
	self.alignment = stats.alignment
	self.traversal = stats.traversal
	self.user_controlled = stats.user_controlled
	
	self.vision_range = stats.vision_range
	self.scent_range = stats.scent_range
	
	self.leader = self
	self.followers = []
	
	moved_last_turn = false
	if alignment == Alignment.EVIL:
		visible = false

	EventBus.emit_signal("new_actor_added", self)

func move_to(new_grid_pos: Vector2i):
	if self.grid_position != new_grid_pos:
		self.moved_this_turn = true
	
	self.grid_position = new_grid_pos
	self.position = self.grid_position * Consts.TILE_SIZE
	var tile := Globals.floor_map.get_tile(new_grid_pos)
	if tile == RoomPattern.TileType.GRASS\
	and traversal != Traversal.FLYING:
		Globals.floor_map.update_tile(new_grid_pos, RoomPattern.TileType.TRAMPLED_GRASS)
	
	# stairs dialog
	if user_controlled and tile == RoomPattern.TileType.STAIRS:
		# activate the stairs dialog
		EventBus.stairs_popup_signal.emit()

func turn_start():
	moved_last_turn = moved_this_turn
	if moved_last_turn:
		flow_map = null
	moved_this_turn = false
	
	self.bonus_defense = 0
	
	self.deck.draw_empty()
	EventBus.character_deck_updated.emit(self)
	update_vision()

func get_flow_map(is_forced: bool = false) -> DijkstraMap:
	if flow_map != null and !is_forced:
		return flow_map
	flow_map = DijkstraMap.new(Globals.floor_map)
	flow_map.set_traversal(traversal)
	flow_map.set_targets([grid_position])
	flow_map.set_chars(Globals.actors)
	# typical sight range is 8, so this depth should be enough, making it fast
	flow_map.instantiate(16)
	return flow_map

func act_ai() -> Array[Action]:
	turn_start()
	return curr_state.act(self)

func swap():
	var temp := self.deck.primary
	self.deck.primary = self.deck.offhand
	self.deck.offhand = temp
	EventBus.character_deck_updated.emit(self)

func update_vision():
	vision_set.clear()
	FoV.new(Globals.floor_map, vision_set, explored_set).compute_fov(self.grid_position, vision_range)

	var prev_visible_actors := self.visible_actors
	var new_visible_actors : Array[Char]= []
	
	var new_actor_in_vision := false
	for actor in ActorManager.get_chars():
		if vision_set.has(actor.grid_position):
			if self.is_user_controlled():
				actor.visible = true
			new_visible_actors.push_back(actor)
			if !prev_visible_actors.has(actor):
				new_actor_in_vision = true
		else:
			if self.is_user_controlled():
				actor.visible = false
	self.visible_actors = new_visible_actors
	if new_actor_in_vision:
		self.action_queue.clear()
	EventBus.emit_signal("character_fov_updated", self)

func pass_turn():
	self.deck.exhaust_ethereal()
	self.deck.draw_empty()
	EventBus.character_deck_updated.emit(self)

func can_traverse(pos: Vector2i):
	var tile := Globals.floor_map.get_tile(pos)
	
	return Tiles.get_pf_cost(traversal, tile) != INF

func is_user_controlled():
	return user_controlled

# control the character using user input. 
func act_player():
	turn_start()
	if action_queue.is_empty():
		EventBus.emit_signal("user_input_requested", self)
	else:
		var action : Action = action_queue.pop_front()
		var is_success = action.execute()
		# if an action fails, remove the queue and request user input
		if !is_success:
			action_queue.clear()
			EventBus.emit_signal("user_input_requested", self)
		else:
			EventBus.emit_signal("turn_ended")

func take_hit(attacker: Char, damage: int):	
	if deck.offhand and deck.offhand.is_dodge:
		deck.discard_offhand()
		EventBus.character_deck_updated.emit(self)
		return

	var offhand_def := 0
	if deck.offhand:
		offhand_def = deck.offhand.defense
		deck.offhand.do_on_hit(attacker, self)
	var defense := offhand_def + bonus_defense
	var final_damage: int = max(0, damage - defense)
	take_damage(final_damage)
	

func take_damage(damage: int) -> void:
	self.curr_hp -= damage
	EventBus.character_hp_updated.emit(self)
	if self.curr_hp <= 0:
		die()

func die():
	# if has followers
	if !followers.is_empty():
		var new_leader := followers[0]
		new_leader.followers.clear()
		for follower: Char in followers:
			follower.follow(new_leader)
	if leader != self:
		leader.followers.erase(self)
	EventBus.emit_signal("character_died", self)

func is_dead():
	return curr_hp <= 0

func wander():
	curr_state = wandering_state
	EventBus.character_state_changed.emit(self)
	for follower in followers:
		follower.wander()

func hunt(prey : Char):
	target_ch = prey
	target_flow_map = prey.get_flow_map()
	curr_state = hunting_state
	EventBus.character_state_changed.emit(self)

# set the dijkstra map of self and followers
func wander_to(pos: Vector2i):
	target_flow_map = DijkstraMap.new(Globals.floor_map)
	target_flow_map.set_traversal(traversal)
	target_flow_map.set_targets([pos])
	target_flow_map.set_chars(Globals.actors)
	target_flow_map.instantiate()
	for follower in followers:
		follower.target_flow_map = target_flow_map
	wander()

func wander_to_random():
	# pick a random dijkstra map from the floor
	target_flow_map = Globals.floor_map.pick_random_dijkstra_map()
	for follower in followers:
		follower.target_flow_map = target_flow_map
	wander()

func hunt_with_team(prey: Char):
	self.leader.hunt(prey)
	for follower in self.leader.followers:
		follower.hunt(prey)

func follow(ch: Char):
	leader = ch
	if ch != self:
		ch.followers.push_back(self)
