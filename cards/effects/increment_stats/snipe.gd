class_name Snipe
extends CardEffect

@export var value: int = 1

func get_identifier() -> String:
	return "snipe"
	
func get_description() -> String:
	return "Temporarily increase the attack by n x distance."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	# find the distance between actor and target
	var dist := Pathfinder.chebychev_dist(actor.grid_position, target_pos)
	var tmp_atk_up := TmpAtkUp.new()
	tmp_atk_up.atk_value = (dist - 1) * value
	tmp_atk_up.stacks = true
	tmp_atk_up.do(actor, target_pos, card)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
