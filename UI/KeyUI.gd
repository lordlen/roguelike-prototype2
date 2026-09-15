extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.inventory_updated.connect(update_key)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_key(owner: Char) -> void:
	if owner.user_controlled:
		if owner.inventory.keys > 0:
			show()
		else:
			hide()
