class_name DefendAction
extends Action

var actor:Char
func _init(actor: Char):
	self.actor = actor

func execute() -> bool:
	if actor.deck.offhand == null:
		action_finished.emit()
		return false

	actor.deck.offhand.do_defend(actor)
	EventBus.character_deck_updated.emit(actor)
	action_finished.emit()
	return true
