class_name CardItem
extends Item

var card: CardResource
func set_card(c: CardResource):
	self.card = c
	texture = c.texture
	item_name = c.name
	display_description_on_hover = false

func on_pick_up(inventory: InventoryComponent) -> bool:
	inventory.owner.deck.add_to_deck_list(card)
	return true

func get_description() -> String:
	var card_instance := CardInstance.new(card)
	EventBus.card_info_requested.emit(card_instance)
	return card.name
