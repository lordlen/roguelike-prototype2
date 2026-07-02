extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.inventory_updated.connect(_update_card_count)

func _update_card_count(owner: Char):
	if owner.user_controlled:
		var card_count := owner.inventory.card_rewards
		text = str(card_count)
