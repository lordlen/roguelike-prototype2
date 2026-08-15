class_name ActivationTile
extends Item

func on_pick_up(inventory: InventoryComponent) -> bool:
	var owner := inventory.owner
	for action in item_actions:
		action.use(owner, owner.grid_position)
	return true
