class_name WaterBall
extends CardEffect

func get_identifier() -> String:
	return "waterball"
	
func get_description() -> String:
	return "Destroy adjacent water. Temporarily increase hits of this card by the number of water destroyed."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var num_water := CardHelper.drain_water(actor.grid_position)
	var tmp_hits_up := TmpHitsUp.new()
	tmp_hits_up.value = num_water
	tmp_hits_up.do(actor, target_pos, card)
	
	card_effect_finished.emit()
