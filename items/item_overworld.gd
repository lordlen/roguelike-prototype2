class_name ItemOverworld
extends Sprite2D

var item_resource: Item

func _init(item: Item, grid_position: Vector2i) -> void:
	centered = false
	visible = false
	texture = item.texture
	position = Vector2(grid_position.x * Consts.TILE_SIZE, grid_position.y * Consts.TILE_SIZE)
	item_resource = item
