extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.update_gold.connect(on_gold_updated)

func on_gold_updated(owner: Char):
	if owner.user_controlled:
		var amount = owner.inventory.gold
		text = "%d" % amount
