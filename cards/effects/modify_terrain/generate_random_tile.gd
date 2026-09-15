class_name GenerateRandomTile
extends CardEffect

@export var num_gen: int = 1
@export var radius: int = 1
@export var target: Target = Target.SELF

@export_group("Fixed")
@export var tile_type: TileResource
@export var valid_tile_types: Array[TileResource.Terrains]

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var t := actor.grid_position if target == Target.SELF else target_pos
	CardHelper.generate_terrain(t, tile_type, valid_tile_types, num_gen, radius)
	card_effect_finished.emit()
