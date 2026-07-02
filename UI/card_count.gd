extends Label


func _ready() -> void:
	EventBus.inventory_updated.connect(_update_card_counter)

func _update_card_counter(ch: Char):
	if ch.user_controlled:
		var inventory := ch.inventory
		var card_count := inventory.card_rewards
		self.text = str(card_count)
