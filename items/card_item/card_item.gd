class_name CardItem
extends Item

func on_pick_up(inventory: InventoryComponent) -> bool:
	inventory.add_card_reward()
	return true
