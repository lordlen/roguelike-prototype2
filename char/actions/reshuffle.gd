class_name ReshuffleAction
extends Action

var actor:Char
func _init(actor: Char):
	self.actor = actor

func execute() -> bool:
	actor.deck.reshuffle()
	actor.char_reshuffled.emit()
	action_finished.emit()
	return true
