class_name CardItemGenerator
extends ItemGenerator

@export var card_generator: CardRewardGenerator

func get_item() -> Item:
	var cards := card_generator.generate_card_rewards(1)
	var card = cards[0]
	var item := CardItem.new()
	item.set_card(card)
	return item
