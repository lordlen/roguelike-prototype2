extends Button

func _on_button_up() -> void:
	Globals.is_examining = !Globals.is_examining
	if Globals.is_examining:
		text = "cancel"
	else:
		text = "examine"
