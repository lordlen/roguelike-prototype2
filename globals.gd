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
