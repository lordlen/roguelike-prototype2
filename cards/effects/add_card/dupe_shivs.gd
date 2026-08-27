class_name DupeShiv
extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_cards := 0
	for c in actor.deck.get_all_card_instances():
		if c.card_name == "Shiv":
			num_cards += 1
	
	var shiv := Shiv.new()
	shiv.num_cards = num_cards
	shiv.do(actor, target_char, card)
	card_effect_finished.emit()

func get_identifier() -> String:
	return "dupe_shivs"

func get_description() -> String:
	return 'Add as many "Shiv" cards as shivs in the deck to the discard pile.'
