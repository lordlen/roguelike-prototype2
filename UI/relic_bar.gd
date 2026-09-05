extends Panel

var character: Char
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect to the hero
	EventBus.inventory_updated.connect(_on_inventory_updated)

func set_char(ch: Char):
	character = ch
	_on_inventory_updated(ch)

func _on_inventory_updated(ch: Char):
	if ch != character:
		return

	for child in $HBoxContainer.get_children():
		$HBoxContainer.remove_child(child)
		child.queue_free()
	var relic_item_scene: PackedScene = load("res://UI/relic_bar_item.tscn")
	for relic in character.inventory.relics:
		var relic_item = relic_item_scene.instantiate()
		relic_item.set_relic(relic)
		$HBoxContainer.add_child(relic_item)
