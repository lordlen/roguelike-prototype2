class_name WaitAction
extends Action

var actor:Char
func _init(actor: Char):
	self.actor = actor

func execute() -> bool:
	action_finished.emit()
	var wait_indicator := load("res://indicators/wait_indicator.tres")
	actor.spawn_discard_particle(wait_indicator)
	actor.char_waited.emit()
	return true
