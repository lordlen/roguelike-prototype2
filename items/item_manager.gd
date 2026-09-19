extends Node

# array of a list of items
var item_dictionary: Dictionary[Vector2i, Array]

func _ready() -> void:
	EventBus.reset_game_scene.connect(_reset)

func _reset():
	item_dictionary.clear()

func add_item_to_overworld(item: Item, grid_position: Vector2i, price: int = 0):
	var item_overworld_scene : PackedScene= load("res://items/item_overworld.tscn")
	var item_overworld : ItemOverworld = item_overworld_scene.instantiate()#ItemOverworld.new(item, grid_position)
	item_overworld.set_item(item)
	item_overworld.set_pos(grid_position)
	item_overworld.set_price(price)
	if !item_dictionary.has(grid_position):
		item_dictionary[grid_position] = []
	
	item_dictionary[grid_position].push_back(item_overworld)
	
	# add the item to the item list
	EventBus.new_item_added.emit(item_overworld)

func pop_item_from_overworld(grid_position: Vector2i) -> Item:
	if item_in_position(grid_position):
		var item_overworld : ItemOverworld = item_dictionary[grid_position].pop_back()
		var item := item_overworld.item_resource
		item_overworld.queue_free()
		if item_dictionary[grid_position].is_empty():
			item_dictionary.erase(grid_position)
		return item
	return null

func item_in_position(pos: Vector2i) -> bool:
	return item_dictionary.has(pos)

func get_top_item(pos: Vector2i) -> ItemOverworld:
	if !item_in_position(pos):
		return null
	
	var item_list := item_dictionary[pos]
	return item_list[len(item_list) - 1]

func get_all_items():
	var ret := []
	for arr in item_dictionary.values():
		ret += arr
	return ret

func get_items_in_area(positions: Array[Vector2i]) -> Array[ItemOverworld]:
	var ret : Array[ItemOverworld] = []
	for pos in positions:
		if item_in_position(pos):
			ret.append_array(item_dictionary[pos])
	return ret

func clear_items():
	var keys := item_dictionary.keys().duplicate()
	for key in keys:
		var items := item_dictionary[key]
		while !items.is_empty():
			pop_item_from_overworld(key)
