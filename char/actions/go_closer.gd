class_name GoCloserAction
extends Action

var actor: Char
func _init(actor: Char):
	self.actor = actor

func execute() -> bool:
	# using the target flow map, get closer to the target
	var destination := actor.target_flow_map.roll_down(actor.grid_position)

	# attmempt to move to target
	var is_successful := Walk.new(actor, destination).execute()
	if is_successful:
		return true
	
	destination = actor.target_flow_map.roll_down(actor.grid_position, true)
	return Walk.new(actor, destination).execute()
