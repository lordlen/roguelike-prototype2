class_name RoomPattern

enum TileType {
	UNOCCUPIED,
	FLOOR,
	WALL,
	GRASS,
	WATER,
	PEDESTAL,
	TRAMPLED_GRASS,
	STAIRS
}

const TILE_TYPE_MAP := {
	Color.BLACK: TileType.WALL,
	Color.WHITE: TileType.FLOOR,
	Color.GREEN: TileType.GRASS,
	Color.BLUE: TileType.WATER,
	Color.YELLOW: TileType.PEDESTAL,
	Color.MAGENTA: TileType.STAIRS
}

const room_outline_resource := {
	checker_grass = "res://patterns/checker_grass.tres",
	croissant = "res://patterns/croissant.tres",
	diamond = "res://patterns/diamond.tres",
	hut = "res://patterns/hut.tres",
	L = "res://patterns/L.tres",
	lake = "res://patterns/lake.tres",
	long_corridor = "res://patterns/long_corridor.tres",
	pillar = "res://patterns/pillar.tres",
	river = "res://patterns/river.tres",
	small_stairs = "res://patterns/stairs.tres"
}

const feature_resource := {
	island = "res://patterns/room_patterns/special_features/island_treasure.tres",
	vault = "res://patterns/room_patterns/special_features/vault.tres"
}

var used_cells: Array[Vector2i]
var used_cells_types: Array[TileType]
func _init(pattern_image: PatternResource):
	var image: Image = pattern_image.pattern.get_image()
	var uc : Array[Vector2i] = []
	var entrance := Vector2i(-1,-1)
	for x in range(32):
		for y in range(32):
			var color := image.get_pixel(x, y)
			if color in TILE_TYPE_MAP:
				var v := Vector2i(x,y)
				if v.x == 0:
					entrance = v
				uc.push_back(v)
				used_cells_types.push_back(TILE_TYPE_MAP[color])
	# offset the cell such that the 'entrance' is at 0,0
	for cell in uc:
		used_cells.push_back(cell - entrance)

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

func get_cell_types():
	return used_cells_types
