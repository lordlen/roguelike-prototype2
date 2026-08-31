class_name ShivSurge
extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var add_card_effect := AddCard.new()
	add_card_effect.card_resource = load("res://cards/card_resources/special/shiv.tres")
	add_card_effect.target = Target.SELF
	add_card_effect.num_cards = len(actor.deck.draw_pile)
	if actor.deck.primary != null:
		add_card_effect.num_cards += 1
	if actor.deck.offhand != null:
		add_card_effect.num_cards += 1
	add_card_effect.do(actor, target_char, card)
	card_effect_finished.emit()

func get_identifier() -> String:
	return "shiv_surge"

func get_description() -> String:
	return 'Add as many "Shiv" cards as cards in the draw pile to the discard pile.'
