class_name WalkTo
extends Action

var actor: Char
var dest: Vector2i
func _init(actor: Char, dest: Vector2i):
	self.actor = actor
	self.dest = dest

func execute() -> bool:
	var pf = Pathfinder.new()
	var path = pf.find_path(actor.traversal, actor.grid_position, dest)
	if len(path) < 2:
		return false
	else:
		return Walk.new(actor, path[1]).execute()
	
