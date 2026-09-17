extends Camera2D
class_name MainCamera

var _previousPosition: Vector2 = Vector2(0, 0)
var _moveCamera: bool = false
var _mouse_is_pressed: bool = false
var THRESHOLD: int = 8

var gesture_timer : Timer
var is_gesturing := false

var is_aiming := false
var stored_item: Item
var stored_action: ItemAction

var actor: Char

var target_pos: Vector2
var target_speed: float = 5
var is_targeting := false

func _physics_process(delta: float) -> void:
	if is_targeting:
		position = position.lerp(target_pos, delta * target_speed)
		if position.distance_to(target_pos) <= THRESHOLD:
			is_targeting = false

func _ready() -> void:
	EventBus.user_input_requested.connect(on_user_input_requested)
	EventBus.camera_move_requested.connect(move_camera_position)
	EventBus.item_used.connect(on_item_used)
	EventBus.wait_button_pressed.connect(on_wait_pressed)
	EventBus.swap_button_pressed.connect(on_swap_pressed)
	EventBus.reshuffle_button_pressed.connect(on_reshuffle_pressed)
	EventBus.defend_button_pressed.connect(on_defend_pressed)
	EventBus.aim_mode_canceled.connect(cancel_aim_mode)
	gesture_timer = Timer.new()
	gesture_timer.one_shot = true
	gesture_timer.wait_time = 0.15
	gesture_timer.timeout.connect(on_timer_finish)
	add_child(gesture_timer)

func on_timer_finish():
	is_gesturing = false
	print("timer finished")

func on_user_input_requested(actor: Char):
	Globals.listening_user_input = true
	self.actor = actor

func cancel_aim_mode():
	is_aiming = false

func camera_handler(event: InputEvent):
	# camera functionality
	if event.is_action_pressed("zoom_in"):
		zoom = zoom + Vector2(1,1)
	elif event.is_action_pressed("zoom_out"):
		zoom = zoom - Vector2(1,1)
	elif event is InputEventMagnifyGesture:
		if !is_gesturing:
			is_gesturing = true
		gesture_timer.start()
		zoom = zoom * event.factor
	elif event.is_action_pressed("primary_click"):
		_previousPosition = event.position
		_mouse_is_pressed = true
	elif event.is_action_released("primary_click"):
		Globals.camera_move_state = false
		_mouse_is_pressed = false
	elif event is InputEventMouseMotion and _mouse_is_pressed:
		if !Globals.camera_move_state:
			# check if position has 
			if event.position.distance_to(_previousPosition) > THRESHOLD:
				Globals.camera_move_state = true
		else:
			position += (_previousPosition - event.position) / zoom
			_previousPosition = event.position

func character_controller(event: InputEvent):
	var turn_passed := false
	Globals.listening_user_input = false
	if event.is_action_pressed("see_all"):
		for actor in ActorManager.get_chars():
			actor.visible = true
		for item in ItemManager.get_all_items():
			item.visible = true
	elif event.is_action_pressed("generate_card_reward"):
		EventBus.card_reward_cheated.emit()
	elif event.is_action_pressed("wait"):
		turn_passed = await WaitAction.new(self.actor).execute()
	elif event.is_action_pressed("swap"):
		self.actor.swap()
	elif event.is_action_pressed("reshuffle"):
		turn_passed = await ReshuffleAction.new(self.actor).execute()
	elif event.is_action_pressed("defend"):
		turn_passed = await DefendAction.new(self.actor).execute()
	elif !mouse_is_blocked() and event.is_released():
		if event.is_action_released("primary_click"):
			var grid_position : Vector2i= floor(get_global_mouse_position() / Consts.TILE_SIZE)
			# restrict input if the target has not yet been explored
			if !is_aiming:
				if self.actor.explored_set.has(grid_position):
					# check if an evil character is in the location
					var target_char_ind := -1
					for i in range(len(self.actor.visible_actors)):
						var ch := self.actor.visible_actors[i]
						if is_instance_valid(ch) and ch.grid_position == grid_position:
							target_char_ind = i
							break
					if target_char_ind != -1:
						var target_char = self.actor.visible_actors[target_char_ind]
						if target_char.alignment != self.actor.alignment:
							turn_passed = await AttackOnlyAction.new(self.actor, target_char).execute()
					else:
						turn_passed = await WalkPath.new(self.actor, grid_position).execute()
			else:
				is_aiming = false
				turn_passed = await UseItemAction.new(actor, stored_item, stored_action, grid_position).execute()
	#elif !mouse_is_blocked() and event.is_action_released("teleport"):
		#print("teleporting")
		#self.actor.move_to(floor(get_global_mouse_position() / Consts.TILE_SIZE), INF)
		#self.actor.update_vision()
	if turn_passed:
		end_turn()
	else:
		Globals.listening_user_input = true

func end_turn():
	Globals.listening_user_input = false
	EventBus.turn_ended.emit()

func _unhandled_input(event: InputEvent):
	if Globals.listening_user_input and !mouse_is_blocked():
		character_controller(event)
	camera_handler(event)

func on_item_used(item: Item, item_action: ItemAction):
	if Globals.listening_user_input:
		if item_action.target == ItemAction.Target.GROUND:
			EventBus.aim_mode_requested.emit(item_action.effect_range)
			is_aiming = true
			stored_action = item_action
			stored_item = item
		else:
			# do the action
			var turn_passed := await UseItemAction.new(actor, item, item_action, actor.grid_position).execute()
			if turn_passed:
				end_turn()

func move_camera_position(grid_position: Vector2i):
	target_pos = Vector2(grid_position.x * Consts.TILE_SIZE, grid_position.y * Consts.TILE_SIZE)
	is_targeting = true

func mouse_is_blocked() -> bool:
	return Globals.camera_move_state or is_gesturing

func on_wait_pressed():
	if Globals.listening_user_input:
		end_turn()

func on_swap_pressed():
	if Globals.listening_user_input:
		self.actor.swap()

func on_reshuffle_pressed():
	if Globals.listening_user_input:
		var turn_passed := await ReshuffleAction.new(self.actor).execute()
		if turn_passed:
			end_turn()

func on_defend_pressed():
	if Globals.listening_user_input:
		var turn_passed := await DefendAction.new(self.actor).execute()
		if turn_passed:
			end_turn()
