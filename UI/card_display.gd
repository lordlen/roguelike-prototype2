class_name CardDisplay
extends TextureButton

var card: CardInstance
signal card_icon_pressed

func set_card_data(card: CardInstance) -> void:
	self.card = card
	if card != null:
		if card.texture != null:
			$CardThumbnail.texture = card.texture
			$AltText.text = ""
		else:
			$CardThumbnail.texture = null
			$AltText.text = card.card_name
		self.modulate.a = 1
		$AttackLabel.text = card.get_attack()
		$DefenseLabel.text = card.get_defense_string()
	else:
		self.modulate.a = 0
		$AttackLabel.text = ""
		$DefenseLabel.text = ""

func _on_toggled(is_toggled: bool) -> void:
	if is_toggled:
		scale = Vector2(1.15, 1.15)
	else:
		scale = Vector2(1.0, 1.0)

func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			card_icon_pressed.emit(get_index())
		if event.button_index == MOUSE_BUTTON_RIGHT:
			EventBus.card_info_requested.emit(card)
