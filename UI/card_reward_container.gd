extends GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.inventory_updated.connect(_update_inventory_ui)

func _update_inventory_ui(ch: Char):
	# for now, cannot support multiple characters.
	if ch.user_controlled:
		for child in get_children():
			remove_child(child)
			child.queue_free()
		var inventory := ch.inventory
		for item in inventory.card_rewards2:
			var new_icon:= TextureRect.new()
			new_icon.texture = item.texture
			new_icon.self_modulate = item.color
			self.add_child(new_icon)
