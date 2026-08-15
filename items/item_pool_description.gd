class_name ItemPoolDescription
extends Resource

@export var item_pool: Array[Item]
@export var weights: Array[float]

var rng = RandomNumberGenerator.new()

func get_random_item() -> Item:
	var ind = rng.rand_weighted(weights)
	return item_pool[ind]

func get_random_item_no_replacement() -> Item:
	if len(item_pool) == 0:
		return Relic.new()
	var ind = rng.rand_weighted(weights)
	var item = item_pool[ind]
	item_pool.remove_at(ind)
	weights.remove_at(ind)
	return item
