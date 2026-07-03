extends CardEffect

@export var card_id: String

func do(attacker: Char, defender: Char, card: CardInstance) -> void:
	var card_resource : CardResource = load(CardResource.card_map[card_id])
	var card_instance := CardInstance.new(card_resource)
	attacker.deck.add_to_draw(card_instance)
	card_effect_finished.emit()
