class_name Gold
extends Item

@export var amount: int

func on_pick_up(inventory: InventoryComponent) -> bool:
	inventory.add_gold(amount)
	return true

func get_description() -> String:
	return "%d gold" % amount
