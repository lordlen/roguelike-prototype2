class_name ReshuffleAction
extends Action

var actor:Char
func _init(actor: Char):
	self.actor = actor

func execute() -> bool:
	if len(actor.deck.discard_pile) == 0:
		action_finished.emit(true)
		return true
	actor.char_reshuffled.emit()
	actor.deck.reshuffle()
	action_finished.emit(true)
	return true
