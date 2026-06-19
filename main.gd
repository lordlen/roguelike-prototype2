extends Node

func _ready() -> void:
	randomize()
	EventBus.character_fov_updated.connect(_update_fog)
	EventBus.new_actor_added.connect(on_new_actor_added)
	
	$Terrain.initialize_floor()
	
	ActorManager.spawn_hero()
	ActorManager.spawn_enemies()

func on_new_actor_added(char: Char):
	$ActorList.add_child(char)

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
		
