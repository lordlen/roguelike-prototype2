extends Panel

func _ready() -> void:
	EventBus.notable_occurance.connect(log_occurance)

func log_occurance(s: String):
	$ScrollContainer/Logs.text = $ScrollContainer/Logs.text + '\n' + s
	$ScrollContainer.set_deferred("scroll_vertical", $ScrollContainer.get_v_scroll_bar().max_value)
