class_name SanctuaryAction
extends ItemAction

func get_description() -> String:
	return "Create a 3x3 sanctuary."

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false
	
	var target_chars := _get_target_chars(owner, pos)
	if target_chars.is_empty():
		return false
	
	var sanc_tile : TileResource = load("res://floor_generator/tiles/sanctuary.tres")
	var valid_tiles : Array[TileResource.Terrains] = [
		TileResource.Terrains.GROUND,
		TileResource.Terrains.WATER,
		TileResource.Terrains.GRASS,
		TileResource.Terrains.TRAMPLED_GRASS,
	]
	var ground := load("res://floor_generator/tiles/ground.tres")
	for target_char in target_chars:
		CardHelper.push_aoe(target_char.grid_position, target_char.alignment, 1, 1)
		CardHelper.generate_terrain(target_char.grid_position, sanc_tile, valid_tiles, 9, effect_radius)
		CardHelper.generate_terrain(target_char.grid_position, ground, [TileResource.Terrains.SANCTUARY], 1, 0)
	return true
