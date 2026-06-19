extends Panel

var card_icon_scene: PackedScene = load("res://UI/card_icon.tscn")

func set_card_list(cards: Array[CardInstance], is_sorted: bool):
	# remove all children
	for n in $ScrollContainer/GridContainer.get_children():
		$ScrollContainer/GridContainer.remove_child(n)
		n.queue_free()
	
	# first sort the cards to 
	if is_sorted:
		cards.sort_custom(\
			func(c1: CardInstance, c2: CardInstance): return c1.card_name < c2. card_name)
	
	for card in cards:
		# create a card icon
		var card_icon: CardIcon = card_icon_scene.instantiate()
		card_icon.set_card_data(card)
		
		$ScrollContainer/GridContainer.add_child(card_icon)
