class_name ShivAoe
extends CardEffect

func get_identifier() -> String:
	return "shiv_aoe"
	
func get_description() -> String:
	return "All shivs gain AOE"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	for c in actor.deck.get_all_card_instances():
		if c.card_name == "Shiv":
			# assume the first effect of shiv is the do damage
			var e : DoDamage = c.attack_effects[0]
			e.is_aoe = true
	card_effect_finished.emit()
