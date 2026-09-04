extends Panel

var effect_description_scene: PackedScene = load("res://UI/effect_description.tscn")

func _ready() -> void:
	EventBus.card_info_requested.connect(set_card)

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

	var unique_keywords : Dictionary[String, bool] = {}
	
	if card.exhausts:
		add_effect_desc(CardDescriptionHelper.orange_text("exhaust"),
		"Remove from the deck when used.")
	if card.is_innate:
		add_effect_desc(CardDescriptionHelper.orange_text("Innate"),
		"Always starts in the hand when reshuffling the deck.")
	if card.is_instant:
		add_effect_desc(CardDescriptionHelper.orange_text("instant"),
		"Attacking with this card will not use your turn.")
	if card.is_lob:
		add_effect_desc(CardDescriptionHelper.orange_text("lob"),
		"Ignore obstructions when attacking an enemy.")
	for e in card.get_all_effects():
		for effect in e.get_all_nested_card_effects():
			if effect.get_identifier() in unique_keywords or !effect.get_description():
				continue
			unique_keywords[effect.get_identifier()] = true
			add_effect_desc(effect.get_shortform_desc(), effect.get_description())
	
	get_parent().show()

func add_effect_desc(title: String, desc: String):
	var effect_description: EffectDescription = effect_description_scene.instantiate()
	effect_description.set_text(title, desc)
	$VBoxContainer.add_child(effect_description)
