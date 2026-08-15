class_name Item
extends Resource

@export var item_name: String
@export var texture: Texture
@export var item_actions: Array[ItemAction] = [ItemAction.new()]
@export var display_description_on_hover: bool = true

func get_description() -> String:
	var ret := item_name
	
	for action in item_actions:
		var desc := action.get_description()
		if desc != "":
			ret += "\n%s: %s" % [action.action_name, desc]
	return ret

func on_pick_up(inventory: InventoryComponent) -> bool:
	return inventory.add_item(self)
