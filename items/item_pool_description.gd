class_name ItemPoolDescription
extends ItemGenerator

@export var item_pool: Array[Item]
@export var weights: Array[float]
@export var with_replacement := true

var rng = RandomNumberGenerator.new()

func get_item() -> Item:
	if with_replacement:
		return get_random_item()
	else:
		return get_random_item_no_replacement()

func get_random_item() -> Item:
	var ind = rng.rand_weighted(weights)
	return item_pool[ind].duplicate(true)

func get_random_item_no_replacement() -> Item:
	if len(item_pool) == 0:
		return Item.new()
	var ind = rng.rand_weighted(weights)
	var item = item_pool[ind]
	item_pool.remove_at(ind)
	weights.remove_at(ind)
	return item.duplicate(true)
