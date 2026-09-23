extends Node

@export var region_descriptions : Array[RegionDescription]

@onready var terrain := $Terrain
@onready var terrain_bottom := $TerrainBottom
@onready var black_fog := $Terrain/BlackFog
@onready var gray_fog := $Terrain/GrayFog
@onready var actor_list := $ActorList
@onready var item_list := $ItemList
@onready var hero_info := $UILayer/HeroInfo
@onready var target_info := $UILayer/TargetInfo
@onready var relic_bar := $UILayer/RelicBar
@onready var floor_number := $UILayer/TopPanel/FloorNumber
@onready var card_reward_dialog := $UILayer/CardRewardDialog/CardRewardDialog

var region_ind := 0
var floor_name: String

func _ready() -> void:
	randomize()
	EventBus.character_fov_updated.connect(_update_fog)
	EventBus.new_actor_added.connect(on_new_actor_added)
	EventBus.new_item_added.connect(on_new_item_added)
	
	var hero := ActorManager.spawn_character(load("res://char/stats/hero.tres"))
	hero_info.set_character(hero)
	relic_bar.set_char(hero)
	for region in region_descriptions:
		region.initalize()
	build_floor()

func build_floor():
	if !region_descriptions[region_ind].has_next():
		region_ind += 1
	if region_ind >= len(region_descriptions):
		EventBus.reset_game_scene.emit()
		get_tree().change_scene_to_file("res://death_screen/WinScreen.tscn")
		return
	var floor_builder := region_descriptions[region_ind].get_next_floor()
	floor_builder.build_floor()
	
	terrain.draw_tiles(Globals.floor_map.get_all_tiles())
	
	floor_number.text = floor_builder.floor_name
	
	# reset hero vision
	for char in Globals.user_controlled:
		char.vision_set.clear()
		char.explored_set.clear()
		char.visible_actors.clear()
		char.update_vision()
		char.deck.initialize()
	
func on_stairs_entered():
	card_reward_dialog.claim_card_rewards()
	build_floor()
	# activate on next floor effects
	for chars in ActorManager.get_chars():
		chars.char_next_floor.emit()
	target_info.hide()

func on_new_actor_added(char: Char):
	actor_list.add_child(char)

func on_new_item_added(item: ItemOverworld):
	item_list.add_child(item)

func _update_fog(char: Char):
	if char.is_user_controlled():
		# update the fog
		gray_fog.clear()
		black_fog.clear()
		# look at the hero
		for y in range(Globals.floor_map.height):
			for x in range(Globals.floor_map.width):
				if !char.vision_set.has(Vector2i(x,y)):
					gray_fog.set_cell(Vector2i(x,y),0, Vector2i(0,4))
				if !char.explored_set.has(Vector2i(x,y)):
					black_fog.set_cell(Vector2i(x,y),0, Vector2i(0,4))
