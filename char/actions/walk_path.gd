class_name WalkPath
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
		action_finished.emit(false)
		return false
	else:
		# store this path on the character
		# store actions
		var q_actions = path.slice(2).map(func(v: Vector2i): return Walk.new(actor, v))
		actor.action_queue.append_array(q_actions)
		var result := Walk.new(actor, path[1]).execute()
		action_finished.emit(result)
		return result
