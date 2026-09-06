class_name MainRelocate
extends CardEffect

func get_identifier() -> String:
	return "main_relocate"
	
func get_description() -> String:
	return 'Give "Relocate" to own main hand.'

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	if actor.deck.primary:
		var relocate := Relocate.new()
		CardEffect.combine_effects(actor.deck.primary.attack_effects, [relocate])
	card_effect_finished.emit()
