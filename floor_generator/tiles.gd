class_name Tiles

static var TileDictionary : Dictionary[RoomPattern.TileType, Tile] = {
	RoomPattern.TileType.UNOCCUPIED: Wall.new(),
	RoomPattern.TileType.FLOOR: Ground.new(),
	RoomPattern.TileType.WALL: Wall.new(),
	RoomPattern.TileType.GRASS: Grass.new(),
	RoomPattern.TileType.WATER: Water.new(),
	RoomPattern.TileType.PEDESTAL: Ground.new(),
}

class Tile:
	static func on_walk(actor: Char) -> void:
		pass
		
	static func is_impassable() -> bool:
		return false

	static func is_opaque() -> bool:
		return false

class Wall extends Tile:
	static func on_walk(actor: Char) -> void:
		pass
		
	static func is_impassable() -> bool:
		return true

	static func is_opaque() -> bool:
		return true

class Ground extends Tile:
	static func on_walk(actor: Char) -> void:
		pass
		
	static func is_impassable() -> bool:
		return false

	static func is_opaque() -> bool:
		return false

class Grass extends Tile:
	static func on_walk(actor: Char) -> void:
		pass
		
	static func is_impassable() -> bool:
		return false

	static func is_opaque() -> bool:
		return true

class Water extends Tile:
	static func on_walk(actor: Char) -> void:
		# TODO: discard actor's cards
		pass
		
	static func is_impassable() -> bool:
		return false

	static func is_opaque() -> bool:
		return false
