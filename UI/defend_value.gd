extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.character_deck_updated.connect(_on_defense_update)


func _on_defense_update(ch: Char):
	if ch.user_controlled:
		var offhand := ch.deck.offhand
		if offhand != null:
			var bonus_def := (offhand.defense_decay + offhand.defense) / 2
			var curr_def := offhand.defense - offhand.defense_decay
			text = str(curr_def + bonus_def)
		else:
			text = ""
			
