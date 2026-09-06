class_name Backpedal
extends CardEffect

func get_identifier() -> String:
	return "backpedal"
	
func get_description() -> String:
	return 'This card gets temporary "1 backslide" on hit.'

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var backslide := Backslide.new()
	backslide.is_temp = true
	
	CardEffect.combine_effects(card.on_hit_effects, [backslide])
	
	card_effect_finished.emit()
