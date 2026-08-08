extends CardEffect

@export var card_resource: CardResource

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_grass := CardHelper.mow_grass(actor.grid_position)
	var card_instance := CardInstance.new(card_resource)
	for i in range(num_grass):
		actor.deck.add_to_draw(card_instance)
	card_effect_finished.emit()
