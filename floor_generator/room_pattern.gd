class_name RoomPattern

static var TILE_TYPE_MAP := {
	Color.BLACK: load("res://floor_generator/tiles/wall.tres"),
	Color.WHITE: load("res://floor_generator/tiles/ground.tres"),
	Color.GREEN: load("res://floor_generator/tiles/grass.tres"),
	Color.BLUE: load("res://floor_generator/tiles/water.tres"),
	Color.YELLOW: load("res://floor_generator/tiles/pedestal.tres"),
	Color8(255, 255, 0, 254): load("res://floor_generator/tiles/pressure_p_statue.tres"),
	Color.MAGENTA: load("res://floor_generator/tiles/stairs.tres"),
	Color.RED: load("res://floor_generator/tiles/locked_door.tres"),
	Color.CYAN: load("res://floor_generator/tiles/goblin_statue.tres"),
	Color8(0,255,255,254): load("res://floor_generator/tiles/slime_statue.tres"),
	Color8(0,255,255,253): load("res://floor_generator/tiles/rat_statue.tres"),
}

static var ITEM_TYPE_MAP := {
	Color.BLACK: load("res://items/descriptions/default_card_pool.tres"),
	Color.WHITE: load("res://items/descriptions/default_item_pool.tres"),
	Color.YELLOW: load("res://items/descriptions/default_relic_pool.tres"),
	Color.BLUE: load("res://items/descriptions/default_money_pool.tres"),
	Color.GREEN: load("res://items/descriptions/healing_tile.tres")
}

var used_cells: Array[Vector2i]
var used_cells_types: Array[TileResource]
var item_generators: Array[ItemGenerator]
var item_cells: Array[Vector2i]

func _init(pattern_image: PatternResource):
	var image: Image = pattern_image.pattern.get_image()
	var image_items: Image
	if pattern_image.item_pattern:
		image_items = pattern_image.item_pattern.get_image()
	var uc : Array[Vector2i] = []
	var ic : Array[Vector2i] = []
	var entrance := Vector2i(-1,-1)
	for x in range(32):
		for y in range(32):
			# tiles
			var color_tiles := image.get_pixel(x, y)
			if color_tiles in TILE_TYPE_MAP:
				var v := Vector2i(x,y)
				if v.x == 0:
					entrance = v
				uc.push_back(v)
				used_cells_types.push_back(TILE_TYPE_MAP[color_tiles])
			# items
			if image_items:
				var color_items := image_items.get_pixel(x, y)
				if color_items in ITEM_TYPE_MAP:
					var v := Vector2i(x,y)
					ic.push_back(v)
					item_generators.push_back(ITEM_TYPE_MAP[color_items])
	# offset the cell such that the 'entrance' is at 0,0
	for cell in uc:
		used_cells.push_back(cell - entrance)
	for cell in ic:
		item_cells.push_back(cell - entrance)

func rotate90(v: Vector2i):
	return Vector2i(-v.y, v.x)

func rotate180(v: Vector2i):
	return -v

func rotate270(v: Vector2i):
	return Vector2i(v.y, -v.x)

func rotate(v: Vector2i, direction: Vector2i):
	match direction:
		Vector2i.DOWN:
			return rotate90(v)
		Vector2i.LEFT:
			return rotate180(v)
		Vector2i.UP:
			return rotate270(v)
		_:
			return v

# rotates along the 0,0, then moves the entrance to the translation
func get_used_cells(rotation: Vector2i, translation: Vector2i) -> Array[Vector2i]:
	var ret: Array[Vector2i] = []
	ret.assign(used_cells.map(func(v: Vector2i) -> Vector2i: return rotate(v, rotation) + translation))
	return ret

func generate_items() -> Array[Item]:
	var items : Array[Item] = []
	for generator in item_generators:
		items.push_back(generator.get_item())
	return items

func get_item_cells(rotation: Vector2i, translation: Vector2i) -> Array[Vector2i]:
	var ret: Array[Vector2i] = []
	ret.assign(item_cells.map(func(v: Vector2i) -> Vector2i: return rotate(v, rotation) + translation))
	return ret

func get_cell_types() -> Array[TileResource]:
	return used_cells_types
