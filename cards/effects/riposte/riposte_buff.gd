extends CardEffect

var multiplier := 2

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var own_id := identifier
	var attack := "damage"
	
	var list_of_lists := [
		card.attack_effects,
		card.defense_effects,
		card.on_hit_effects,
		card.tmp_attack_effects,
		card.tmp_defense_effects,
		card.tmp_on_hit_effects
	]
	
	var num_removed := 0
	for lst: Array[CardEffect] in list_of_lists:
		for i in range(len(lst) - 1, -1, -1):
			var effect = lst[i]
			if effect.identifier not in [attack, own_id]:
				lst.pop_at(i)
				num_removed += 1
	
	card.attack += num_removed * multiplier
	card_effect_finished.emit()

func get_description() -> String:
	return description % multiplier
