extends CardEffect

@export var card_resource: CardResource

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_grass := CardHelper.mow_grass(actor.grid_position)
	for i in range(num_grass):
		var card_instance := CardInstance.new(card_resource)
		actor.char_card_added.emit(card_instance)
		actor.deck.add_to_draw(card_instance)
	card_effect_finished.emit()
