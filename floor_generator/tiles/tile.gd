class_name TileResource
extends Resource

# terrain id should be what identifies terrain
@export var terrain_id: Terrains

@export var top_id: Tops
@export var bottom_id: Bottoms
@export var is_opaque: bool
@export var grounded_cost: float
@export var aquatic_cost: float
@export var flying_cost: float
@export var hidden_char: CharacterStats
@export var on_walk_action: ItemAction = ItemAction.new()

enum Terrains {
	GROUND = 0,
	WALL = 1,
	GRASS = 2,
	WATER = 3,
	PEDESTAL = 4,
	TRAMPLED_GRASS = 5,
	STAIRS = 6,
	LOCKED_DOOR = 7,
	STATUE = 8,
	SANCTUARY = 9,
}

enum Tops {
	NOTHING = 0,
	WALL = 1,
	GRASS = 2,
	PEDESTAL = 3,
	TRAMLED_GRASS = 4,
	LOCKED_DOOR = 5,
	STATUE = 6
}

enum Bottoms {
	SOIL = 0,
	GRASS = 1,
	WATER = 2,
	STAIRS = 3
}

# return the grounded cost by default
func get_pf_cost(traversal: Char.Traversal) -> float:
	match traversal:
		Char.Traversal.GROUNDED:
			return grounded_cost
		Char.Traversal.AQUATIC:
			return aquatic_cost
		Char.Traversal.FLYING:
			return flying_cost
		_:
			return grounded_cost

func on_walk(actor: Char) -> void:
	if on_walk_action == null:
		return

	on_walk_action.use(actor, actor.grid_position)
