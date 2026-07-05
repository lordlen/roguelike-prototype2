extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_wait_button_pressed() -> void:
	EventBus.wait_button_pressed.emit()

func _on_swap_button_pressed() -> void:
	EventBus.swap_button_pressed.emit()

func _on_reshuffle_button_pressed() -> void:
	EventBus.reshuffle_button_pressed.emit()

func _on_defend_button_pressed() -> void:
	EventBus.defend_button_pressed.emit()
