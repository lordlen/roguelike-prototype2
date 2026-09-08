class_name BlinkAction
extends ItemAction

func get_description() -> String:
	return "Teleport to the selected location (obstructions apply)."

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false

	# check if position has character
	if ActorManager.get_actor_in_position(pos) != null:
		return false
	
	owner.move_to(pos)
	return true
