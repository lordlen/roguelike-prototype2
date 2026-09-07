extends Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.aim_mode_canceled.connect(hide)
	EventBus.aim_mode_requested.connect(show)

func _on_button_button_up() -> void:
	EventBus.aim_mode_canceled.emit()
