class_name CardIcon
extends TextureButton

var card: CardInstance
signal card_icon_pressed

func _on_mouse_entered() -> void:
	$PanelContainer.visible = true

func _on_mouse_exited() -> void:
	$PanelContainer.visible = false

func set_card_data(card: CardInstance) -> void:
	self.card = card
	if card != null:
		self.texture_normal = card.texture
		self.modulate.a = 1
		$AttackValue.text = card.get_attack()
		$DefenseValue.text = card.get_defense_string()
		$PanelContainer/Description.text = card.get_description()
	else:
		self.modulate.a = 0
		$AttackValue.text = ""
		$DefenseValue.text = ""
		$PanelContainer/Description.text = ""

func _on_toggled(is_toggled: bool) -> void:
	if is_toggled:
		scale = Vector2(1.15, 1.15)
	else:
		scale = Vector2(1.0, 1.0)

func _on_card_icon_pressed():
	card_icon_pressed.emit(get_index())
