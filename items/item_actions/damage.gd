class_name Damage
extends ItemAction

@export var damage: int

func get_description() -> String:
	return "Deal %d damage%s." % [damage, get_radius_desc()]

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false

	var target_chars := _get_target_chars(owner, pos)
	if target_chars.is_empty():
		return false

	for target_char in target_chars:
		target_char.take_damage(damage)
	return true
