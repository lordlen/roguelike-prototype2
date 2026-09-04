class_name Siphon
extends CardEffect

func get_identifier() -> String:
	return "siphon"
	
func get_description() -> String:
	return 'Add the "heal_atk" effect to "Cast Spell".'

func get_all_nested_card_effects() -> Array[CardEffect]:
	return [self, HealAttack.new()]

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# check if "cast spell" is in the deck.
	var cs = actor.deck.find_card("Cast Spell")
	if cs == null:
		# create a cast spell card
		var cs_resource := load("res://cards/card_resources/special/cast_spell.tres")
		cs = CardInstance.new(cs_resource)
		actor.char_card_added.emit(cs)
		actor.deck.add_to_discard(cs)

	var heal_atk := HealAttack.new()
	CardEffect.combine_effects(cs.attack_effects, [heal_atk])
	card_effect_finished.emit()
