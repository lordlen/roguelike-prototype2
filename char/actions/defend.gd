class_name DefendAction
extends Action

var actor:Char
func _init(actor: Char):
	self.actor = actor

func execute() -> bool:
	if actor.deck.primary == null:
		return false
	
	var is_swift = actor.deck.primary.is_swift
	actor.deck.primary.do_defend(actor)
	EventBus.character_deck_updated.emit(actor)
	return !is_swift
