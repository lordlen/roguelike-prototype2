class_name Walk
extends Action

const walk_speed := 200

var actor: Char
var dest: Vector2i
func _init(actor: Char, dest: Vector2i):
	self.actor = actor
	self.dest = dest

func execute() -> bool:
	var blocking_actor = ActorManager.get_actor_in_position(dest)
	
	# locked door check
	if Globals.floor_map.get_tile(dest).terrain_id == TileResource.Terrains.LOCKED_DOOR\
	and actor.inventory.keys > 0:
		var ground := load("res://floor_generator/tiles/ground.tres")
		Globals.floor_map.update_tile(dest, ground)
		actor.inventory.add_key(-1)
	
	if Globals.floor_map.get_tile(dest).terrain_id == TileResource.Terrains.SANCTUARY:
		var ground := load("res://floor_generator/tiles/ground.tres")
		Globals.floor_map.update_tile(dest, ground)
	
	if !actor.can_traverse(dest) or (blocking_actor != null and blocking_actor.alignment != actor.alignment):
		action_finished.emit(false)
		return false
	
	# prioritize who can swap places to prevent infinite blocking
	if blocking_actor != null and blocking_actor.alignment == actor.alignment:
		# allow movement if actor is the priority
		if actor.char_id < blocking_actor.char_id:
			blocking_actor.move_to(actor.grid_position)
		else:
			action_finished.emit(false)
			return false

	actor.char_walked.emit()
	actor.move_to(dest, walk_speed)
	action_finished.emit(true)
	return true
