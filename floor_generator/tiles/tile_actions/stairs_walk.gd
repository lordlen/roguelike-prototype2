class_name StairsWalk
extends ItemAction

func use(owner: Char, pos: Vector2i) -> bool:
	if owner.user_controlled:
		owner.action_queue.clear()
		EventBus.stairs_popup_signal.emit()
	# change tile to trampled grass.
	return true
