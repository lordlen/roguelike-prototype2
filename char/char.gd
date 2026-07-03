class_name Char
extends Sprite2D 

signal char_finished_moving
signal char_finished_attacking

const stats_resources := {
	hero = "res://char/stats/hero.tres",
	jackal = "res://char/stats/jackal.tres",
	toad = "res://char/stats/toad.tres",
	rat = "res://char/stats/rat.tres",
	slime = "res://char/stats/slime.tres"
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

var wandering_state: AiState
var hunting_state: HuntingState
var sleeping_state: AiState
var curr_state: AiState

var target_ch: Char = self

var alignment: Alignment
var traversal: Traversal
var user_controlled: bool
var is_cautious: bool

var vision_set: Dictionary[Vector2i, bool] = {}
var explored_set : Dictionary[Vector2i, bool] = {}
var visible_actors: Array[Char] = []
var vision_range: int
var scent_range: int

var action_queue: Array[Action] = []

var deck: Deck
var is_defending: bool
var is_hit: bool = false

var leader: Char
var followers: Array[Char]
var is_elite := false

var flow_map: DijkstraMap
var target_flow_map: DijkstraMap
var moved_last_turn: bool
var moved_this_turn: bool

var speed := 500
var new_pos : Vector2
var is_moving: bool

var attack_speed := 1000
var is_attacking := false
var is_returning := false
var offset_target: Vector2

var inventory: InventoryComponent
var char_stats: CharacterStats

func _init(stats: CharacterStats, position: Vector2i, is_elite := false):
	char_stats = stats
	self.char_id = _curr_char_id
	_curr_char_id += 1
	self.is_elite = is_elite
	self.texture = stats.texture
	self.grid_position = position
	centered = false
	self.position = Vector2(grid_position.x * Consts.TILE_SIZE, grid_position.y * Consts.TILE_SIZE)
	self.new_pos = self.position
	self.character_name = stats.character_name
	self.max_hp = randi_range(stats.min_hp, stats.max_hp)
	self.curr_hp = self.max_hp

	self.deck = Deck.new(stats.cards, stats.innate_cards)
	self.deck.initialize()
	
	# AI
	self.wandering_state = stats.wandering
	self.sleeping_state = stats.sleeping
	self.hunting_state = stats.hunting
	self.curr_state = sleeping_state
	
	self.alignment = stats.alignment
	self.traversal = stats.traversal
	self.user_controlled = stats.user_controlled
	self.is_cautious = stats.is_cautious
	
	self.vision_range = stats.vision_range
	self.scent_range = stats.scent_range
	
	self.leader = self
	self.followers = []
	
	self.inventory = InventoryComponent.new(self, 3)
	#TODO: remove temporary potions
	if user_controlled:
		var potion := load("res://items/potions/clairvoyance_potion.tres") as Item
		self.inventory.add_item(potion)
		EventBus.inventory_updated.emit(self)
	
	moved_last_turn = false
	if alignment == Alignment.EVIL:
		visible = false

	EventBus.emit_signal("new_actor_added", self)

func set_elite():
	self.is_elite = true

func _physics_process(delta: float) -> void:
	if is_moving:
		if position.is_equal_approx(new_pos):
			is_moving = false
			char_finished_moving.emit()
		else:
			position = position.move_toward(new_pos, speed * delta)
	if is_attacking:
		# move offset to the target
		if is_returning:
			if offset.is_equal_approx(Vector2.ZERO):
				is_attacking = false
				char_finished_attacking.emit()
			else:
				offset = offset.move_toward(Vector2.ZERO, attack_speed * delta)
		else:
			if offset.is_equal_approx(offset_target):
				is_returning = true
			else:
				offset = offset.move_toward(offset_target, attack_speed * delta)
		

func attack_animation(target_grid_pos: Vector2i):
	is_attacking = true
	is_returning = false
	offset_target = Vector2(target_grid_pos - grid_position) * Consts.TILE_SIZE

func move_to(new_grid_pos: Vector2i, speed: float = INF):
	if self.grid_position != new_grid_pos:
		self.moved_this_turn = true

	ActorManager.move_actor(self, new_grid_pos)

	# move smoothly
	self.speed = speed
	self.new_pos = self.grid_position * Consts.TILE_SIZE
	if speed == INF:
		self.position = self.new_pos
	else:
		self.is_moving = true

	var tile := Globals.floor_map.get_tile(new_grid_pos)
	if tile == RoomPattern.TileType.GRASS\
	and traversal != Traversal.FLYING:
		Globals.floor_map.update_tile(new_grid_pos, RoomPattern.TileType.TRAMPLED_GRASS)

	# stairs dialog
	if user_controlled:
		if tile == RoomPattern.TileType.STAIRS:
			# activate the stairs dialog
			self.action_queue.clear()
			EventBus.stairs_popup_signal.emit()
		if ItemManager.item_in_position(grid_position):
			var item := ItemManager.get_top_item(grid_position).item_resource
			var successful_pickup := await item.on_pick_up(inventory)
			if successful_pickup:
				ItemManager.pop_item_from_overworld(grid_position)

func turn_start():
	moved_last_turn = moved_this_turn
	flow_map = null
	moved_this_turn = false
	
	if is_defending and is_hit:
		deck.dispose_offhand()

	deck.draw_empty()

	is_defending = false
	is_hit = false
	
	if deck.offhand != null:
		deck.offhand.reset_bonus_defense()
	
	# get the tile the char is standing on
	var tile := Tiles.TileDictionary[Globals.floor_map.get_tile(grid_position)]
	tile.on_walk(self)

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
	if user_controlled:
		var items_in_vision := ItemManager.get_items_in_area(vision_set.keys())
		for item in items_in_vision:
			item.visible = true
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

func is_asleep():
	return self.curr_state == self.sleeping_state

# control the character using user input. 
func act_player():
	turn_start()
	if action_queue.is_empty():
		EventBus.emit_signal("user_input_requested", self)
	else:
		var action : Action = action_queue.pop_front()
		var is_success = await action.execute()
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
	var offhand := deck.offhand
	if offhand != null:
		offhand_def = offhand.get_defense()
	var defense := offhand_def
	var final_damage: int = max(0, damage - defense)
	take_damage(final_damage)
	is_hit = true
	if offhand != null:
		offhand.do_on_hit(attacker, self)
	EventBus.character_deck_updated.emit(self)

func take_damage(damage: int) -> void:
	self.curr_hp -= damage
	self.curr_hp = clamp(curr_hp, 0, max_hp)
	EventBus.character_hp_updated.emit(self)
	if self.curr_hp <= 0:
		die()

func set_hp(hp: int) -> void:
	self.curr_hp = clamp(hp, 0, max_hp)
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
	if is_elite:
		var card_item: Item = load("res://items/card_item/card_item.tres")
		ItemManager.add_item_to_overworld(card_item, grid_position)
	EventBus.character_died.emit(self)

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
	target_flow_map = leader.target_flow_map
	if ch != self:
		ch.followers.push_back(self)
