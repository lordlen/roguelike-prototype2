class_name DefendAction
extends Action

var actor:Char
func _init(actor: Char):
	self.actor = actor

func execute() -> bool:
	if actor.deck.offhand == null:
		action_finished.emit()
		return false

	#actor.deck.offhand.do_defend(actor)
	actor.char_defended.emit(actor)
	EventBus.character_deck_updated.emit(actor)
	var defend_indicator := load("res://indicators/defend_indicator.tres")
	actor.spawn_discard_particle(defend_indicator)
	await actor.get_tree().create_timer(0.5).timeout
	action_finished.emit()
	return true
