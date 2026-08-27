class_name Catalyst
extends CardEffect

func get_identifier() -> String:
	return "catalyst"
	
func get_description() -> String:
	return 'Deal as much unblockable damage as "Poison" would.'

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var poison: CardInstance = target_char.deck.find_card("Poison")
	if poison != null:
		# get the first effect in the on_draw effect
		var lose_hp : LoseHp = poison.on_draw_effects[0]
		lose_hp.do(target_char, target_char, card)
	card_effect_finished.emit()
