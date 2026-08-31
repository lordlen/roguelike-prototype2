extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.character_deck_updated.connect(_on_defense_update)


func _on_defense_update(ch: Char):
	if ch.user_controlled:
		var offhand := ch.deck.offhand
		if offhand != null:
			text = str(offhand.get_block_defense())
		else:
			text = ""
			
