class_name CardIcon
extends TextureRect

func _on_mouse_entered() -> void:
	$PanelContainer.visible = true

func _on_mouse_exited() -> void:
	$PanelContainer.visible = false

func set_card_data(card: CardInstance) -> void:
	if card != null:
		self.texture = card.texture
		self.modulate.a = 1
		$AttackValue.text = card.get_attack()
		$DefenseValue.text = card.get_defense()
		$PanelContainer/Description.text = card.get_description()
	else:
		self.modulate.a = 0
		$AttackValue.text = ""
		$DefenseValue.text = ""
		$PanelContainer/Description.text = ""
