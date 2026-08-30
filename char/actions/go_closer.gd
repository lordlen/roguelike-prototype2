class_name GoCloserAction
extends Action

var actor: Char
func _init(actor: Char):
	self.actor = actor

func execute() -> bool:
	# using the target flow map, get closer to the target
	var destination := actor.target_flow_map.roll_down(actor.grid_position)

	# attmempt to move to target
	var is_successful := await Walk.new(actor, destination).execute()
	if is_successful:
		action_finished.emit(true)
		return true
	
	destination = actor.target_flow_map.roll_down(actor.grid_position, true)
	var result := await Walk.new(actor, destination).execute()
	action_finished.emit(result)
	return result
