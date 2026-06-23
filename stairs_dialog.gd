extends ConfirmationDialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.stairs_popup_signal.connect(unhide)

func unhide():
	visible = true
