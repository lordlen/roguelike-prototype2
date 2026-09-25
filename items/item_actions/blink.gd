class_name BlinkAction
extends ItemAction

func get_description() -> String:
	return "Teleport to the selected location (obstructions apply)."

func use(owner: Char, pos: Vector2i) -> bool:
	await do_animation(owner, pos)
	owner.move_to(pos)
	return true
