class_name PopupControl
extends ColorRect

func _gui_input(event: InputEvent) -> void:
	if event.is_action_released("primary_click") or event.is_action_released("secondary_click"):
		hide()
