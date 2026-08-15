class_name Heal
extends ItemAction

# heals percent of missing hp
@export var heal_fraction: float

func get_description() -> String:
	return "Heal %.0f%% of max hp%s." % [heal_fraction * 100, get_radius_desc()]

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false
	
	var target_chars := _get_target_chars(pos)
	if target_chars.is_empty():
		return false
	
	for target_char in target_chars:
		var max_hp = target_char.max_hp
		var healing_amount = floor(max_hp * heal_fraction)
		# take negative damage
		target_char.take_damage(-healing_amount)
	return true
