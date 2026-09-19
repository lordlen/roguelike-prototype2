extends Node

var floor_map: Floor
var current_floor: int = 0

var visible_actors: Array[Char] = []
var actors: Array[Char] = []
var user_controlled: Array[Char] = []
var ai_controlled: Array[Char] = []

var camera_move_state := false

var listening_user_input := false
var is_examining := false

func _ready() -> void:
	EventBus.reset_game_scene.connect(_reset)

func _reset():
	floor_map = null
	current_floor = 0
	visible_actors.clear()
	actors.clear()
	user_controlled.clear()
	ai_controlled.clear()
	camera_move_state = false
	listening_user_input = false
	is_examining = false
