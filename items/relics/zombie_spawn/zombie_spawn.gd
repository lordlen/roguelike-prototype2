class_name ZombieSpawn
extends Relic

var num_tracker := 0
var turns_to_spawn := 20
var zombie := load("res://char/stats/zombie.tres")

func get_string_value() -> String:
	return str(num_tracker)

func on_wait(owner: Char):
	num_tracker += 1
	if num_tracker >= turns_to_spawn:
		num_tracker = 0
		var summon := Summon.new()
		summon.num_summons = 1
		summon.char_resource = load("res://char/stats/zombie.tres")
		summon.do(owner, owner.grid_position, null)
