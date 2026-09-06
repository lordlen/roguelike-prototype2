class_name CleanRiposte
extends CardEffect

func get_identifier() -> String:
	return "clean_riposte"
	
func get_description() -> String:
	return 'Remove "riposte" effect.'

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	for i in range(len(card.on_hit_effects) -1, -1, -1):
		var e := card.on_hit_effects[i]
		if e.get_identifier() == "riposte":
			card.on_hit_effects.pop_at(i)
	card_effect_finished.emit()
