class_name ItemPoolDescription
extends Resource

@export var item_pool: Array[Item]
@export var weights: Array[float]

var rng = RandomNumberGenerator.new()

func get_random_item() -> Item:
	var ind = rng.rand_weighted(weights)
	return item_pool[ind]
