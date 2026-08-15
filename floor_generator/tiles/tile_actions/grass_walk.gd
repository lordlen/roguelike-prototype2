class_name GrassWalk
extends ItemAction

func use(owner: Char, pos: Vector2i) -> bool:
	if owner.traversal == Char.Traversal.FLYING:
		return true
	
	var trampled_grass := load("res://floor_generator/tiles/trampled_grass.tres")
	# change tile to trampled grass.
	Globals.floor_map.update_tile(pos, trampled_grass)
	return true
