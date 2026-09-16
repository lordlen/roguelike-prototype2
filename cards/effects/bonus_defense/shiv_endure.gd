class_name ShivEndure
extends CardEffect

func get_identifier() -> String:
	return "shiv_endure"
	
func get_description() -> String:
	return 'Add "On Discard: endure" to all shivs.'

func get_all_nested_card_effects() -> Array[CardEffect]:
	return [self, Endure.new()]

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	for c in actor.deck.get_all_card_instances():
		if c.card_name == "Shiv":
			var endure := Endure.new()
			CardEffect.combine_effects(c.on_discard_effects, [endure])
	
	card_effect_finished.emit()
