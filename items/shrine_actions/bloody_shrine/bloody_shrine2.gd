class_name BloodyShrine2
extends ItemAction

func get_description() -> String:
	return "Heal 20 hp"

func use(owner: Char, pos: Vector2i) -> bool:
	owner.take_damage(-20)
	return true
