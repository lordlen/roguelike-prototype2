extends CardEffect

@export var card_resource: CardResource
@export var num_cards: int

func do(actor: Char, target: Char, card: CardInstance) -> void:
	var card_instance := CardInstance.new(card_resource)
	for i in range(num_cards):
		actor.char_card_added.emit(card_instance)
		actor.deck.add_to_draw(card_instance)
	card_effect_finished.emit()

func get_full_description(card: CardInstance) -> String:
	return "%s %s" % [num_cards, super.get_full_description(card)]

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [num_cards, super.get_shortform(card)]
