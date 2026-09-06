class_name DualCast
extends CardEffect

func get_identifier() -> String:
	return "split_mana"
	
func get_description() -> String:
	return 'Duplicate "Cast Spell". Halve the attack and defense values of "Cast Spell".'

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	# check if "cast spell" is in the deck.
	var cs = actor.deck.find_card("Cast Spell")
	# duplicates are the same instance.
	if cs != null:
		cs.attack /= 2
		cs.defense /= 2
		actor.deck.add_to_discard(cs)
		
	card_effect_finished.emit()
