class_name Shrine
extends Item

func on_pick_up(inventory: InventoryComponent) -> bool:
	var owner := inventory.owner
	# open the menu for the event
	EventBus.event_requested.emit(owner, item_name, "", item_actions)
	await EventBus.event_concluded
	return true
