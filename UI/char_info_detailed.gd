extends Panel

func _ready() -> void:
	EventBus.character_info_requested.connect(_on_character_info_requested)

func _on_character_info_requested(ch: Char):
	set_char(ch)
	visible = true

func set_char(char: Char):
	$CharName.text = char.character_name
	$TraversalLabel/TraversalType.text = Char.Traversal.find_key(char.traversal)
	$GoldLabel/GoldAmount.text = str(char.inventory.gold)
	$CardRewardLabel/CardRewardAmount.text = str(char.inventory.card_rewards)
	
	for child in $PotionLabel/GridContainer.get_children():
		remove_child(child)
		child.queue_free()
	
	for potion in char.inventory.items:
		var texture := potion.texture
		var description := potion.get_description()
		
		var potion_texture := TextureRect.new()
		potion_texture.texture = texture
		potion_texture.tooltip_text = description
		$PotionLabel/GridContainer.add_child(potion_texture)

	# loop each relic
	# clear children
	for child in $RelicLabel/GridContainer.get_children():
		remove_child(child)
		child.queue_free()

	for relic in char.inventory.relics:
		var texture := relic.texture
		var description := relic.get_description()
		
		var relic_texture := TextureRect.new()
		relic_texture.texture = texture
		relic_texture.tooltip_text = description
		$RelicLabel/GridContainer.add_child(relic_texture)

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton and event.pressed:
		# Check if mouse is outside the panel's global rect area
		if not get_global_rect().has_point(event.global_position):
			hide()
