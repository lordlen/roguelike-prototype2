extends TextureRect

var relic: Relic

func set_relic(relic: Relic):
	texture = relic.texture
	$PanelContainer/Description.text = relic.get_description()
	$PanelContainer.hide()
	self.relic = relic
	relic.number_updated.connect(_on_relic_value_updated)
	_on_relic_value_updated()
	
func _on_relic_value_updated():
	$Number.text = relic.get_string_value()

func _on_mouse_entered() -> void:
	$PanelContainer.show()

func _on_mouse_exited() -> void:
	$PanelContainer.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("primary_click"):
		$PanelContainer.visible = !$PanelContainer.visible
