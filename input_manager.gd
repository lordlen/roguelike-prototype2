extends Camera2D
class_name MainCamera

var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;
var _mouse_is_pressed: bool = false;
var THRESHOLD: int = 8;

var listening_user_input: bool = false
var actor: Char

func _ready() -> void:
	EventBus.user_input_requested.connect(on_user_input_requested)

func on_user_input_requested(actor: Char):
	listening_user_input = true
	self.actor = actor
	
func camera_handler(event: InputEvent):
	# camera functionality
	if event.is_action_pressed("zoom_in"):
		zoom = zoom + Vector2(1,1)
	elif event.is_action_pressed("zoom_out"):
		zoom = zoom - Vector2(1,1)
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

	if event.is_action_pressed("wait"):
		turn_passed = true
	elif event.is_action_pressed("swap"):
		self.actor.swap()
	elif event.is_action_pressed("reshuffle"):
		turn_passed = ReshuffleAction.new(self.actor).execute()
	elif event.is_action_pressed("defend"):
		turn_passed = DefendAction.new(self.actor).execute()
	elif !Globals.camera_move_state and event.is_action_released("primary_click"):
		var grid_position : Vector2i= floor(get_global_mouse_position() / Consts.TILE_SIZE)
		# restrict input if the target has not yet been explored
		if self.actor.explored_set.has(grid_position):
			# check if an evil character is in the location
			var target_char_ind := self.actor.visible_actors.find_custom(func(ch: Char): return ch.grid_position == grid_position)
			if target_char_ind != -1:
				var target_char = self.actor.visible_actors[target_char_ind]
				if target_char.alignment != self.actor.alignment:
					turn_passed = AttackAction.new(self.actor, target_char).execute()
			else:
				turn_passed = WalkPath.new(self.actor, grid_position).execute()
	if turn_passed:
		listening_user_input = false
		EventBus.emit_signal("turn_ended")

func _unhandled_input(event: InputEvent):
	if listening_user_input and !Globals.camera_move_state:
		character_controller(event)
	camera_handler(event)
