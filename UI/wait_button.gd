extends TextureButton



func _on_pressed() -> void:
	EventBus.wait_button_pressed.emit()
	
