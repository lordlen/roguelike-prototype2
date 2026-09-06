class_name MultiShiv
extends CardEffect

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	for c in actor.deck.get_all_card_instances():
		if c.card_name == "Shiv":
			c.num_hits += 1
	card_effect_finished.emit()

func get_identifier() -> String:
	return "multi_shiv"

func get_description() -> String:
	return 'Increase the number of hits of all shivs by 1'
