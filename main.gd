extends Node

func _ready() -> void:
	randomize()
	EventBus.character_fov_updated.connect(_update_fog)
	EventBus.new_actor_added.connect(on_new_actor_added)
	EventBus.new_item_added.connect(on_new_item_added)
	
	var hero := Char.new(load(Char.stats_resources["hero"]), Vector2i(0,0))
	var card_list : Array[CardInstance] = []
	for card_resource in hero.deck.deck_list:
		var card_instance := CardInstance.new(card_resource)
		card_list.push_back(card_instance)
	build_floor()

func build_floor():
	var floor_builder := FloorBuilder.new()
	floor_builder.build_floor(Globals.current_floor)
	
	$Terrain.draw_tiles(Globals.floor_map.get_all_tiles())
	Globals.current_floor += 1
	
	# reset hero vision
	for char in Globals.user_controlled:
		char.vision_set.clear()
		char.explored_set.clear()
		char.visible_actors.clear()
		char.update_vision()
		char.deck.initialize()
	
func on_stairs_entered():
	$UILayer/CardRewardDialog.generate_card_rewards()
	build_floor()
	$UILayer/TopPanel/FloorNumber.text = "F%d" % Globals.current_floor

func on_new_actor_added(char: Char):
	$ActorList.add_child(char)

func on_new_item_added(item: ItemOverworld):
	$ItemList.add_child(item)

func _update_fog(char: Char):
	if char.is_user_controlled():
		# update the fog
		$Terrain/GrayFog.clear()
		$Terrain/BlackFog.clear()
		# look at the hero
		for y in range(Globals.floor_map.height):
			for x in range(Globals.floor_map.width):
				if !char.vision_set.has(Vector2i(x,y)):
					$Terrain/GrayFog.set_cell(Vector2i(x,y),0, Vector2i(0,4))
				if !char.explored_set.has(Vector2i(x,y)):
					$Terrain/BlackFog.set_cell(Vector2i(x,y),0, Vector2i(0,4))
		


func _on_button_pressed() -> void:
	pass # Replace with function body.
