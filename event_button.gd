class_name OptionsButton
extends Button

var actor: Char
var item_action : ItemAction
func set_action(action: ItemAction):
	item_action = action
	text = "[%s] %s" %[item_action.action_name, item_action.get_description()]

func set_user(actor: Char):
	self.actor = actor

func _on_pressed() -> void:
	item_action.use(actor, actor.grid_position)
