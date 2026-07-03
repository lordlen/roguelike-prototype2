class_name BloodyShrine2
extends ItemAction

func get_description() -> String:
	return "Heal 15 hp"

func use(owner: Char, pos: Vector2i) -> bool:
	owner.take_damage(-15)
	return true
