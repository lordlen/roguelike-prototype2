class_name GrassScry
extends CardEffect

func get_identifier() -> String:
	return "grass_scry"

func get_description() -> String:
	return "Destroy adjacent grass tiles. Scry for the number of grass destroyed."

func get_all_nested_card_effects() -> Array[CardEffect]:
	return [self, Scry.new()]

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_cards := CardHelper.mow_grass(actor.grid_position)
	var scry := Scry.new()
	scry.num_cards = num_cards
	scry.do(actor, target_char, card)
	card_effect_finished.emit()
