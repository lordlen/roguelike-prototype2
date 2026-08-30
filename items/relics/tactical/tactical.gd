class_name Tactical
extends Relic

func on_reshuffle(actor: Char):
	# remove decay from the offhand
	if actor.deck.offhand != null:
		actor.deck.offhand.reset_defense_decay()
		EventBus.character_deck_updated.emit(actor)
