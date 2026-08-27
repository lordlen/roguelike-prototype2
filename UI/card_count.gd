extends Label


func _ready() -> void:
	EventBus.inventory_updated.connect(_update_card_counter)

func _update_card_counter(ch: Char):
	if ch.user_controlled:
		var inventory := ch.inventory
		var card_count := inventory.card_rewards
		self.text = str(card_count)

extends GridContainer

var potion_icon: PackedScene = load("res://UI/potion_icon.tscn")

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
		for item in inventory.items:
			var new_icon : PotionIcon = potion_icon.instantiate()
			new_icon.set_actor(ch)
			new_icon.set_item(item)
			self.add_child(new_icon)
