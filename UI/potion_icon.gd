class_name PotionIcon
extends TextureButton

var item: Item
var actor: Char

func set_actor(actor: Char):
	self.actor = actor

func set_item(item: Item):
	self.item = item
	$PopupMenu.clear()
	self.texture_normal = item.texture
	for item_action in item.item_actions:
		$PopupMenu.add_item(item_action.action_name)
	
	$DescriptionContainer/Description.text = item.get_description()

func _on_pressed() -> void:
	$PopupMenu.visible = true

func _on_popup_menu_index_pressed(index: int) -> void:
	# emit a signal up to show that an item is selected.
	# item and its action is emitted up
	EventBus.item_used.emit(item, item.item_actions[index])

func _on_mouse_entered() -> void:
	$DescriptionContainer.visible = true


func _on_mouse_exited() -> void:
	$DescriptionContainer.visible = false
