class_name CardDisplay
extends TextureButton

var card: CardInstance
signal card_icon_pressed

func set_color_by_rarity(rarity: CardResource.Rarity):
	match rarity:
		CardResource.Rarity.UNCOMMON:
			self_modulate = Color.DEEP_SKY_BLUE
		CardResource.Rarity.RARE:
			self_modulate = Color.YELLOW
		_:
			self_modulate = Color.WHITE

func set_card_data(card: CardInstance) -> void:
	self.card = card
	if card != null:
		set_color_by_rarity(card.rarity)
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
	if event.is_released():
		if event.is_action_released("secondary_click")\
		or (Globals.is_examining and event.is_action_released("primary_click")):
			EventBus.card_info_requested.emit(card)
		elif event.is_action_released("primary_click"):
			card_icon_pressed.emit(get_index())
