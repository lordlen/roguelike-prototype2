class_name RecallEffect
extends CardEffect

func get_identifier() -> String:
	return "recall"
	
func get_description() -> String:
	return 'Put "Cast Spell" on top of the draw pile.'

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# find in discard
	var cs = actor.deck.pop_card("Cast Spell")
	if cs != null:
		actor.deck.add_to_top_draw(cs)
	card_effect_finished.emit()
