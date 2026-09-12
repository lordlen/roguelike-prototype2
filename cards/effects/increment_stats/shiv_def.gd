class_name ShivDef
extends CardEffect

func get_identifier() -> String:
	return "shiv_def"
	
func get_description() -> String:
	return "Temporarily increase this card's defense by how many shivs are in the deck."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var shiv_count := 0
	for c in actor.deck.get_all_card_instances():
		if c.card_name == "Shiv":
			shiv_count += 1

	var def_up := TmpDefUp.new()
	def_up.def_value = shiv_count
	def_up.do(actor, target_pos, card)
	card_effect_finished.emit()
