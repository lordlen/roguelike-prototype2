extends Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.aim_mode_canceled.connect(hide)
	EventBus.aim_mode_requested.connect(_on_aim_mode_requested)

func _on_button_button_up() -> void:
	EventBus.aim_mode_canceled.emit()

func _on_aim_mode_requested(effect_range: int) -> void:
	show()
	$Label.text = "Select a cell within %d tiles" % effect_range
