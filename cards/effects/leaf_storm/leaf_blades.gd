class_name Leaf2Shiv
extends CardEffect

func get_identifier() -> String:
	return "leaf2shiv"
	
func get_description() -> String:
	return "Destroy adjacent grass tiles. Add as many shivs to the discard pile as grass destroyed."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_grass := CardHelper.mow_grass(actor.grid_position)
	var card_resource := load("res://cards/card_resources/special/shiv.tres")
	for i in range(num_grass):
		var card_instance := CardInstance.new(card_resource)
		actor.char_card_added.emit(card_instance)
		actor.deck.add_to_discard(card_instance)
	card_effect_finished.emit()
