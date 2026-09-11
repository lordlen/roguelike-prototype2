extends Panel

func _ready() -> void:
	EventBus.character_info_requested.connect(_on_character_info_requested)

func _on_character_info_requested(ch: Char):
	set_char(ch)
	get_parent().show()

func set_char(char: Char):
	$CharInfo.set_character(char)
	$CharInfo.update(char)
	$TraversalLabel/TraversalType.text = Char.Traversal.find_key(char.traversal)
	$ScentRangeLabel/ScentRangeValue.text = str(char.scent_range)
	$GoldLabel/GoldAmount.text = str(char.inventory.gold)

	for child in $ItemLabel/GridContainer.get_children():
		remove_child(child)
		child.queue_free()

	for item: Item in char.inventory.items + char.inventory.card_rewards2:
		var texture := item.texture
		var description := item.get_description()

		var item_texture := TextureRect.new()
		item_texture.texture = texture
		item_texture.self_modulate = item.color
		item_texture.tooltip_text = description
		$ItemLabel/GridContainer.add_child(item_texture)

	# loop each relic
	# clear children
	for child in $RelicLabel/GridContainer.get_children():
		child.queue_free()

	for relic in char.inventory.relics:
		var texture := relic.texture
		var description := relic.get_description()
		
		var relic_texture := TextureRect.new()
		relic_texture.texture = texture
		relic_texture.tooltip_text = description
		$RelicLabel/GridContainer.add_child(relic_texture)
