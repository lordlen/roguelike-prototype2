extends Node

@export var region_descriptions : Array[RegionDescription]

var region_ind := 0
var floor_name: String

func _ready() -> void:
	randomize()
	EventBus.character_fov_updated.connect(_update_fog)
	EventBus.new_actor_added.connect(on_new_actor_added)
	EventBus.new_item_added.connect(on_new_item_added)
	
	var hero := ActorManager.spawn_character(load("res://char/stats/hero.tres"))
	$UILayer/HeroInfo.set_character(hero)
	$UILayer/RelicBar.set_char(hero)
	for region in region_descriptions:
		region.initalize()
	build_floor()

func build_floor():
	if !region_descriptions[region_ind].has_next():
		region_ind += 1
	if region_ind >= len(region_descriptions):
		print("win")
		return
	var floor_builder := region_descriptions[region_ind].get_next_floor()
	floor_builder.build_floor()
	
	$Terrain.draw_tiles(Globals.floor_map.get_all_tiles())
	
	$UILayer/TopPanel/FloorNumber.text = floor_builder.floor_name
	
	# reset hero vision
	for char in Globals.user_controlled:
		char.vision_set.clear()
		char.explored_set.clear()
		char.visible_actors.clear()
		char.update_vision()
		char.deck.initialize()
	
func on_stairs_entered():
	$UILayer/CardRewardDialog/CardRewardDialog.claim_card_rewards()
	build_floor()
	# activate on next floor effects
	for chars in ActorManager.get_chars():
		chars.char_next_floor.emit()
	$UILayer/TargetInfo.hide()

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
