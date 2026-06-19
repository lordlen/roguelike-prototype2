extends Node

var floor_map: Floor

var visible_actors: Array[Char] = []
var actors: Array[Char] = []
var user_controlled: Array[Char] = []
var ai_controlled: Array[Char] = []

var camera_move_state := false
