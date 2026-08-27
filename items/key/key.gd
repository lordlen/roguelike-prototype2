class_name KeyResource
extends Item

func on_pick_up(inventory: InventoryComponent) -> bool:
	inventory.add_key(1)
	return true

func get_description() -> String:
	return "Opens locked doors"
