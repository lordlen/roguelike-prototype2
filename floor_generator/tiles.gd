class_name Tiles

static var TileDictionary : Dictionary[RoomPattern.TileType, Tile] = {
	RoomPattern.TileType.UNOCCUPIED: Wall.new(),
	RoomPattern.TileType.FLOOR: Ground.new(),
	RoomPattern.TileType.WALL: Wall.new(),
	RoomPattern.TileType.GRASS: Grass.new(),
	RoomPattern.TileType.WATER: Water.new(),
	RoomPattern.TileType.PEDESTAL: Ground.new(),
	RoomPattern.TileType.TRAMPLED_GRASS: Ground.new(),
	RoomPattern.TileType.STAIRS: Ground.new()
}

static func get_pf_cost(traversal: Char.Traversal, tile_type: RoomPattern.TileType) -> float:
	return TileDictionary[tile_type].pf_cost(traversal)

class Tile:
	static func on_walk(actor: Char) -> void:
		pass
		
	static func is_impassable() -> bool:
		return false

	static func is_opaque() -> bool:
		return false
	
	static func pf_cost(traversal: Char.Traversal) -> float:
		return INF

class Wall extends Tile:
	static func on_walk(actor: Char) -> void:
		pass
		
	static func is_impassable() -> bool:
		return true

	static func is_opaque() -> bool:
		return true

	static func pf_cost(traversal: Char.Traversal) -> float:
		return INF

class Ground extends Tile:
	static func on_walk(actor: Char) -> void:
		pass
		
	static func is_impassable() -> bool:
		return false

	static func is_opaque() -> bool:
		return false
	
	static func pf_cost(traversal: Char.Traversal) -> float:
		if traversal == Char.Traversal.AQUATIC:
			return INF
		return 1.0

class Grass extends Tile:
	static func on_walk(actor: Char) -> void:
		pass
		
	static func is_impassable() -> bool:
		return false

	static func is_opaque() -> bool:
		return true
	
	static func pf_cost(traversal: Char.Traversal) -> float:
		if traversal == Char.Traversal.AQUATIC:
			return INF
		return 1.0

class Water extends Tile:
	static func on_walk(actor: Char) -> void:
		# TODO: discard actor's cards
		pass
		
	static func is_impassable() -> bool:
		return false

	static func is_opaque() -> bool:
		return false
	
	static func pf_cost(traversal: Char.Traversal) -> float:
		if traversal == Char.Traversal.GROUNDED:
			return 2.0
		return 1.0
