class_name DefendAction
extends Action

var actor:Char
func _init(actor: Char):
	self.actor = actor

func execute() -> bool:
	if actor.deck.primary == null:
		return false
	
	actor.deck.primary.do_defend(self.actor)
	return true
