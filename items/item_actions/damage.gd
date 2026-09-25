class_name Damage
extends ItemAction

@export var damage: int

func get_description() -> String:
	return "Deal %d damage%s." % [damage, get_radius_desc()]

func use(owner: Char, pos: Vector2i) -> bool:

	var target_chars := _get_target_chars(owner, pos)
	
	await do_animation(owner, pos)

	for target_char in target_chars:
		target_char.take_damage(damage)
	return true
