class_name Imbue
extends CardEffect

func get_identifier() -> String:
	return "imbue"
	
func get_description() -> String:
	return 'Gain "n mana" where n is the top card\'s attack.'

func get_all_nested_card_effects() -> Array[CardEffect]:
	return [self, Mana.new()]

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	if !actor.deck.draw_pile.is_empty():
		var top := actor.deck.draw_pile[-1]
		var mana := Mana.new()
		mana.value = top.attack
		mana.do(actor, target_pos, top)
	card_effect_finished.emit()
