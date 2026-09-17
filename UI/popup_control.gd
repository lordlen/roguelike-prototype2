class_name PopupControl
extends ColorRect

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_click") or event.is_action_pressed("secondary_click"):
		hide()
