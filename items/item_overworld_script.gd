class_name ItemOverworld
extends Area2D

var item_resource: Item
var price := 0

func set_item(item: Item):
	item_resource = item
	$ItemSprite.texture = item.texture
	$ItemSprite.self_modulate = item.color
	if item.texture == null:
		$AltText.text = item.item_name

func set_pos(grid_position: Vector2i):
	position = Vector2(grid_position.x * Consts.TILE_SIZE, grid_position.y * Consts.TILE_SIZE)

func set_price(price: int):
	self.price = price
	if price == 0:
		$Cost.text = ""
	else:
		$Cost.text = str(price)

func _mouse_enter() -> void:
	if item_resource.display_description_on_hover:
		EventBus.item_description_requested.emit(item_resource.get_description())

func _mouse_exit() -> void:
	EventBus.item_description_hidden.emit()

func _exit_tree() -> void:
	EventBus.item_description_hidden.emit()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if !item_resource.display_description_on_hover:
				EventBus.item_description_requested.emit(item_resource.get_description())
