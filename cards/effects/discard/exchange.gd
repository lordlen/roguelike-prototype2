class_name Exchange
extends CardEffect

func get_identifier() -> String:
	return "exchange"

func get_description() -> String:
	return "Switch the top of the discard and the main-hand."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var discard_card : CardInstance = actor.deck.discard_pile.pop_back()
	actor.deck.primary.do_on_discard_effects(actor)
	actor.deck.discard_primary()
	actor.deck.primary = discard_card
	card_effect_finished.emit()
