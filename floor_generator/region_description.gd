class_name RegionDescription
extends Resource

@export var normal_floors: Array[FloorBuilder]

# shop floors are inserted somewhere
@export var shop_floors: Array[FloorBuilder]
@export var shop_insertions: Array[int]

# floors where the special rooms can spawn.
@export var special_room_floors: Array[int]

var curr_floor := 0
var floor_list: Array[FloorBuilder]

func initalize() -> void:
	curr_floor = 0
	floor_list = normal_floors.duplicate()
	
	var special_room_index : int = special_room_floors.pick_random()
	(floor_list[special_room_index] as StandardFloorBuilder).floor_description.num_special_rooms += 1
	
	# insert shop floor somewhere in the list
	var shop_ind : int = shop_insertions.pick_random()
	var shop_floor_builder : FloorBuilder = shop_floors.pick_random()
	floor_list.insert(shop_ind, shop_floor_builder)

func has_next() -> bool:
	return curr_floor < len(floor_list)

func get_next_floor() -> FloorBuilder:
	var floor := floor_list[curr_floor]
	curr_floor += 1
	return floor
	
