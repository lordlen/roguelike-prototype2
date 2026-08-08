extends Panel

func _ready() -> void:
	EventBus.card_info_requested.connect(set_card)

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton and event.pressed:
		# Check if mouse is outside the panel's global rect area
		if not get_global_rect().has_point(event.global_position):
			hide()

func set_card(card: CardInstance) -> void:
	if card == null:
		return
	$CardName.text = card.card_name
	$Description.text = card.get_description()
	$ItemList.set_item_text(0, str(card.attack))
	$ItemList.set_item_text(1, str(card.num_hits))
	$ItemList.set_item_text(2, str(card.atk_range))
	$ItemList.set_item_text(3, str(card.defense))
	
	# clear the vboxcontainer
	for child in $VBoxContainer.get_children():
			remove_child(child)
			child.queue_free()
	
	# create 1 effect description per unique effect
	var effect_description_scene: PackedScene = load("res://UI/effect_description.tscn")
	var unique_keywords : Dictionary[String, bool] = {}
	for e in card.get_all_effects():
		for effect in e.get_all_nested_card_effects():
			if effect.get_identifier() in unique_keywords or !effect.description:
				continue
			unique_keywords[effect.get_identifier()] = true
			var effect_description: EffectDescription = effect_description_scene.instantiate()
			effect_description.set_text(effect.get_numeric(), effect.get_identifier(), effect.get_description())
			$VBoxContainer.add_child(effect_description)
	visible = true
