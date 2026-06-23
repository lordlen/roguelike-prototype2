class_name SpawnDescription
extends Resource

@export var pool : Array[SpawnGroup]
@export var weights: Array[float]

var rng = RandomNumberGenerator.new()

func get_random_spawn_group() -> SpawnGroup:
	var ind = rng.rand_weighted(weights)
	return pool[ind]
