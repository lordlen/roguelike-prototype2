extends TextureRect

var relic: Relic

func set_relic(relic: Relic):
	texture = relic.texture
	tooltip_text = relic.get_description()
	self.relic = relic
	relic.number_updated.connect(_on_relic_value_updated)
	_on_relic_value_updated()
	
func _on_relic_value_updated():
	$Label.text = relic.get_string_value()
