class_name UseItemAction
extends Action

var actor: Char
var item: Item
var item_action: ItemAction
var pos: Vector2i

func _init(actor: Char, item: Item, item_action: ItemAction, pos: Vector2i):
	self.actor = actor
	self.item = item
	self.item_action = item_action
	self.pos = pos

func execute() -> bool:
	# get the path
	var pf :=  Pathfinder.new()
	# flying so ignore any kind of terrain except walls
	var path := pf.get_straight_path(actor.grid_position, pos, Char.Traversal.FLYING)
	
	# get the last element of the path
	var dest := path[len(path) - 1]

	var is_successful := await item_action.use(actor, dest)

	if is_successful:
		actor.inventory.remove_item(item)

	action_finished.emit()
	return item_action.uses_turn
