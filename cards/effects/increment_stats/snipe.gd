class_name Snipe
extends CardEffect

func get_identifier() -> String:
	return "snipe"
	
func get_description() -> String:
	return "Temporarily increase the attack of this card by n."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# find the distance between actor and target
	var dist := Pathfinder.chebychev_dist(actor.grid_position, target_char.grid_position)
	var tmp_atk_up := TmpAtkUp.new()
	tmp_atk_up.atk_value = dist
	tmp_atk_up.stacks = true
	tmp_atk_up.do(actor, target_char, card)
	card_effect_finished.emit()
